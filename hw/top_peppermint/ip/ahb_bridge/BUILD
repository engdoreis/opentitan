# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_files",
    srcs = glob(
        ["**"],
        exclude = ["smoke_dv/build-verilator/**"],
    ) + [
        "//hw/top_peppermint/ip/ahb_bridge/data:all_files",
    ],
)

filegroup(
    name = "rtl_files",
    srcs = glob(
        ["**"],
        exclude = [
            "smoke_dv/**",
            "doc/**",
            "README.md",
        ],
    ),
)
