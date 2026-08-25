# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "rtl_files",
    srcs = glob(["**"]) + [
        "//hw/top_peppermint/ip:rtl_files",
    ],
)

filegroup(
    name = "doc_files",
    srcs = glob([
        "**/*.md",
        "**/*.svg",
    ]) + [
        "//hw/top_peppermint/ip_autogen/alert_handler:doc_files",
        "//hw/top_peppermint/ip_autogen/clkmgr:doc_files",
        "//hw/top_peppermint/ip_autogen/otp_ctrl:doc_files",
        "//hw/top_peppermint/ip_autogen/pwrmgr:doc_files",
        "//hw/top_peppermint/ip_autogen/rstmgr:doc_files",
        "//hw/top_peppermint/ip_autogen/rv_core_ibex:doc_files",
        "//hw/top_peppermint/ip_autogen/rv_plic:doc_files",
    ],
)
