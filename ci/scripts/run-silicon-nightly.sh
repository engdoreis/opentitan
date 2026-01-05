#!/usr/bin/env bash
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

set -e

. util/build_consts.sh


BAZEL_TAGS=(
    "cw310_sival_rom_ext"
    "cw310_sival"
)

# Create a temporary file to store all patterns
target_pattern_file="$(mktemp)"

for tag in "${BAZEL_TAGS[@]}"; do
    # Construction of the attribute regex to match: [tag, or [ tag, or ,tag, or ,tag]
    # This handles the specific Bazel tag formatting inside the query
  TAG_REGEX="[\[ ]${tag}[,\]]"
  echo "Querying tag: $tag ..."
  ./bazelisk.sh query "attr('tags', '$TAG_REGEX', tests(//sw/device/...))" 2>/dev/null \
    | grep -v examples \
    | grep -v penetrationtests \
    >> "$target_pattern_file" 
done
echo "Updating hyperdebug ..."
./bazelisk.sh run //sw/host/opentitantool -- --interface=hyperdebug_dfu transport update-firmware --force
    # --//signing:token=//signing/tokens:cloud_kms_sival \

echo "Checking bitstream cache ..."
./bazelisk.sh sync --configure

echo "Running tests ... $target_pattern_file"
./bazelisk.sh test \
    --define DISABLE_VERILATOR_BUILD=true \
    --test_output=errors \
    --build_tests_only \
    --flaky_test_attempts=2 \
    --target_pattern_file="${target_pattern_file}"
