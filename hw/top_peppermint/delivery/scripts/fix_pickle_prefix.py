#!/usr/bin/env python3
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
"""Repair package references that `bender pickle --prefix` failed to rename.

bender 0.32.1 renames every package *declaration* and almost every scoped
reference, but misses a package-scoped name that appears inside the packed
dimension of a declaration whose data type is itself package-scoped, e.g.

    input lowrisc_prim_alert_pkg::alert_tx_t [alert_handler_pkg::NAlerts-1:0] x

Here the type scope was renamed and the dimension's was not, so the resulting
file does not elaborate ("unknown class or package 'alert_handler_pkg'").

This rewrites `<name>::` to `<prefix><name>::` for every `<name>` for which
`<prefix><name>` is declared as a package in the same file, which is exactly
the set bender should have renamed. Idempotent.
"""
import argparse
import re
import sys


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("pickle", help="pickled SystemVerilog file, edited in place")
    parser.add_argument("--prefix", default="lowrisc_", help="prefix passed to bender pickle")
    parser.add_argument("--dry-run", action="store_true", help="only report what would change")
    args = parser.parse_args()

    with open(args.pickle) as fh:
        text = fh.read()

    declared = set(re.findall(r"^package\s+(\w+)\s*;", text, re.MULTILINE))
    renamable = {p[len(args.prefix):] for p in declared if p.startswith(args.prefix)}
    if not renamable:
        sys.exit(f"error: no packages with prefix '{args.prefix}' declared in {args.pickle}")

    # A reference is stale if the bare name is not itself declared (so we never
    # touch a package that legitimately has no prefix) and the prefixed name is.
    stale = sorted(n for n in renamable if n not in declared)
    pattern = re.compile(r"(?<![A-Za-z0-9_])(" + "|".join(map(re.escape, stale)) + r")::")

    hits = {}
    for m in pattern.finditer(text):
        hits[m.group(1)] = hits.get(m.group(1), 0) + 1
    if not hits:
        print(f"==> nothing to fix in {args.pickle}")
        return

    for name, count in sorted(hits.items(), key=lambda kv: -kv[1]):
        print(f"    {count:4d}x {name}:: -> {args.prefix}{name}::")
    if args.dry_run:
        return

    text = pattern.sub(rf"{args.prefix}\1::", text)
    with open(args.pickle, "w") as fh:
        fh.write(text)
    print(f"==> fixed {sum(hits.values())} reference(s) in {args.pickle}")


if __name__ == "__main__":
    main()
