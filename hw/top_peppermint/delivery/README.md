# Peppermint 1.0 M1 Delivery

## Release Naming

Release tags have the form `Peppermint-<major>.<minor>-M<milestone>[-RC<n>]`,
so this delivery is `Peppermint-1.0-M1-RC0`.  Release candidates count from
`RC0`, and the final release of a milestone drops the suffix altogether
(`Peppermint-1.0-M1`).

The two counters have separate jobs.  The milestone is a planned delivery point
in the program schedule.  The version tracks the integration contract: the minor
version increments for a backward-compatible change, the major version
increments for a breaking/backward-incompatible change.  Backward compatibility
is to be defined more precisely.  A milestone number can therefore recur under a
later version, because an unplanned re-delivery is a version bump rather than a
new milestone, and one version can span several milestones.

Deliverable names follow from the tag mechanically: lowercase it, replace `-`
with `_`, and replace `.` with `p`, which gives
`lowrisc_top_peppermint_1p0_m1_rc0`.  The `p` keeps the version clear of suffix
extraction.  With a literal dot, the usual way to strip a `.tar.gz` suffix,
cutting everything from the first dot, would truncate the name to
`lowrisc_top_peppermint_1`.

The names of the archive and the directory inside it carry this full identity;
the names of the source files inside carry none of it, so an integrator's file
lists and tool scripts stay valid across deliveries.  Each file instead names
the release in a header comment, which survives being copied out of the
archive, so `split_pickle.py` takes the identifier as `--release`.

## Reproducing the Flow

`scripts/generate_out.sh` regenerates the deliverables in `out/` from the RTL in
the tree.  It needs `fusesoc`, `bender` and `python3` on `PATH`; see [Tool
Versions](#tool-versions) below.
```sh
./scripts/generate_out.sh
```

Run it after every RTL change that reaches the top, in the same commit as that
change.  `out/` is meant to match the RTL at every commit, not just at release
time, so that the log associates a change in the deliverables with the change
that caused it.  FuseSoC copies the sources into its build directory and the
pickle is built from that copy, so nothing short of a full re-run picks a change
up.

The script stamps the release identifier that `out/` already carries into the
regenerated files, because `scripts/create_release.py` restamps all of them at
release time anyway.  `--release` sets a different one.  `--keep-pickle` keeps
the intermediate `lowrisc_peppermint.sv` for inspection instead of deleting it.
```sh
./scripts/generate_out.sh --release Peppermint-1.0-M1-RC6 --keep-pickle
```

### What the Script Does

1. Runs FuseSoC's `lint` setup target and converts the Edalize manifest it
   writes into a bender manifest (`util/edalize_to_bender.py`).
2. Pickles the design with `bender pickle`, which prefixes every design unit
   with `lowrisc_`.
3. Repairs the package references that bender's renaming misses
   (`scripts/fix_pickle_prefix.py`, see `pulp-platform/bender#338`).
4. Splits the pickle into the deliverable files (`scripts/split_pickle.py`).
5. Normalises those files.  Bender's macro expansion leaves trailing whitespace
   behind, and the vendored PULP debug-module sources spell their Solderpad
   licence notice with typographic quotes, which are exempt from the ASCII check
   only because they sit under `vendor/`, an exemption the pickle does not
   inherit.  Left alone, both trip this repository's checks and show up as lint
   noise for the recipient.
6. Copies `../doc/memories.toml`, appending the release identifier to its
   title, and regenerates `out/memories.md` from that copy
   (`util/memory_macro_to_md.py`), which carries the identifier over into the
   heading.

The script's comments explain the individual steps in more detail, including the
two quirks of `util/fix_trailing_whitespace.py` that are easy to get wrong by
hand: it only works when run from the repository root, and it exits non-zero
when it changes a file, which is the normal outcome here rather than an error.

CI enforces this.  `ci/scripts/check-delivery-out.sh` regenerates `out/` in the
`gen` lint category and fails if the result differs from what is committed, so
a change that moves the deliverables cannot merge without them.  Reproduce it
with `nix run .#lint -- gen`.

### What the Script Does Not Touch

`out/README.md`, `out/interfaces.md` and `out/lowrisc_top_peppermint_wrapper.sv`
are maintained by hand.  Update them in the same commit as the change that makes
them wrong.

### Tool Versions
* `bender 0.32.1`, pinned by the `nixpkgs-bender` input in `flake.nix` so that
  local runs and CI agree.  Change the two together.
* `tar (GNU tar) 1.35`
* `gzip 1.14`


## Release

The deliverables land in `out/`.  See [`out/README.md`](out/README.md), which
ships with them, for what each file contains and the order they must be read
in.

`scripts/create_release.py` turns them into a release.  It stamps the release
identifier into every file in `out/`, commits that on a release branch, opens a
pull request, tags the merged commit, packs the archive, and opens a draft
GitHub release whose notes Claude drafts from the commits since the previous
release.
```sh
python3 scripts/create_release.py --version 1.0 --milestone 1 --release-candidate 0
```

Drop `--release-candidate` for the final release of a milestone.  The script
runs as a sequence of named steps and stops for confirmation before each step
that anyone else can see.  Every step is idempotent, so an interrupted run can
be resumed with `--from-step`; since waiting for the pull request to be merged
usually takes longer than one sitting, the second half is normally run on its
own.
```sh
python3 scripts/create_release.py --version 1.0 --milestone 1 --release-candidate 0 \
    --from-step verify-merge
```

`--until-step` stops the sequence early, so a run can end before the steps that
reach GitHub. Naming the same step in both options runs that step on its own,
which is how a single step is redone -- repacking an archive that was deleted
locally, for instance, or re-running an upload that failed.
```sh
python3 scripts/create_release.py --version 1.0 --milestone 1 --release-candidate 0 \
    --from-step archive --until-step archive
```

Redoing `archive` assumes `out/` still matches the tag, because that is where the
archive takes its dates from. Deliverables that have changed need their own
release candidate and tag rather than a repack under the old one.

The archive is reproducible: it takes its file dates from the release tag and
fixes the permissions and ownership, so the same tag packs the same bytes with
the same `tar` and `gzip` (see Tool Versions above).

`--dry-run` prints rather than runs every command that reaches the remote,
GitHub or the archive, which leaves a release commit to inspect and throw away.
