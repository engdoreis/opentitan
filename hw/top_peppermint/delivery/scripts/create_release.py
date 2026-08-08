#!/usr/bin/env python3
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
"""Create a Peppermint release from the deliverables in `out/`.

The release runs as a sequence of named steps: stamp the release identifier into
every file in `out/`, commit that on a release branch, open a pull request, tag
the merged commit, pack the archive, and open a draft GitHub release whose notes
are drafted by Claude from the commits since the previous release.

Every step is idempotent and the sequence pauses at each point that needs a
human decision, so an interrupted run can be resumed with `--from-step`.  Since
waiting for the pull request to be merged usually takes longer than one sitting,
the second half is normally run as `--from-step verify-merge`.
"""
import argparse
import functools
import re
import shlex
import subprocess
import sys
from pathlib import Path

REPO = "lowRISC/opentitan-embargoed-peppermint"

DELIVERY_DIR = Path(__file__).resolve().parent.parent
OUT_DIR = DELIVERY_DIR / "out"

# The release stamp sits within this many lines of the top of a file.
HEAD_LINES = 10

TAG_RE = r"Peppermint-\d+\.\d+-M\d+(?:-RC\d+)?"
# The stamp in every file but `out/README.md`, which carries the tag in prose.
STAMP_RE = re.compile(rf"Release ({TAG_RE})")
README_STAMP_RE = re.compile(rf"^# Peppermint \S+ M\d+ Deliverable.*\(`({TAG_RE})`\)\s*$")

CHANGES_PROMPT = """\
Below is the log of the commits between the previous release ({previous}) and
the upcoming release ({tag}) of Peppermint, a hardware design delivered as
SystemVerilog source.  Write the "What changed" section of the release notes.

Rules:
- Output the bullet list and nothing else: no heading, no preamble, no summary.
- One bullet per change, one sentence each, starting with "- ".
- Start each sentence with Add, Remove, Fix, or Change, in the infinitive.
- Group the bullets by that leading verb, in the order Add, Remove, Fix, Change.
- Describe the effect on the deliverable, not the implementation detail.  Fold
  commits that add up to one change into one bullet and leave out churn that
  does not reach the delivered files.

Commits, newest first, separated by a line with three dashes:

"""

DRY_RUN = False


class Release:
    """Every name derived from the release identity, built in one place."""

    def __init__(self, version, milestone, candidate):
        self.version = version
        self.milestone = milestone
        self.candidate = candidate

        rc_tag = f"-RC{candidate}" if candidate is not None else ""
        rc_title = f" RC{candidate}" if candidate is not None else ""
        rc_prose = f" - Release Candidate {candidate}" if candidate is not None else ""
        rc_name = f"_rc{candidate}" if candidate is not None else ""

        self.tag = f"Peppermint-{version}-M{milestone}{rc_tag}"
        self.branch = f"peppermint-{version}-m{milestone}{rc_tag.lower()}"
        self.subject = f"[peppermint,delivery] Release {self.tag}"
        self.tag_message = f"Peppermint {version} - Milestone {milestone}{rc_prose}"
        self.title = f"Peppermint {version} M{milestone}{rc_title}"
        self.heading = f"# Peppermint {version} - Milestone {milestone}{rc_prose}"
        self.readme_line = (f"# Peppermint {version} M{milestone} Deliverable{rc_prose}"
                            f" (`{self.tag}`)")
        # The archive name follows from the tag: lowercase, `-` to `_`, `.` to `p`.
        name = f"lowrisc_top_peppermint_{version.replace('.', 'p')}_m{milestone}{rc_name}"
        self.archive = DELIVERY_DIR / f"{name}.tar.zst"
        self.archive_dir = name

    def previous(self):
        """The release this one succeeds, as (tag, label), or (None, None).

        The first candidate of a milestone and the first milestone of a version
        have no predecessor, and so no "What changed" section.
        """
        if self.candidate:
            tag = f"Peppermint-{self.version}-M{self.milestone}-RC{self.candidate - 1}"
        elif self.candidate is None and self.milestone:
            tag = f"Peppermint-{self.version}-M{self.milestone - 1}"
        else:
            return (None, None)
        return (tag, self.label_for(tag))

    def label_for(self, tag):
        """The short name a release goes by within this version, e.g. RC2 or M0."""
        match = re.fullmatch(rf"Peppermint-{re.escape(self.version)}-(M\d+)(?:-(RC\d+))?", tag)
        if not match:
            return tag
        return match.group(2) or match.group(1)


def run(*cmd, capture=False, stdin=None, skip_dry=False):
    """Run `cmd` in the delivery directory.

    `skip_dry` marks a command that reaches the remote, GitHub or the file system
    outside the repository; under --dry-run those are printed instead of run,
    while local git operations still happen so the result can be inspected.
    """
    if skip_dry and DRY_RUN:
        print("    would run: " + " ".join(shlex.quote(str(c)) for c in cmd))
        return ""
    result = subprocess.run([str(c) for c in cmd], cwd=DELIVERY_DIR, input=stdin,
                            text=True, check=True,
                            stdout=subprocess.PIPE if capture else None)
    return result.stdout if capture else ""


def git(*args, **kwargs):
    return run("git", *args, **kwargs)


def git_out(*args):
    return git(*args, capture=True).strip()


def gh_out(*args):
    """Run a read-only `gh` query, returning None if it fails (e.g. not found)."""
    result = subprocess.run(["gh", *[str(a) for a in args]], cwd=DELIVERY_DIR, text=True,
                            stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
    return result.stdout.strip() if result.returncode == 0 else None


def confirm(question):
    try:
        answer = input(f"{question} [y/N] ")
    except (EOFError, KeyboardInterrupt):
        sys.exit("\naborted")
    if answer.strip().lower() not in ("y", "yes"):
        sys.exit("aborted")


def repo_of(url):
    """The `owner/name` a GitHub remote URL points at, lowercased, or None."""
    match = re.search(r"[:/]([^/:]+/[^/:]+)$", url.removesuffix(".git"))
    return match.group(1).lower() if match else None


@functools.cache
def remote():
    """The name of the git remote whose push URL is REPO.

    The tag and the release must end up in the same repository, so the remote is
    looked up rather than assumed to be `origin`.
    """
    names = sorted({fields[0] for line in git_out("remote", "-v").splitlines()
                    for fields in [line.split()]
                    if fields[2:] == ["(push)"] and repo_of(fields[1]) == REPO.lower()})
    if not names:
        sys.exit(f"error: no git remote pushes to {REPO}; add one with "
                 f"`git remote add <name> git@github.com:{REPO}.git`")
    if len(names) > 1:
        return "origin" if "origin" in names else sys.exit(
            f"error: {', '.join(names)} all push to {REPO}; cannot tell which to use")
    return names[0]


@functools.cache
def default_branch():
    try:
        ref = git_out("symbolic-ref", f"refs/remotes/{remote()}/HEAD")
    except subprocess.CalledProcessError:
        sys.exit(f"error: {remote()} has no default branch recorded; "
                 f"run `git remote set-head {remote()} --auto`")
    return ref.rsplit("/", 1)[-1]


def out_files():
    return sorted(p for p in OUT_DIR.iterdir() if p.is_file())


def split_head(text):
    lines = text.splitlines(keepends=True)
    return lines[:HEAD_LINES], lines[HEAD_LINES:]


def find_stamp(path, head):
    """Locate the release stamp in `head` as (line index, match), or None.

    `out/README.md` carries the release in prose on its first line; every other
    file carries it as `Release <tag>`.  Requiring that anchor is what keeps
    prose references to a milestone, such as "tied to zero in
    `Peppermint-1.0-M1`", from being mistaken for a stamp.
    """
    if path.name == "README.md":
        match = README_STAMP_RE.match(head[0]) if head else None
        return (0, match) if match else None
    hits = [(i, m) for i, line in enumerate(head) for m in [STAMP_RE.search(line)] if m]
    if len(hits) > 1:
        sys.exit(f"error: {path} carries {len(hits)} release stamps, expected one")
    return hits[0] if hits else None


def stamped_tag(path):
    """The release tag stamped into `path`, or None if there is none."""
    head, _ = split_head(path.read_text())
    found = find_stamp(path, head)
    return found[1].group(1) if found else None


def stamp_file(path, release):
    """Rewrite the release stamp in `path`.  Returns True if the file changed."""
    text = path.read_text()
    head, tail = split_head(text)
    found = find_stamp(path, head)
    if not found:
        detail = ("its first line is not the deliverable heading" if path.name == "README.md"
                  else f"no `Release <tag>` line in its first {HEAD_LINES} lines")
        sys.exit(f"error: {path} carries no release stamp: {detail}")

    index, match = found
    line = head[index]
    if path.name == "README.md":
        head[index] = release.readme_line + line[len(line.rstrip("\r\n")):]
    else:
        head[index] = line[:match.start()] + f"Release {release.tag}" + line[match.end():]

    stamped = "".join(head + tail)
    if stamped == text:
        return False
    path.write_text(stamped)
    return True


# --- steps ------------------------------------------------------------------

def step_check_tree(release, args):
    """Refuse to work on a dirty tree, and warn if HEAD is not the branch point."""
    if git_out("status", "--porcelain"):
        sys.exit("error: working directory is not clean; commit or stash first")
    git("fetch", remote(), "--tags")

    base = f"{remote()}/{default_branch()}"
    behind, ahead = git_out("rev-list", "--left-right", "--count",
                            f"{base}...HEAD").split()
    if behind != "0" or ahead != "0":
        print(f"warning: HEAD is {ahead} commit(s) ahead of and {behind} behind {base}")
        if ahead != "0":
            print(git("log", "--oneline", f"{base}..HEAD", capture=True))
        confirm(f"Cut {release.branch} from HEAD rather than from {base}?")


def step_branch(release, args):
    """Create the release branch and check it out."""
    if git_out("rev-parse", "--abbrev-ref", "HEAD") == release.branch:
        print(f"==> already on {release.branch}")
        return
    if git_out("branch", "--list", release.branch):
        git("switch", release.branch)
    else:
        git("switch", "-c", release.branch)


def step_stamp(release, args):
    """Replace the release stamp in every file in out/."""
    files = out_files()
    changed = [p for p in files if stamp_file(p, release)]
    for path in changed:
        print(f"    stamped {path.name}")
    print(f"==> stamped {release.tag} into {len(changed)} of {len(files)} file(s)")


def step_commit(release, args):
    """Commit the new stamps."""
    if not git_out("status", "--porcelain", "--", str(OUT_DIR)):
        if git_out("log", "-1", "--format=%s") == release.subject:
            print("==> release commit already exists")
            return
        sys.exit("error: nothing to commit and HEAD is not the release commit")
    git("add", "--", str(OUT_DIR))
    git("commit", "-s", "-m", release.subject)


def step_review_commit(release, args):
    """Show the release commit for review."""
    git("--no-pager", "show", "--stat")
    git("--no-pager", "show")
    confirm("Is the release commit correct?")


def step_pr(release, args):
    """Push the release branch and open a pull request."""
    git("push", "-u", remote(), release.branch, skip_dry=True)
    url = gh_out("pr", "view", release.branch, "-R", REPO, "--json", "url", "--jq", ".url")
    if url:
        print(f"==> pull request already open: {url}")
        return
    run("gh", "pr", "create", "-R", REPO, "-H", release.branch, "-B", default_branch(),
        "-t", release.title, "-b", "", skip_dry=True)


def step_await_merge(release, args):
    """Wait for the pull request to be approved and merged."""
    confirm("Has the pull request been approved and merged?")


def step_verify_merge(release, args):
    """Check out the default branch and verify the release commit is its tip."""
    branch = default_branch()
    if git_out("rev-parse", "--abbrev-ref", "HEAD") != branch:
        git("switch", branch)
    git("pull", "--ff-only")

    subject = git_out("log", "-1", "--format=%s")
    if subject != release.subject:
        sys.exit(f"error: {branch} tip is {subject!r}, expected {release.subject!r}; "
                 "has the release commit been merged?")
    for path in out_files():
        if stamped_tag(path) != release.tag:
            sys.exit(f"error: {path} is stamped {stamped_tag(path)}, expected {release.tag}")
    print(f"==> {release.subject} is the tip of {branch}")


def step_tag(release, args):
    """Create the annotated release tag."""
    if git_out("tag", "--list", release.tag):
        if git_out("rev-list", "-1", release.tag) != git_out("rev-parse", "HEAD"):
            sys.exit(f"error: tag {release.tag} exists but does not point at HEAD")
        print(f"==> tag {release.tag} already exists")
        return
    git("tag", "-a", release.tag, "-m", release.tag_message)


def step_review_tag(release, args):
    """Show the release tag for review."""
    git("--no-pager", "show", "--stat", release.tag)
    confirm("Is the release tag correct?")


def step_push_tag(release, args):
    """Push the release tag."""
    if git_out("ls-remote", "--tags", remote(), f"refs/tags/{release.tag}"):
        print(f"==> tag {release.tag} already pushed")
        return
    git("push", remote(), release.tag, skip_dry=True)


def step_archive(release, args):
    """Pack the deliverables into the release archive."""
    # --transform renames out/ to the deliverable name inside the archive, so it
    # unpacks into a directory named after the release.  The remaining flags keep
    # the archive reproducible and free of local uid/gid.
    run("tar", "-I", "zstd -19 -T0",
        "-cf", release.archive.name,
        "--transform", f"s,^out,{release.archive_dir},",
        "--owner=0", "--group=0", "--numeric-owner", "--sort=name",
        "out", skip_dry=True)
    print(f"==> {release.archive}")


def step_draft_release(release, args):
    """Draft the release notes and create the draft GitHub release."""
    body = release.heading + "\n"
    previous_tag, previous_label = release.previous()
    if args.previous_tag:
        previous_tag = args.previous_tag
        previous_label = release.label_for(previous_tag)
    if previous_tag:
        if not git_out("tag", "--list", previous_tag):
            sys.exit(f"error: previous release {previous_tag} is not a tag; "
                     "pass --previous-tag to name it explicitly")
        body += f"\n## What changed since {previous_label}\n\n"
        body += change_list(release, previous_tag, previous_label) + "\n"

    print(body)
    confirm("Are the release notes correct?")

    if gh_out("release", "view", release.tag, "-R", REPO, "--json", "url"):
        print(f"==> draft release for {release.tag} already exists, notes unchanged")
    else:
        prerelease = ["-p"] if release.candidate is not None else []
        run("gh", "release", "create", "-d", "-R", REPO, "--verify-tag", release.tag,
            *prerelease, "-t", release.title, "-F", "-", stdin=body, skip_dry=True)
    run("gh", "release", "upload", "-R", REPO, "--clobber", release.tag,
        release.archive, skip_dry=True)


def step_publish(release, args):
    """Point at the draft release for review and publication."""
    url = (gh_out("release", "view", release.tag, "-R", REPO, "--json", "url", "--jq", ".url")
           or f"https://github.com/{REPO}/releases/tag/{release.tag}")
    print(f"==> review and publish the draft release: {url}")


STEPS = [
    ("check-tree", step_check_tree),
    ("branch", step_branch),
    ("stamp", step_stamp),
    ("commit", step_commit),
    ("review-commit", step_review_commit),
    ("pr", step_pr),
    ("await-merge", step_await_merge),
    ("verify-merge", step_verify_merge),
    ("tag", step_tag),
    ("review-tag", step_review_tag),
    ("push-tag", step_push_tag),
    ("archive", step_archive),
    ("draft-release", step_draft_release),
    ("publish", step_publish),
]


def change_list(release, previous_tag, previous_label):
    """Have Claude write the list of changes since `previous_tag`."""
    log = git("log", "--no-merges", "--format=%s%n%b%n---", f"{previous_tag}..HEAD",
              capture=True)
    if not log.strip():
        sys.exit(f"error: no commits between {previous_tag} and HEAD")
    prompt = CHANGES_PROMPT.format(previous=previous_label, tag=release.tag) + log
    try:
        result = subprocess.run(["claude", "-p"], cwd=DELIVERY_DIR, input=prompt,
                                text=True, stdout=subprocess.PIPE)
    except FileNotFoundError:
        sys.exit("error: `claude` not found in PATH")
    changes = result.stdout.strip()
    if result.returncode != 0 or not changes:
        sys.exit("error: `claude` did not return a list of changes")
    return changes


def version(text):
    if not re.fullmatch(r"\d+\.\d+", text):
        raise argparse.ArgumentTypeError(f"{text!r} is not of the form MAJOR.MINOR")
    return text


def non_negative(text):
    if not re.fullmatch(r"\d+", text):
        raise argparse.ArgumentTypeError(f"{text!r} is not a non-negative integer")
    return int(text)


def main():
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("-v", "--version", required=True, type=version,
                        help="release version, MAJOR.MINOR")
    parser.add_argument("-m", "--milestone", required=True, type=non_negative,
                        help="milestone number")
    parser.add_argument("--release-candidate", type=non_negative,
                        help="release candidate number; omit for the final release")
    parser.add_argument("--previous-tag",
                        help="release the notes compare against, if not the preceding "
                             "release candidate or milestone")
    parser.add_argument("--from-step", choices=[name for name, _ in STEPS],
                        default=STEPS[0][0], help="step to resume from")
    parser.add_argument("--dry-run", action="store_true",
                        help="print rather than run every command that reaches the "
                             "remote, GitHub or the archive")
    args = parser.parse_args()

    # Keep our own output interleaved with the output of the commands we run.
    sys.stdout.reconfigure(line_buffering=True)

    global DRY_RUN
    DRY_RUN = args.dry_run

    release = Release(args.version, args.milestone, args.release_candidate)
    first = [name for name, _ in STEPS].index(args.from_step)
    for name, step in STEPS[first:]:
        print(f"\n### {name}: {step.__doc__.splitlines()[0]}")
        step(release, args)


if __name__ == "__main__":
    main()
