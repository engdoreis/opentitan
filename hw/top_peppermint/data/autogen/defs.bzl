# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------#
# PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
# util/topgen.py -t hw/top_peppermint/data/top_peppermint.hjson
#                -o hw/top_peppermint/

load("//hw/ip/aes:defs.bzl", "AES")
load("//hw/top_peppermint/ip/ahb_bridge:defs.bzl", "AHB_BRIDGE")
load("//hw/top_peppermint/ip_autogen/alert_handler:defs.bzl", "ALERT_HANDLER")
load("//hw/top_peppermint/ip_autogen/clkmgr:defs.bzl", "CLKMGR")
load("//hw/ip/csrng:defs.bzl", "CSRNG")
load("//hw/ip/dma:defs.bzl", "DMA")
load("//hw/ip/edn:defs.bzl", "EDN")
load("//hw/ip/entropy_src:defs.bzl", "ENTROPY_SRC")
load("//hw/ip/hmac:defs.bzl", "HMAC")
load("//hw/ip/keymgr_dpe:defs.bzl", "KEYMGR_DPE")
load("//hw/ip/kmac:defs.bzl", "KMAC")
load("//hw/ip/lc_ctrl:defs.bzl", "LC_CTRL")
load("//hw/ip/mbx:defs.bzl", "MBX")
load("//hw/ip/otbn:defs.bzl", "OTBN")
load("//hw/top_peppermint/ip_autogen/otp_ctrl:defs.bzl", "OTP_CTRL")
load("//hw/ip/otp_macro:defs.bzl", "OTP_MACRO")
load("//hw/top_peppermint/ip_autogen/pwrmgr:defs.bzl", "PWRMGR")
load("//hw/ip/rom_ctrl:defs.bzl", "ROM_CTRL")
load("//hw/top_peppermint/ip_autogen/rstmgr:defs.bzl", "RSTMGR")
load("//hw/top_peppermint/ip_autogen/rv_core_ibex:defs.bzl", "RV_CORE_IBEX")
load("//hw/ip/rv_dm:defs.bzl", "RV_DM")
load("//hw/top_peppermint/ip_autogen/rv_plic:defs.bzl", "RV_PLIC")
load("//hw/ip/rv_timer:defs.bzl", "RV_TIMER")
load("//hw/ip/sram_ctrl:defs.bzl", "SRAM_CTRL")

PEPPERMINT_IPS = [
    AES,
    AHB_BRIDGE,
    ALERT_HANDLER,
    CLKMGR,
    CSRNG,
    DMA,
    EDN,
    ENTROPY_SRC,
    HMAC,
    KEYMGR_DPE,
    KMAC,
    LC_CTRL,
    MBX,
    OTBN,
    OTP_CTRL,
    OTP_MACRO,
    PWRMGR,
    ROM_CTRL,
    RSTMGR,
    RV_CORE_IBEX,
    RV_DM,
    RV_PLIC,
    RV_TIMER,
    SRAM_CTRL,
]

PEPPERMINT_ALERTS = [
    "rv_timer_fatal_fault",
    "otp_ctrl_fatal_macro_error",
    "otp_ctrl_fatal_check_error",
    "otp_ctrl_fatal_bus_integ_error",
    "otp_ctrl_fatal_prim_otp_alert",
    "otp_ctrl_recov_prim_otp_alert",
    "lc_ctrl_fatal_prog_error",
    "lc_ctrl_fatal_state_error",
    "lc_ctrl_fatal_bus_integ_error",
    "aes_recov_ctrl_update_err",
    "aes_fatal_fault",
    "hmac_fatal_fault",
    "kmac_recov_operation_err",
    "kmac_fatal_fault_err",
    "otbn_fatal",
    "otbn_recov",
    "keymgr_dpe_recov_operation_err",
    "keymgr_dpe_fatal_fault_err",
    "csrng_recov_alert",
    "csrng_fatal_alert",
    "entropy_src_recov_alert",
    "entropy_src_fatal_alert",
    "edn0_recov_alert",
    "edn0_fatal_alert",
    "edn1_recov_alert",
    "edn1_fatal_alert",
    "sram_ctrl_main_fatal_error",
    "rom_ctrl_fatal",
    "rv_core_ibex_fatal_sw_err",
    "rv_core_ibex_recov_sw_err",
    "rv_core_ibex_fatal_hw_err",
    "rv_core_ibex_recov_hw_err",
    "rv_dm_fatal_fault",
    "dma_fatal_fault",
    "mbx0_fatal_fault",
    "mbx0_recov_fault",
    "mbx1_fatal_fault",
    "mbx1_recov_fault",
    "pwrmgr_fatal_fault",
    "rstmgr_fatal_fault",
    "rstmgr_fatal_cnsty_fault",
    "clkmgr_recov_fault",
    "clkmgr_fatal_fault",
    "sram_ctrl_ret_fatal_error",
    "rv_plic_fatal_fault",
]
