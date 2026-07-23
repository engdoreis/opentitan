#!/usr/bin/env python3
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
"""Render a yosys `stat -liberty ... -json` dump as a hierarchical kGE table.

Usage: area_report.py <area.json> <out.md> [--top <module-name>]

Walks the actual keep_hierarchy tree top_peppermint.ys built (top_peppermint
-> peppermint_pd_{main,aon} -> IP blocks -> any further-kept leaves such as
ahb_bridge's ahb_{to,from}_tlul or the SRAM/ROM prim_* macros), rather than
assuming a flat two-level structure. Each module's "area" in the JSON is
already the *cumulative* figure (rolls up all of its kept children,
regardless of the -hierarchy flag); this script also derives each module's
*local* (own-logic-only) area by subtracting its direct children's
cumulative areas, so nothing is double-counted between a container (e.g.
peppermint_pd_main) and the blocks nested inside it.
"""
import argparse
import json
import sys

GE_PER_K = 1000.0


def plain_name(name):
    """'aes$top_peppermint.peppermint_pd_main.u_aes' -> 'aes'."""
    return name.split("$", 1)[0]


def elaboration_path(name):
    """'aes$top_peppermint.peppermint_pd_main.u_aes'
    -> 'top_peppermint.peppermint_pd_main.u_aes'; 'top_peppermint' unchanged.
    """
    return name.split("$", 1)[1] if "$" in name else name


def load_modules(area_json):
    with open(area_json) as fh:
        data = json.load(fh)
    # Module names in the JSON are backslash-prefixed ("public" RTLIL names);
    # strip that once so lookups elsewhere don't have to worry about it.
    return {name.lstrip("\\"): info for name, info in data["modules"].items()}


def build_children(modules):
    """A module M is a *direct* child of module P if P has a cell whose type
    is exactly M's name -- i.e. M's key appears among P's num_cells_by_type
    entries. This is exactly how yosys represents "P instantiates M" and
    holds regardless of nesting depth, so it correctly recovers the whole
    keep_hierarchy tree (not just a fixed two-level structure).

    The value carried along is the instance count, which matters as soon as a
    parent instantiates the same module more than once: the parent's local area
    has to lose all N copies, and the child's row has to account for all N.
    yosys-slang happens to give every instance its own module (the elaboration
    path is part of the name), so today every count is 1 -- but the arithmetic
    must not depend on that.
    """
    children = {name: [] for name in modules}
    is_child = set()
    for name, info in modules.items():
        for cell_type, count in (info.get("num_cells_by_type") or {}).items():
            if cell_type in modules:
                children[name].append((cell_type, count))
                is_child.add(cell_type)
    return children, is_child


def walk(modules, children, root):
    """Pre-order DFS from `root`, yielding one row per module:
    (depth, name, relative_instance_path, local_area, total_area, instances,
     shared).

    Areas are aggregated over every instance in the design: the multiplier is
    carried down the tree, so a block's Total is what it actually contributes to
    the top and the percentages stay additive.
    """
    rows = []
    seen = {}

    def visit(name, depth, parent_path, mult):
        info = modules[name]
        cum_area = info.get("area", 0.0)
        kids = sorted(children[name],
                      key=lambda kv: -modules[kv[0]].get("area", 0.0) * kv[1])
        local_area = cum_area - sum(modules[c].get("area", 0.0) * n
                                    for c, n in kids)

        path = elaboration_path(name)
        if parent_path and path.startswith(parent_path + "."):
            rel = path[len(parent_path) + 1:]
        else:
            rel = path

        # A module reachable under two different kept parents is counted in both
        # of their local areas, so it has to be listed under both -- but flag it
        # and stop, rather than walking (and re-attributing) its subtree twice.
        shared = name in seen
        rows.append((depth, name, rel, local_area * mult, cum_area * mult,
                     mult, shared))
        if shared:
            return
        seen[name] = path
        for c, n in kids:
            visit(c, depth + 1, path, mult * n)

    visit(root, 0, None, 1)
    return rows


def render_markdown(top_name, rows):
    top_area = rows[0][4] if rows else 0.0
    header = ["Block", "Instance", "Insts", "Local kGE", "Total kGE", "% of top"]

    table_rows = []
    for depth, name, rel, local_area, cum_area, insts, shared in rows:
        indent = "-" * depth + (" " if depth else "")
        block = f"{indent}{plain_name(name)}" + (" (shared)" if shared else "")
        pct = 100.0 * cum_area / top_area if top_area else 0.0
        bold = depth == 0
        insts_s = str(insts)
        # Subtracting children from a container that has no logic of its own
        # lands a hair below zero, which would print as a puzzling "-0.00".
        local_k = local_area / GE_PER_K
        local_s = f"{local_k if abs(local_k) >= 0.005 else 0.0:.2f}"
        total_s = f"{cum_area / GE_PER_K:.2f}"
        pct_s = f"{pct:.1f}%"
        inst = rel.rsplit(".", 1)[-1]
        if bold:
            block, inst, insts_s, local_s, total_s, pct_s = (
                f"**{block}**",
                f"**{inst}**",
                f"**{insts_s}**",
                f"**{local_s}**",
                f"**{total_s}**",
                f"**{pct_s}**",
            )
        table_rows.append([block, inst, insts_s, local_s, total_s, pct_s])

    # Pandoc's pipe-table writer sizes columns from the *dash count* in the
    # separator row, not from actual cell content, a bare "---" gives every
    # column equal width no matter how long its content is.
    widths = [
        max(len(header[i]), max((len(r[i]) for r in table_rows), default=0))
        for i in range(len(header))
    ]
    aligns = ["l", "l", "r", "r", "r", "r"]

    def sep(i):
        dashes = max(3, widths[i] - (1 if aligns[i] == "r" else 0))
        return "-" * dashes + (":" if aligns[i] == "r" else "")

    lines = [
        f"# {top_name} synthesis area report",
        "",
        "Areas in kGE (synthetic NAND-gate-equivalent liberty units, minimal optimizations).",
        "Hard macros area is not accounted for.",
        "",
        "Local = own logic only; Total = Local plus everything nested under it, "
        "aggregated over all instances; Insts = instances in the design.",
        "",
        "| " + " | ".join(header) + " |",
        "|" + "|".join(sep(i) for i in range(len(header))) + "|",
    ]
    for row in table_rows:
        lines.append("| " + " | ".join(row) + " |")
    lines.append("")
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("area_json")
    parser.add_argument("out_md")
    parser.add_argument("--top", default="top_peppermint")
    args = parser.parse_args()

    modules = load_modules(args.area_json)
    if args.top not in modules:
        sys.exit(
            f"error: top module '{args.top}' not found in {args.area_json}")

    children, is_child = build_children(modules)
    rows = walk(modules, children, args.top)

    # A module in the JSON that the walk never reaches would be silently absent
    # from the report, so say so. Anything nobody instantiates is a second root.
    reached = {name for _, name, *_ in rows}
    missing = sorted(set(modules) - reached)
    if missing:
        print(f"warning: {len(missing)} module(s) in {args.area_json} are not "
              f"reachable from '{args.top}' and are absent from the report:",
              file=sys.stderr)
        for name in missing:
            role = "instantiated but not under the top" if name in is_child \
                   else "never instantiated (second root?)"
            print(f"           {name} -- {role}", file=sys.stderr)

    markdown = render_markdown(args.top, rows)

    with open(args.out_md, "w") as fh:
        fh.write(markdown)

    print(f"==> wrote {len(rows)} rows (hierarchical) to {args.out_md}",
          file=sys.stderr)


if __name__ == "__main__":
    main()
