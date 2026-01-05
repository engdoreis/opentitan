#!/usr/bin/env bash
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

set -e

. util/build_consts.sh

./bazelisk.sh run //sw/host/opentitantool -- --interface=hyperdebug_dfu transport update-firmware

target_pattern_file="$(mktemp)"
./bazelisk.sh query 'attr("tags", "[\[ ]cw310_sival_rom_ext[,\]]", tests(//sw/device/...))' \
  | grep -v examples \
  | grep -v penetrationtests \
  >> "$target_pattern_file" 

    # --//signing:token=//signing/tokens:cloud_kms_sival \
./bazelisk.sh test \
    --define DISABLE_VERILATOR_BUILD=true \
    --test_output=errors \
    --build_tests_only \
    --flaky_test_attempts=2 \
    --target_pattern_file="${target_pattern_file}"
