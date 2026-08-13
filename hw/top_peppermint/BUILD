# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load(
    "//rules/opentitan:defs.bzl",
    "sim_dv",
)

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

sim_dv(
    name = "sim_dv_base",
    design = "peppermint",
    exec_env = "sim_dv",
    extract_sw_logs = "//util/device_sw_utils:extract_sw_logs_db",
    flash_scramble_tool = "//util/design:gen-flash-img",
    libs = [
        "//sw/device/lib/arch:boot_stage_rom_ext",
        "//sw/device/lib/arch:sim_dv",
    ],
    linker_script = "//sw/device/lib/testing/test_framework:ottf_ld_silicon_creator_slot_a",
)

sim_dv(
    name = "sim_dv",
    testonly = True,
    base = ":sim_dv_base",
    exec_env = "sim_dv",
    rom = "//sw/device/lib/testing/test_rom:test_rom",
)
