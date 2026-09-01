#!/usr/bin/env python3
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
"""Convert TOML memory macros to a Markdown table."""

import sys
import tomllib
from pathlib import Path


def header_label(key: str, meta: dict[str, str]) -> str:
    # Example: converts "data_size" into "Data Size (KiB)"
    label = key.replace("_", " ").title()
    if unit := meta.get("unit"):
        if unit not in key and len(unit) < 5:
            label += f" ({unit})"
    return label


def format_row(cells: list[str], col_widths: list[int]) -> str:
    padded = (cell.rjust(col_widths[index]) for index, cell in enumerate(cells))
    return "| " + " | ".join(padded) + " |\n"


def main() -> None:
    memory_macros = Path(sys.argv[1])
    with open(memory_macros, "rb") as f:
        data = tomllib.load(f)

    keys = list(data["keys"].keys())
    headers = [header_label(k, data["keys"][k]) for k in keys]

    col_widths = [len(h) for h in headers]
    rows = []
    for mem in data["memory_macros"].values():
        row = [str(mem[k]) for k in keys]
        for i, cell in enumerate(row):
            col_widths[i] = max(col_widths[i], len(cell))
        rows.append(row)

    memory_markdown = memory_macros.with_suffix('.md')
    with open(memory_markdown, "w") as f:
        # The TOML's title becomes the document heading, so that the Markdown
        # carries the same title as the TOML it was generated from.
        f.write(f"# {data['title']}\n\n")
        f.write(format_row(headers, col_widths))
        sep = "| " + " | ".join("-" * w for w in col_widths) + " |\n"
        f.write(sep)
        for row in rows:
            f.write(format_row(row, col_widths))


if __name__ == "__main__":
    main()
