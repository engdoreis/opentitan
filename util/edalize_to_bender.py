#!/usr/bin/env python3
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
"""Convert a FuseSoC .eda.yml into a Bender.yml.

Splits sources into an `rtl` target (everything) and a `generic` target
(prim_generic cores only).
"""
import argparse
import os
import sys

import yaml

RTL_FILE_TYPES = {"systemVerilogSource", "verilogSource"}


def is_generic(core):
    # FuseSoC core names look like "lowrisc:prim_generic:<name>:<ver>".
    parts = core.split(":")
    return len(parts) > 1 and parts[1] == "prim_generic"


def globalize(eda_dir, local_name):
    return os.path.realpath(os.path.join(eda_dir, local_name))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("eda_yml", help="FuseSoC .eda.yml input")
    parser.add_argument("--name", help="package name (default: toplevel)")
    args = parser.parse_args()

    eda_dir = os.path.dirname(os.path.abspath(args.eda_yml))
    bender_yml = os.path.join(eda_dir, "Bender.yml")
    with open(args.eda_yml) as fh:
        eda = yaml.safe_load(fh)

    rtl_files = []
    generic_files = []
    incdirs = []
    seen_incdirs = set()
    for f in eda["files"]:
        if f.get("file_type") not in RTL_FILE_TYPES:
            continue
        global_name = globalize(eda_dir, f["name"])
        if f.get("is_include_file"):
            # Expose the directory as an include path instead of a source.
            incdir = os.path.dirname(global_name)
            if incdir not in seen_incdirs:
                seen_incdirs.add(incdir)
                incdirs.append(incdir)
            continue
        if is_generic(f.get("core", "")):
            generic_files.append(global_name)
        else:
            rtl_files.append(global_name)

    bender = {
        "package": {
            "name": args.name or eda["toplevel"],
        },
        "export_include_dirs": incdirs,
        "sources": [
            {"target": "rtl", "files": rtl_files},
            {"target": "generic", "files": generic_files},
        ],
    }

    with open(bender_yml, "w") as out:
        out.write("# Auto-generated from edalize output -- do not edit by hand.\n")
        yaml.safe_dump(bender, out, sort_keys=False, default_flow_style=False)

    print(
        f"==> wrote {len(rtl_files)} rtl files, {len(generic_files)} generic "
        f"files, {len(incdirs)} incdirs to {bender_yml}",
        file=sys.stderr,
    )


if __name__ == "__main__":
    main()
