#!/usr/bin/env python3
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
"""mdbook preprocessor rendering the IP maturity table of a top.

Unlike the {{#dashboard}} preprocessor, the list of IPs is not maintained by hand: it is
derived from the resolved top definition, so an IP added to the top appears automatically.

Usage in a Markdown page:

    {{#ipstages top_peppermint }}

Standalone preview, which prints the table for a top without running the book:

    ./util/mdbook_ip_stages.py --preview top_darjeeling
"""

import argparse
import json
import os
import re
import sys
from functools import cache
from pathlib import Path
from typing import Any, NamedTuple

import hjson

import mdbook.utils as md_utils

REPO_TOP = Path(__file__).resolve().parents[1]

IPSTAGES_PATTERN = re.compile(r'\{\{#ipstages\s+?(.+?)\s*\}\}')

# A block under `hw/ip` is integrated as it stands and is shared with the other tops. A block
# under one of the top's own directories exists only for this top.
ORIGIN_COMMON = "common"
ORIGIN_TOP_SPECIFIC = "top specific"

# SUMMARY.md is a list of links and nothing else, so every link in it is a book page.
SUMMARY = REPO_TOP / "SUMMARY.md"
SUMMARY_LINK_PATTERN = re.compile(r'\]\(\./([^)\s#]+)')

HEADER = (
    "| **Block** | **Instances** | **Origin** | **Design stage** | **Verification stage** "
    "| **Evidence** |\n"
    "|---|---|---|---|---|---|\n"
)


class IpSource(NamedTuple):
    """The description an IP's stages were read from, and where that description came from."""

    hjson: Path
    origin: str


@cache
def book_pages() -> frozenset[str]:
    """The repository-relative paths SUMMARY.md lists.

    mdbook builds exactly the pages SUMMARY.md names, so this is also the set of pages that
    can be linked to. A Markdown file sitting on disk but missing from SUMMARY.md is never
    rendered, and a link to it resolves to a 404.
    """
    return frozenset(SUMMARY_LINK_PATTERN.findall(SUMMARY.read_text()))


def find_ip_source(top: str, ip_type: str) -> IpSource | None:
    """Locate the hjson describing an IP type, and say where it came from.

    The location gives the origin. A block under `hw/ip` is common: it is integrated unchanged
    and carries whatever stage the shared description records. A block under the top's own
    `ip_autogen` or `ip` directory is top specific, so its description belongs to this top.
    """
    for candidate, origin in (
        (REPO_TOP / f"hw/{top}/ip_autogen/{ip_type}/data/{ip_type}.hjson", ORIGIN_TOP_SPECIFIC),
        (REPO_TOP / f"hw/{top}/ip/{ip_type}/data/{ip_type}.hjson", ORIGIN_TOP_SPECIFIC),
        (REPO_TOP / f"hw/ip/{ip_type}/data/{ip_type}.hjson", ORIGIN_COMMON),
    ):
        if candidate.exists():
            return IpSource(candidate, origin)
    return None


def read_stages(cfg: dict[str, Any]) -> tuple[str | None, str | None]:
    """Return the current design and verification stage of an IP, or None where unrecorded.

    Two schemas are in use. Newer descriptions carry a `revisions` list, where the last entry
    is the current one. Older ones carry the fields at the top level.
    """
    revisions = cfg.get("revisions")
    source = revisions[-1] if revisions else cfg
    return source.get("design_stage"), source.get("verification_stage")


def stage_cell(stage: str | None, ip_hjson: Path) -> str:
    """One stage cell, naming the file that would hold the stage when nothing is recorded.

    A bare "none" reads as a block with no progress rather than as a block whose description
    never carried the field, which is the case that actually needs acting on.
    """
    return stage if stage is not None else f"not in `{ip_hjson.name}`"


def checklist_cell(checklist: Path, page_dir: Path) -> str:
    """A link to a block's checklist, or why there is no link to give.

    Linking a checklist takes more than the file existing: mdbook builds only what SUMMARY.md
    lists, so a link to an unlisted page lands on a 404 rather than on the file next to it.
    """
    if not checklist.exists():
        return "no checklist page"
    if checklist.relative_to(REPO_TOP).as_posix() not in book_pages():
        return "checklist not in the book"
    return f"[checklist]({_relative(page_dir, checklist)})"


def top_gen_path(top: str) -> Path:
    """The resolved top definition, the single source for which blocks the top instantiates."""
    return REPO_TOP / f"hw/{top}/data/autogen/{top}.gen.hjson"


def xbar_row(top: str, top_cfg: dict[str, Any], page_dir: Path) -> str:
    """One row covering the crossbars, which the top definition lists apart from the IPs.

    A crossbar is generated per top from the connection map and carries no description of its
    own, so there is no stage to read. TL-UL itself is tracked centrally in
    `hw/ip/tlul/data/tlul.prj.hjson`, whose entry is scoped to the Earlgrey crossbar instances,
    so it says nothing about the crossbars generated for another top. Where a top does keep a
    crossbar checklist of its own, that page is the evidence and is linked.
    """
    xbars = top_cfg.get("xbar", [])
    if not xbars:
        return ""

    names = ", ".join(f"xbar_{xbar['name']}" for xbar in sorted(xbars, key=lambda x: x["name"]))
    checklist = REPO_TOP / f"hw/{top}/ip/xbar/doc/checklist.md"
    return (f"| `xbar` | {names} | {ORIGIN_TOP_SPECIFIC} "
            f"| no description file | no description file "
            f"| {checklist_cell(checklist, page_dir)} |\n")


def collect_rows(top: str, page_dir: Path) -> list[str]:
    """Build one table row per IP type instantiated in the top, plus one for the crossbars."""
    top_cfg = hjson.loads(top_gen_path(top).read_text())

    instances: dict[str, list[str]] = {}
    for module in top_cfg.get("module", []):
        instances.setdefault(module["type"], []).append(module["name"])

    rows = []
    for ip_type in sorted(instances):
        names = ", ".join(sorted(instances[ip_type]))
        source = find_ip_source(top, ip_type)
        if source is None:
            rows.append(f"| `{ip_type}` | {names} "
                        f"| unknown | unknown | unknown | no description file |\n")
            continue

        design, verification = read_stages(hjson.loads(source.hjson.read_text()))

        checklist = source.hjson.parent.parent / "doc" / "checklist.md"
        rows.append(f"| `{ip_type}` | {names} | {source.origin} "
                    f"| {stage_cell(design, source.hjson)} "
                    f"| {stage_cell(verification, source.hjson)} "
                    f"| {checklist_cell(checklist, page_dir)} |\n")

    rows.append(xbar_row(top, top_cfg, page_dir))
    return rows


def _relative(page_dir: Path, target: Path) -> str:
    """Absolute `target`, rewritten relative to the page being rendered.

    `os.path.relpath` rather than pathlib, because `Path.relative_to` cannot walk upwards.
    """
    return os.path.relpath(target, REPO_TOP / page_dir)


def render(top: str, page_dir: Path) -> str:
    """The table for one top, or a note in place of it when there is nothing to tabulate.

    A note reads as prose, so an ungenerated top does not render as a table with one wide cell
    and five empty ones. An unknown top is a typo in the directive and stays loud, since a
    reader is told to expect the ungenerated case and must not mistake one for the other.
    """
    if not (REPO_TOP / f"hw/{top}").is_dir():
        return f"**`{top}` is not a top under `hw/`. Check the `ipstages` directive.**\n"

    top_gen = top_gen_path(top)
    if not top_gen.exists():
        rel = top_gen.relative_to(REPO_TOP)
        return (f"This table is generated from the resolved top definition, `{rel}`, "
                "which this repository does not carry yet.\n"
                "It fills in on the next book build once that file is committed.\n")

    return HEADER + "".join(collect_rows(top, page_dir))


def main() -> None:
    """Serve the mdbook preprocessor protocol on stdin, or print one table under --preview."""
    parser = argparse.ArgumentParser()
    parser.add_argument("--preview", metavar="TOP",
                        help="print the table for TOP and exit, for use outside the book")
    args, _rest = parser.parse_known_args()

    if args.preview:
        print(render(args.preview, Path(f"hw/{args.preview}/doc")))
        return

    md_utils.supports_html_only()

    _context, book = json.load(sys.stdin)

    for chapter in md_utils.chapters(book["sections"]):
        # A draft chapter, a SUMMARY.md entry with an empty link, carries "path": null and no
        # content, so there is nothing to substitute and no directory to make links relative to.
        path = chapter.get("path")
        if path is None:
            continue

        page_dir = Path(path).parent
        chapter["content"] = IPSTAGES_PATTERN.sub(
            lambda m: render(m.group(1), page_dir),
            chapter["content"])

    print(json.dumps(book))


if __name__ == "__main__":
    main()
