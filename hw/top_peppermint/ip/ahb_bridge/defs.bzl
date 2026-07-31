# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
load("//rules/opentitan:hw.bzl", "opentitan_ip")

AHB_BRIDGE = opentitan_ip(
    name = "ahb_bridge",
    hjson = "//hw/top_peppermint/ip/ahb_bridge/data:ahb_bridge.hjson",
)
