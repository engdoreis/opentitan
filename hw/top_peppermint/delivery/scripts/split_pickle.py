#!/usr/bin/env python3
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
"""Split a pickled Peppermint into three deliverable files.

  <prefix>prim_generic_m1.sv  the technology layer: every design unit that came
                              from a prim_generic FuseSoC core, i.e. the cells an
                              integrator replaces with technology equivalents.
  <prefix>top_packages_m1.sv  the packages needed to instantiate the top
  <prefix>peppermint_rtl_m1.sv  everything else, top module included.
"""
import argparse
import os
import re
import sys

import yaml

# Packages that make up the top-packages file, without the pickle's prefix.
TOP_PACKAGES = [
    # named by lowrisc_top_peppermint's port list
    "ahb_pkg",
    "lc_ctrl_pkg",
    "prim_alert_pkg",
    "prim_mubi_pkg",
    "tlul_pkg",
    "top_peppermint_pkg",
    # their dependency chain
    "lc_ctrl_reg_pkg",
    "lc_ctrl_state_pkg",
    "prim_secded_pkg",
    "prim_util_pkg",
    "top_pkg",
]

# Keywords that open and close a design unit, and their nesting partners.
OPENERS = ("module", "package", "interface", "program")
CLOSERS = {"end" + kw for kw in OPENERS}
KEYWORD_RE = re.compile(r"(?<![A-Za-z0-9_$])("
                        + "|".join(OPENERS + tuple(CLOSERS))
                        + r")(?![A-Za-z0-9_$])")
IDENT_RE = re.compile(r"[A-Za-z_][A-Za-z0-9_$]*")
SCOPE_RE = re.compile(r"(?<![A-Za-z0-9_$])([A-Za-z_][A-Za-z0-9_$]*)\s*::")
IMPORT_RE = re.compile(r"(?<![A-Za-z0-9_$])import\s+([A-Za-z_][A-Za-z0-9_$]*)\s*::")
DECL_RE = re.compile(r"^\s*(module|package|interface|program)\s+(\w+)", re.M)


def strip_comments(text):
    """Blank out comments and string literals, keeping line structure intact."""
    out = []
    i, n = 0, len(text)
    while i < n:
        c = text[i]
        if c == "/" and i + 1 < n and text[i + 1] == "/":
            j = text.find("\n", i)
            i = n if j < 0 else j
        elif c == "/" and i + 1 < n and text[i + 1] == "*":
            j = text.find("*/", i + 2)
            j = n if j < 0 else j + 2
            out.append("\n" * text.count("\n", i, j))
            i = j
        elif c == '"':
            j = i + 1
            while j < n and text[j] != '"':
                j += 2 if text[j] == "\\" else 1
            i = min(j + 1, n)
        else:
            out.append(c)
            i += 1
    return "".join(out)


class Unit:
    def __init__(self, kind, name, start):
        self.kind, self.name, self.start = kind, name, start
        self.end = None          # exclusive
        self.text = ""           # gap before the unit + the unit itself
        self.code = ""           # comment-free, for reference scanning

    def __repr__(self):
        return f"<{self.kind} {self.name} lines {self.start}-{self.end}>"


def parse_units(lines, code_lines):
    """Split the file into design units.

    Each unit carries the text from the end of the previous unit up to its own
    end, so the units together account for every line of the input: banner
    comments, commented-out code and compilation-unit-scope declarations (e.g.
    the `$unit` typedefs in aes_sbox_dom.sv) travel with the unit that follows
    them, which is where they have to stay to remain visible.
    """
    units, depth, cur = [], 0, None
    for lineno, code in enumerate(code_lines):
        pos = 0
        while True:
            m = KEYWORD_RE.search(code, pos)
            if not m:
                break
            kw, pos = m.group(1), m.end()
            if kw in OPENERS:
                if depth == 0:
                    name_m = IDENT_RE.search(code, pos)
                    name = name_m.group(0) if name_m else f"<anon@{lineno}>"
                    cur = Unit(kw, name, lineno)
                depth += 1
            else:
                depth -= 1
                if depth == 0 and cur is not None:
                    cur.end = lineno + 1
                    units.append(cur)
                    cur = None
    if depth != 0 or cur is not None:
        sys.exit(f"error: unbalanced design units (depth {depth}) -- parser confused")
    if not units:
        sys.exit("error: no design units found")

    pos = 0
    for u in units:
        u.text = "".join(lines[pos:u.end])          # gap + unit
        u.code = "\n".join(code_lines[u.start:u.end])
        pos = u.end
    units[-1].text += "".join(lines[pos:])          # trailing gap

    if "".join(u.text for u in units) != "".join(lines):
        sys.exit("error: units do not reconstruct the input file -- refusing to split")

    # Warn about compilation-unit-scope code, which is legal but travels with
    # whichever unit follows it and is therefore worth knowing about.
    for u in units:
        gap = u.text[:len(u.text) - sum(len(x) for x in lines[u.start:u.end])]
        gap_code = strip_comments(gap).strip()
        if gap_code:
            first = next(line for line in gap_code.splitlines() if line.strip())
            print(f"    $unit-scope code before {u.name}: {first.strip()[:60]}")
    return units


def closure(seeds, pkg_code, packages):
    """Transitively expand a set of package names over package-to-package refs."""
    seen, work = set(), list(seeds)
    while work:
        p = work.pop()
        if p in seen or p not in packages:
            continue
        seen.add(p)
        body = pkg_code[p]
        work += [r for r in SCOPE_RE.findall(body) if r in packages]
        work += [r for r in IMPORT_RE.findall(body) if r in packages]
    return seen


def generic_unit_names(bender_yml, prefix):
    """Design-unit names of the `generic` bender target, with the pickle prefix."""
    with open(bender_yml) as fh:
        manifest = yaml.safe_load(fh)
    files = None
    for block in manifest["sources"]:
        if isinstance(block, dict) and block.get("target") == "generic":
            files = block["files"]
    if files is None:
        sys.exit(f"error: no 'generic' target in {bender_yml}")
    names = set()
    for path in files:
        with open(path) as fh:
            for _, name in DECL_RE.findall(strip_comments(fh.read())):
                names.add(prefix + name)
    return names


def main():
    # hw/top_peppermint/delivery/scripts -> repo root -> the FuseSoC build dir.
    repo_root = os.path.normpath(
        os.path.join(os.path.dirname(os.path.abspath(__file__)), *[".."] * 4))
    default_yml = os.path.join(
        repo_root, "build", "lowrisc_systems_top_peppermint_0.1",
        "lint-verilator", "Bender.yml")

    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("pickle", help="pickled SystemVerilog file to split")
    ap.add_argument("--bender-yml", default=os.path.normpath(default_yml),
                    help="manifest used for the pickle, for the generic target's file list")
    ap.add_argument("--prefix", default="lowrisc_", help="prefix passed to bender pickle")
    ap.add_argument("--top", default="lowrisc_top_peppermint", help="top-level module name")
    ap.add_argument("--outdir", help="output directory (default: out)", default="out")
    args = ap.parse_args()

    with open(args.pickle) as fh:
        text = fh.read()
    lines = text.splitlines(keepends=True)
    code_lines = strip_comments(text).splitlines()
    code_lines += [""] * (len(lines) - len(code_lines))

    units = parse_units(lines, code_lines)
    packages = {u.name for u in units if u.kind == "package"}
    pkg_code = {u.name: u.code for u in units if u.kind == "package"}
    print(f"==> {len(units)} design units ({len(packages)} packages, "
          f"{sum(1 for u in units if u.kind == 'module')} modules)")

    top = next((u for u in units if u.name == args.top and u.kind == "module"), None)
    if top is None:
        sys.exit(f"error: top module '{args.top}' not found in {args.pickle}")

    # 1. The technology layer.
    generic_names = generic_unit_names(args.bender_yml, args.prefix)
    generic = [u for u in units if u.name in generic_names]
    if not generic:
        sys.exit("error: no prim_generic design units found in the pickle")

    # 2a. The hardcoded selection, checked against what the pickle actually has.
    top_pkgs = {args.prefix + p for p in TOP_PACKAGES}
    unknown = sorted(p for p in top_pkgs if p not in packages)
    if unknown:
        sys.exit("error: TOP_PACKAGES names packages the pickle does not have: "
                 + " ".join(unknown) + "\n       re-derive the list (see its comment)")
    missing = set()
    for p in top_pkgs:
        refs = set(SCOPE_RE.findall(pkg_code[p])) | set(IMPORT_RE.findall(pkg_code[p]))
        missing |= {r for r in refs if r in packages and r not in top_pkgs and r != p}
    if missing:
        sys.exit("error: TOP_PACKAGES is not closed, add: "
                 + " ".join(sorted(m[len(args.prefix):] for m in missing)))
    print(f"    top packages: {len(top_pkgs)} (hardcoded, dependency chain complete)")

    # 2b. Plus what the technology layer needs, since it is read before the RTL.
    generic_pkgs = {u.name for u in generic if u.kind == "package"}
    gen_seeds = set()
    for u in generic:
        gen_seeds |= {r for r in SCOPE_RE.findall(u.code) if r in packages}
        gen_seeds |= {r for r in IMPORT_RE.findall(u.code) if r in packages}
    hoisted = closure(gen_seeds, pkg_code, packages) - generic_pkgs - top_pkgs
    if hoisted:
        print(f"    hoisted for the generic layer: {' '.join(sorted(hoisted))}")
    top_pkgs |= hoisted

    # 3. Assign every unit to exactly one file, preserving the original order,
    #    then check the read order: no package may be referenced before it is
    #    declared. Anything that is, gets hoisted into the packages file and the
    #    check repeats, so trimming the seed set can never produce files that do
    #    not compile.
    order = ["top_packages", "generic", "rtl"]
    for attempt in range(10):
        groups = {"generic": [], "top_packages": [], "rtl": []}
        for u in units:
            if u.name in generic_names:
                groups["generic"].append(u)
            elif u.kind == "package" and u.name in top_pkgs:
                groups["top_packages"].append(u)
            else:
                groups["rtl"].append(u)

        assigned = sum(len(v) for v in groups.values())
        if assigned != len(units):
            sys.exit(f"error: partition is not complete ({assigned} of {len(units)})")

        declared, bad = set(), []
        for group in order:
            for u in groups[group]:
                for ref in set(SCOPE_RE.findall(u.code)) | set(IMPORT_RE.findall(u.code)):
                    if ref in packages and ref not in declared and ref != u.name:
                        bad.append((group, u.name, ref))
                if u.kind == "package":
                    declared.add(u.name)
        if not bad:
            break

        stuck = {ref for _, _, ref in bad} & generic_pkgs
        if stuck:
            sys.exit(f"error: {' '.join(sorted(stuck))} would have to precede the "
                     "technology layer and be part of it -- no valid read order")
        extra = {ref for _, _, ref in bad} - top_pkgs
        if not extra:
            sys.exit(f"error: {len(bad)} forward package reference(s) that hoisting "
                     "cannot fix, e.g. " + str(bad[0]))
        print("    hoisted to keep the read order valid: "
              f"{' '.join(sorted(e[len(args.prefix):] for e in extra))}")
        top_pkgs |= closure(extra, pkg_code, packages)
    else:
        sys.exit("error: could not settle on a valid read order")

    # Every line of the pickle must survive exactly once: putting the grouped
    # units back in their original order has to reproduce the input byte for byte.
    regrouped = sorted((u for g in order for u in groups[g]), key=lambda u: u.start)
    if "".join(u.text for u in regrouped) != "".join(u.text for u in units):
        sys.exit("error: the three groups do not reconstruct the pickle")

    outdir = args.outdir or os.path.dirname(os.path.abspath(args.pickle))
    banner = {
        "generic": "Technology layer: the prim_generic cells and their packages. Replace\n"
                   "// these with technology-specific equivalents.",
        "top_packages": f"Packages required to instantiate {args.top}: those naming types on\n"
                        "// its port list, plus their dependency chain. Packages appearing only\n"
                        "// in parameter defaults are in the RTL file.",
        "rtl": f"Peppermint RTL, including {args.top} itself.",
    }
    names = {
        "generic": f"{args.prefix}prim_generic_m1.sv",
        "top_packages": f"{args.prefix}top_packages_m1.sv",
        "rtl": f"{args.prefix}peppermint_rtl_m1.sv",
    }
    for i, group in enumerate(order):
        path = os.path.join(outdir, names[group])
        with open(path, "w") as fh:
            fh.write(f"// {banner[group]}\n//\n")
            fh.write("// Generated by split_pickle.py -- do not edit by hand. The three\n"
                     "// lowrisc_*_m1.sv files are one compilation unit and must be read in\n"
                     f"// this order: {' '.join(names[g] for g in order)}\n"
                     f"// This is file {i + 1} of {len(order)}.\n\n")
            for u in groups[group]:
                fh.write(u.text)
                if not u.text.endswith("\n"):
                    fh.write("\n")
        pkgs = sum(1 for u in groups[group] if u.kind == "package")
        mods = sum(1 for u in groups[group] if u.kind == "module")
        print(f"==> {names[group]}: {pkgs} packages, {mods} modules, "
              f"{os.path.getsize(path) / 1e6:.1f} MB")


if __name__ == "__main__":
    main()
