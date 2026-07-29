# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#

load("//rules/opentitan:hw.bzl", "opentitan_top")
load("//hw/top_peppermint/data/autogen:defs.bzl", "PEPPERMINT_IPS")

PEPPERMINT = opentitan_top(
    name = "peppermint",
    hjson = "//hw/top_peppermint/data/autogen:top_peppermint.gen.hjson",
    top_lib = "//hw/top_peppermint/sw/autogen:top_peppermint",
    top_rtl = "//hw/top_peppermint:rtl_files",
    top_ld = "//hw/top_peppermint/sw/autogen:top_peppermint_memory",
    ips = PEPPERMINT_IPS,
    secret_cfgs = {
        "testing": "//hw/top_peppermint/data/autogen:top_peppermint.secrets.testing.gen.hjson",
    },
)
