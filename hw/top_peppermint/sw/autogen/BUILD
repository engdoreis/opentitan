# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------#
# PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
# util/topgen.py -t hw/top_peppermint/data/top_peppermint.hjson
#                -o hw/top_peppermint/

load("//rules:linker.bzl", "ld_library")
load("//hw/top:defs.bzl", "opentitan_require_top")

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "top_peppermint",
    srcs = [
        "top_peppermint.c",
    ],
    hdrs = [
        "top_peppermint.h",
        "top_peppermint_memory.h",
    ],
    defines = ["OPENTITAN_IS_PEPPERMINT"],
    target_compatible_with = opentitan_require_top("peppermint"),
)

ld_library(
    name = "top_peppermint_memory",
    defines = [
        "OPENTITAN_TOP_MEMORY_LD=top_peppermint_memory.ld",
        "OPENTITAN_IS_PEPPERMINT",
    ],
    includes = ["top_peppermint_memory.ld"],
    target_compatible_with = opentitan_require_top("peppermint"),
)
