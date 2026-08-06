// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Release Peppermint-1.0-M1-RC1.

module lowrisc_top_peppermint_wrapper
  import lowrisc_top_peppermint_pkg::*;
#(
  parameter int unsigned SocCpuBootAddrWidth = 32,
  parameter int EntropySrcRngBusWidth = 4
) (
  // Externally supplied base clocks
  input clk_aon_i,
  input clk_main_i,

  // Manual DFT signals
  input                        scan_rst_ni, // reset used for test mode
  input                        scan_en_i,
  input lowrisc_prim_mubi_pkg::mubi4_t scanmode_i,  // lowrisc_prim_mubi_pkg::MuBi4True for Scan

  // Incoming alerts for group soc
  input  lowrisc_prim_alert_pkg::alert_tx_t [lowrisc_top_peppermint_pkg::NIncomingAlertsSoc-1:0] incoming_alert_soc_tx_i,
  output lowrisc_prim_alert_pkg::alert_rx_t [lowrisc_top_peppermint_pkg::NIncomingAlertsSoc-1:0] incoming_alert_soc_rx_o,
  input  lowrisc_prim_mubi_pkg::mubi4_t     [lowrisc_top_peppermint_pkg::NIncomingLpgsSoc-1:0]   incoming_lpg_cg_en_soc_i,
  input  lowrisc_prim_mubi_pkg::mubi4_t     [lowrisc_top_peppermint_pkg::NIncomingLpgsSoc-1:0]   incoming_lpg_rst_en_soc_i,

  // Inter-module Signal External type
  input  logic       wakeup_main_i,
  output logic       es_rng_enable_o,
  input  logic       es_rng_valid_i,
  input  logic [EntropySrcRngBusWidth-1:0] es_rng_bit_i,
  output logic       es_rng_fips_o,
  output logic       mbx0_doe_intr_o,
  output logic       mbx0_doe_intr_en_o,
  output logic       mbx0_doe_intr_support_o,
  output logic       mbx0_doe_async_msg_support_o,
  output logic       mbx1_doe_intr_o,
  output logic       mbx1_doe_intr_en_o,
  output logic       mbx1_doe_intr_support_o,
  output logic       mbx1_doe_async_msg_support_o,
  output lowrisc_ahb_pkg::ahb_h2d_t       soc_mgr_ahb_req_o,
  input  lowrisc_ahb_pkg::ahb_d2h_t       soc_mgr_ahb_rsp_i,
  input  lowrisc_ahb_pkg::ahb_h2d_t       soc_mbx_ahb_req_i,
  output lowrisc_ahb_pkg::ahb_d2h_t       soc_mbx_ahb_rsp_o,
  input  lowrisc_tlul_pkg::tl_h2d_t       soc_dbg_tl_req_i,
  output lowrisc_tlul_pkg::tl_d2h_t       soc_dbg_tl_rsp_o,

  // Power-on reset from the SoC
  input logic rst_aon_ni,

  // Power handshake with the SoC
  output logic power_main_req_o,
  input  logic power_main_ok_i,
  input  logic clk_aon_ok_i,
  input  logic clk_main_ok_i,

  // Reset of the SoC CPU
  output logic rst_soc_cpu_no,

  // Boot address of the SoC CPU
  output logic [SocCpuBootAddrWidth-1:0] soc_cpu_boot_addr_o,

  // Life cycle function control to the wider SoC
  output lowrisc_lc_ctrl_pkg::lc_tx_t soc_lc_dft_en_o,
  output lowrisc_lc_ctrl_pkg::lc_tx_t soc_lc_nvm_debug_en_o,
  output lowrisc_lc_ctrl_pkg::lc_tx_t soc_lc_hw_debug_en_o,
  output lowrisc_lc_ctrl_pkg::lc_tx_t soc_lc_cpu_en_o,

  // Main power domain reset
  output logic rst_main_no
);

  lowrisc_top_peppermint #(
    .SocCpuBootAddrWidth(SocCpuBootAddrWidth),
    .EntropySrcRngBusWidth(EntropySrcRngBusWidth)
  ) u_top_peppermint (
    .clk_aon_i                    (clk_aon_i),
    .clk_main_i                   (clk_main_i),
    .scan_rst_ni                  (scan_rst_ni),
    .scan_en_i                    (scan_en_i),
    .scanmode_i                   (scanmode_i),
    .incoming_alert_soc_tx_i      (incoming_alert_soc_tx_i),
    .incoming_alert_soc_rx_o      (incoming_alert_soc_rx_o),
    .incoming_lpg_cg_en_soc_i     (incoming_lpg_cg_en_soc_i),
    .incoming_lpg_rst_en_soc_i    (incoming_lpg_rst_en_soc_i),
    .wakeup_main_i                (wakeup_main_i),
    .es_rng_enable_o              (es_rng_enable_o),
    .es_rng_valid_i               (es_rng_valid_i),
    .es_rng_bit_i                 (es_rng_bit_i),
    .es_rng_fips_o                (es_rng_fips_o),
    .mbx0_doe_intr_o              (mbx0_doe_intr_o),
    .mbx0_doe_intr_en_o           (mbx0_doe_intr_en_o),
    .mbx0_doe_intr_support_o      (mbx0_doe_intr_support_o),
    .mbx0_doe_async_msg_support_o (mbx0_doe_async_msg_support_o),
    .mbx1_doe_intr_o              (mbx1_doe_intr_o),
    .mbx1_doe_intr_en_o           (mbx1_doe_intr_en_o),
    .mbx1_doe_intr_support_o      (mbx1_doe_intr_support_o),
    .mbx1_doe_async_msg_support_o (mbx1_doe_async_msg_support_o),
    .soc_mgr_ahb_req_o            (soc_mgr_ahb_req_o),
    .soc_mgr_ahb_rsp_i            (soc_mgr_ahb_rsp_i),
    .soc_mbx_ahb_req_i            (soc_mbx_ahb_req_i),
    .soc_mbx_ahb_rsp_o            (soc_mbx_ahb_rsp_o),
    .soc_dbg_tl_req_i             (soc_dbg_tl_req_i),
    .soc_dbg_tl_rsp_o             (soc_dbg_tl_rsp_o),
    .rst_aon_ni                   (rst_aon_ni),
    .power_main_req_o             (power_main_req_o),
    .power_main_ok_i              (power_main_ok_i),
    .clk_aon_ok_i                 (clk_aon_ok_i),
    .clk_main_ok_i                (clk_main_ok_i),
    .rst_soc_cpu_no               (rst_soc_cpu_no),
    .soc_cpu_boot_addr_o          (soc_cpu_boot_addr_o),
    .soc_lc_dft_en_o              (soc_lc_dft_en_o),
    .soc_lc_nvm_debug_en_o        (soc_lc_nvm_debug_en_o),
    .soc_lc_hw_debug_en_o         (soc_lc_hw_debug_en_o),
    .soc_lc_cpu_en_o              (soc_lc_cpu_en_o),
    .rst_main_no                  (rst_main_no)
  );

endmodule
