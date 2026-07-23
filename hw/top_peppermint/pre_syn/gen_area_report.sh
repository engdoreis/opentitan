#!/usr/bin/env bash
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Renders out/area.json (from top_peppermint.ys) into out/area_report.md and
# out/area_report.pdf (via pandoc).
#
# Usage: ./gen_area_report.sh   (run after top_peppermint.ys)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AREA_JSON="$SCRIPT_DIR/out/area.json"
OUT_MD="$SCRIPT_DIR/out/area_report.md"
OUT_PDF="$SCRIPT_DIR/out/area_report.pdf"

if [[ ! -f "$AREA_JSON" ]]; then
  echo "ERROR: $AREA_JSON not found -- run top_peppermint.ys first" >&2
  exit 1
fi

python3 "$SCRIPT_DIR/area_report.py" "$AREA_JSON" "$OUT_MD"

pandoc -f markdown-smart "$OUT_MD" -o "$OUT_PDF" -V geometry:margin=1in
echo "==> wrote $OUT_PDF" >&2
