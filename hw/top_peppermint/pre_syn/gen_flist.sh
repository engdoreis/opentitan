#!/usr/bin/env bash
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Generate a slang/yosys-slang compatible file list for top_peppermint.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_TOP="$(cd "$SCRIPT_DIR/../../.." && pwd)"
HW_ROOT="$REPO_TOP/hw"

CORE="lowrisc:systems:top_peppermint"
CORE_VERSIONED="$CORE:0.1"
TARGET="${1:-syn}"

BUILD_ROOT="$SCRIPT_DIR/build"
FLIST_OUT="$SCRIPT_DIR/top_peppermint.f"

echo "==> Resolving $CORE (target=$TARGET) with FuseSoC..." >&2
rm -rf "$BUILD_ROOT"
fusesoc --cores-root "$HW_ROOT" run \
  --target="$TARGET" --setup --no-export \
  --build-root "$BUILD_ROOT" \
  --mapping "$CORE_VERSIONED" \
  "$CORE" >&2

EDA_YML="$(find "$BUILD_ROOT" -name '*.eda.yml' -print -quit)"
if [[ -z "$EDA_YML" ]]; then
  echo "ERROR: FuseSoC did not produce an .eda.yml under $BUILD_ROOT" >&2
  exit 1
fi

echo "==> Converting local (sandbox-relative) names in $EDA_YML to global (absolute) names..." >&2
python3 "$SCRIPT_DIR/eda_yml_to_flist.py" "$EDA_YML" "$FLIST_OUT"

echo "==> Flist ready: $FLIST_OUT" >&2
echo "$FLIST_OUT"
