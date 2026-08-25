// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------//
// PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
//
// util/topgen.py -t hw/top_peppermint/data/top_peppermint.hjson
//                -o hw/top_peppermint/

`include "prim_assert.sv"

module peppermint_pd_aon #(
  // Manually defined parameters
  parameter int unsigned SocCpuBootAddrWidth = 32,

  // Auto-inferred parameters
  // parameters for rstmgr
  parameter bit SecRstmgrCheck = 0,
  parameter int SecRstmgrMaxSyncDelay = 2,
  // parameters for alert_handler
  parameter int AlertHandlerEscNumSeverities = 4,
  parameter int AlertHandlerEscPingCountWidth = 16,
  // parameters for sram_ctrl_ret
  parameter int SramCtrlRetInstSize = 8192,
  parameter int SramCtrlRetNumRamInst = 1,
  parameter bit SramCtrlRetInstrExec = 0,
  parameter int SramCtrlRetNumPrinceRoundsHalf = 3,
  parameter bit SramCtrlRetEccCorrection = 0
) (
  // Inter-module Signal External type
  output pwrmgr_pkg::pwr_otp_req_t       pwrmgr_pwr_otp_req_o,
  input  pwrmgr_pkg::pwr_otp_rsp_t       pwrmgr_pwr_otp_rsp_i,
  output lc_ctrl_pkg::pwr_lc_req_t       pwrmgr_pwr_lc_req_o,
  input  lc_ctrl_pkg::pwr_lc_rsp_t       pwrmgr_pwr_lc_rsp_i,
  output logic       pwrmgr_strap_o,
  output lc_ctrl_pkg::lc_tx_t       pwrmgr_fetch_en_o,
  input  rom_ctrl_pkg::pwrmgr_data_t       pwrmgr_rom_ctrl_i,
  input  prim_esc_pkg::esc_rx_t [2:0] alert_handler_esc_rx_i,
  output prim_esc_pkg::esc_tx_t [2:0] alert_handler_esc_tx_o,
  output edn_pkg::edn_req_t       edn0_edn_req_o,
  input  edn_pkg::edn_rsp_t       edn0_edn_rsp_i,
  output otp_ctrl_pkg::sram_otp_key_req_t       otp_ctrl_sram_otp_key_req_o,
  input  otp_ctrl_pkg::sram_otp_key_rsp_t       otp_ctrl_sram_otp_key_rsp_i,
  input  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_dft_en_i,
  input  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_hw_debug_en_i,
  input  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_escalate_en_i,
  input  rv_core_ibex_pkg::cpu_crash_dump_t       rv_core_ibex_crash_dump_i,
  input  rv_core_ibex_pkg::cpu_pwrmgr_t       rv_core_ibex_pwrmgr_i,
  input  logic       rv_dm_ndmreset_req_i,
  input  tlul_pkg::tl_h2d_t       main_tl_aon_req_i,
  output tlul_pkg::tl_d2h_t       main_tl_aon_rsp_o,
  input  logic       wakeup_main_i,

  // Power-on reset from the SoC.
  input logic rst_aon_ni,

  // Main power domain request to the SoC, and its power-good response.
  output logic power_main_req_o,
  input  logic power_main_ok_i,

  // Validity of the two base clocks, driven by the SoC.
  input  logic clk_aon_ok_i,
  input  logic clk_main_ok_i,

  // Reset of the SoC CPU, controlled by a reset manager register.
  output logic rst_soc_cpu_no,

  // Boot address of the SoC CPU.
  output logic [SocCpuBootAddrWidth-1:0] soc_cpu_boot_addr_o,

  // Life cycle function control forwarded to the wider SoC.
  output lc_ctrl_pkg::lc_tx_t soc_lc_dft_en_o,
  output lc_ctrl_pkg::lc_tx_t soc_lc_nvm_debug_en_o,
  output lc_ctrl_pkg::lc_tx_t soc_lc_hw_debug_en_o,
  output lc_ctrl_pkg::lc_tx_t soc_lc_cpu_en_o,

  // Life cycle function control from lc_ctrl in the Main power domain.
  input lc_ctrl_pkg::lc_tx_t lc_ctrl_lc_nvm_debug_en_i,
  input lc_ctrl_pkg::lc_tx_t lc_ctrl_lc_cpu_en_i,
  // Interrupts to PLIC rv_plic in power domain Main
  output logic [4:0] intr_vector_o,

  // Alerts from power domain Main
  output prim_alert_pkg::alert_rx_t [38:0] alert_rx_pd_main_o,
  input  prim_alert_pkg::alert_tx_t [38:0] alert_tx_pd_main_i,

  // Incoming alerts for group soc
  input  prim_alert_pkg::alert_tx_t [top_peppermint_pkg::NIncomingAlertsSoc-1:0] incoming_alert_soc_tx_i,
  output prim_alert_pkg::alert_rx_t [top_peppermint_pkg::NIncomingAlertsSoc-1:0] incoming_alert_soc_rx_o,
  input  prim_mubi_pkg::mubi4_t     [top_peppermint_pkg::NIncomingLpgsSoc-1:0]   incoming_lpg_cg_en_soc_i,
  input  prim_mubi_pkg::mubi4_t     [top_peppermint_pkg::NIncomingLpgsSoc-1:0]   incoming_lpg_rst_en_soc_i,
  // Externally supplied clocks
  input clk_aon_i,
  input clk_main_i,
  // Clocks to the other power domains
  output logic clk_aon_o,
  output logic clk_main_o,

  // Resets to the other power domains
  output logic rst_main_aon_no,
  output logic rst_main_no,
  output logic rst_main_shadowed_no,
  output logic rst_main_sys_no,

  // Manual DFT signals
  input                        scan_rst_ni, // reset used for test mode
  input                        scan_en_i,
  input prim_mubi_pkg::mubi4_t scanmode_i   // lc_ctrl_pkg::On for Scan
);

  import top_peppermint_pkg::*;
  // Compile-time random constants
  import top_peppermint_rnd_cnst_pkg::*;

  // Local Parameters
  // local parameters for sram_ctrl_ret
  localparam int SramCtrlRetOutstanding = 2;

  // Signals


  // Interrupt source list
  logic intr_pwrmgr_wakeup;
  logic intr_alert_handler_classa;
  logic intr_alert_handler_classb;
  logic intr_alert_handler_classc;
  logic intr_alert_handler_classd;

  // Alert list
  prim_alert_pkg::alert_tx_t [alert_handler_pkg::NAlerts-1:0] alert_tx;
  prim_alert_pkg::alert_rx_t [alert_handler_pkg::NAlerts-1:0] alert_rx;

  // External connections for alert_handler
  assign alert_tx[6] = alert_tx_pd_main_i[0];
  assign alert_tx[7] = alert_tx_pd_main_i[1];
  assign alert_tx[8] = alert_tx_pd_main_i[2];
  assign alert_tx[9] = alert_tx_pd_main_i[3];
  assign alert_tx[10] = alert_tx_pd_main_i[4];
  assign alert_tx[11] = alert_tx_pd_main_i[5];
  assign alert_tx[12] = alert_tx_pd_main_i[6];
  assign alert_tx[13] = alert_tx_pd_main_i[7];
  assign alert_tx[14] = alert_tx_pd_main_i[8];
  assign alert_tx[15] = alert_tx_pd_main_i[9];
  assign alert_tx[16] = alert_tx_pd_main_i[10];
  assign alert_tx[17] = alert_tx_pd_main_i[11];
  assign alert_tx[18] = alert_tx_pd_main_i[12];
  assign alert_tx[19] = alert_tx_pd_main_i[13];
  assign alert_tx[20] = alert_tx_pd_main_i[14];
  assign alert_tx[21] = alert_tx_pd_main_i[15];
  assign alert_tx[22] = alert_tx_pd_main_i[16];
  assign alert_tx[23] = alert_tx_pd_main_i[17];
  assign alert_tx[24] = alert_tx_pd_main_i[18];
  assign alert_tx[25] = alert_tx_pd_main_i[19];
  assign alert_tx[26] = alert_tx_pd_main_i[20];
  assign alert_tx[27] = alert_tx_pd_main_i[21];
  assign alert_tx[28] = alert_tx_pd_main_i[22];
  assign alert_tx[29] = alert_tx_pd_main_i[23];
  assign alert_tx[30] = alert_tx_pd_main_i[24];
  assign alert_tx[31] = alert_tx_pd_main_i[25];
  assign alert_tx[32] = alert_tx_pd_main_i[26];
  assign alert_tx[33] = alert_tx_pd_main_i[27];
  assign alert_tx[34] = alert_tx_pd_main_i[28];
  assign alert_tx[35] = alert_tx_pd_main_i[29];
  assign alert_tx[36] = alert_tx_pd_main_i[30];
  assign alert_tx[37] = alert_tx_pd_main_i[31];
  assign alert_tx[38] = alert_tx_pd_main_i[32];
  assign alert_tx[39] = alert_tx_pd_main_i[33];
  assign alert_tx[40] = alert_tx_pd_main_i[34];
  assign alert_tx[41] = alert_tx_pd_main_i[35];
  assign alert_tx[42] = alert_tx_pd_main_i[36];
  assign alert_tx[43] = alert_tx_pd_main_i[37];
  assign alert_tx[44] = alert_tx_pd_main_i[38];
  assign alert_rx_pd_main_o[0] = alert_rx[6];
  assign alert_rx_pd_main_o[1] = alert_rx[7];
  assign alert_rx_pd_main_o[2] = alert_rx[8];
  assign alert_rx_pd_main_o[3] = alert_rx[9];
  assign alert_rx_pd_main_o[4] = alert_rx[10];
  assign alert_rx_pd_main_o[5] = alert_rx[11];
  assign alert_rx_pd_main_o[6] = alert_rx[12];
  assign alert_rx_pd_main_o[7] = alert_rx[13];
  assign alert_rx_pd_main_o[8] = alert_rx[14];
  assign alert_rx_pd_main_o[9] = alert_rx[15];
  assign alert_rx_pd_main_o[10] = alert_rx[16];
  assign alert_rx_pd_main_o[11] = alert_rx[17];
  assign alert_rx_pd_main_o[12] = alert_rx[18];
  assign alert_rx_pd_main_o[13] = alert_rx[19];
  assign alert_rx_pd_main_o[14] = alert_rx[20];
  assign alert_rx_pd_main_o[15] = alert_rx[21];
  assign alert_rx_pd_main_o[16] = alert_rx[22];
  assign alert_rx_pd_main_o[17] = alert_rx[23];
  assign alert_rx_pd_main_o[18] = alert_rx[24];
  assign alert_rx_pd_main_o[19] = alert_rx[25];
  assign alert_rx_pd_main_o[20] = alert_rx[26];
  assign alert_rx_pd_main_o[21] = alert_rx[27];
  assign alert_rx_pd_main_o[22] = alert_rx[28];
  assign alert_rx_pd_main_o[23] = alert_rx[29];
  assign alert_rx_pd_main_o[24] = alert_rx[30];
  assign alert_rx_pd_main_o[25] = alert_rx[31];
  assign alert_rx_pd_main_o[26] = alert_rx[32];
  assign alert_rx_pd_main_o[27] = alert_rx[33];
  assign alert_rx_pd_main_o[28] = alert_rx[34];
  assign alert_rx_pd_main_o[29] = alert_rx[35];
  assign alert_rx_pd_main_o[30] = alert_rx[36];
  assign alert_rx_pd_main_o[31] = alert_rx[37];
  assign alert_rx_pd_main_o[32] = alert_rx[38];
  assign alert_rx_pd_main_o[33] = alert_rx[39];
  assign alert_rx_pd_main_o[34] = alert_rx[40];
  assign alert_rx_pd_main_o[35] = alert_rx[41];
  assign alert_rx_pd_main_o[36] = alert_rx[42];
  assign alert_rx_pd_main_o[37] = alert_rx[43];
  assign alert_rx_pd_main_o[38] = alert_rx[44];
  // Alert mapping to the alert handler for alert group soc
  // alert_handler[45]: soc_recov_alert_0
  // alert_handler[46]: soc_recov_alert_1
  // alert_handler[47]: soc_recov_alert_2
  // alert_handler[48]: soc_recov_alert_3
  // alert_handler[49]: soc_recov_alert_4
  // alert_handler[50]: soc_recov_alert_5
  // alert_handler[51]: soc_recov_alert_6
  // alert_handler[52]: soc_recov_alert_7
  // alert_handler[53]: soc_recov_alert_8
  // alert_handler[54]: soc_recov_alert_9
  // alert_handler[55]: soc_recov_alert_10
  // alert_handler[56]: soc_recov_alert_11
  // alert_handler[57]: soc_recov_alert_12
  // alert_handler[58]: soc_recov_alert_13
  // alert_handler[59]: soc_recov_alert_14
  // alert_handler[60]: soc_recov_alert_15
  // alert_handler[61]: soc_recov_alert_16
  // alert_handler[62]: soc_recov_alert_17
  // alert_handler[63]: soc_recov_alert_18
  // alert_handler[64]: soc_recov_alert_19
  // alert_handler[65]: soc_recov_alert_20
  // alert_handler[66]: soc_recov_alert_21
  // alert_handler[67]: soc_recov_alert_22
  // alert_handler[68]: soc_recov_alert_23
  // alert_handler[69]: soc_recov_alert_24
  // alert_handler[70]: soc_recov_alert_25
  // alert_handler[71]: soc_recov_alert_26
  // alert_handler[72]: soc_recov_alert_27
  // alert_handler[73]: soc_recov_alert_28
  // alert_handler[74]: soc_recov_alert_29
  // alert_handler[75]: soc_recov_alert_30
  // alert_handler[76]: soc_recov_alert_31
  // alert_handler[77]: soc_fatal_alert_0
  // alert_handler[78]: soc_fatal_alert_1
  // alert_handler[79]: soc_fatal_alert_2
  // alert_handler[80]: soc_fatal_alert_3
  // alert_handler[81]: soc_fatal_alert_4
  // alert_handler[82]: soc_fatal_alert_5
  // alert_handler[83]: soc_fatal_alert_6
  // alert_handler[84]: soc_fatal_alert_7
  assign alert_tx[84:45] = incoming_alert_soc_tx_i;
  assign incoming_alert_soc_rx_o = alert_rx[84:45];

  // Define inter-module signals
  pwrmgr_pkg::pwr_rst_req_t       pwrmgr_pwr_rst_req;
  pwrmgr_pkg::pwr_rst_rsp_t       pwrmgr_pwr_rst_rsp;
  pwrmgr_pkg::pwr_clk_req_t       pwrmgr_pwr_clk_req;
  pwrmgr_pkg::pwr_clk_rsp_t       pwrmgr_pwr_clk_rsp;
  prim_esc_pkg::esc_rx_t [3:0] alert_handler_esc_rx;
  prim_esc_pkg::esc_tx_t [3:0] alert_handler_esc_tx;
  alert_handler_pkg::alert_crashdump_t       alert_handler_crashdump;
  prim_mubi_pkg::mubi4_t       rstmgr_sw_rst_req;
  tlul_pkg::tl_h2d_t       pwrmgr_tl_req;
  tlul_pkg::tl_d2h_t       pwrmgr_tl_rsp;
  tlul_pkg::tl_h2d_t       rstmgr_tl_req;
  tlul_pkg::tl_d2h_t       rstmgr_tl_rsp;
  tlul_pkg::tl_h2d_t       clkmgr_tl_req;
  tlul_pkg::tl_d2h_t       clkmgr_tl_rsp;
  tlul_pkg::tl_h2d_t       alert_handler_tl_req;
  tlul_pkg::tl_d2h_t       alert_handler_tl_rsp;
  tlul_pkg::tl_h2d_t       sram_ctrl_ret_regs_tl_req;
  tlul_pkg::tl_d2h_t       sram_ctrl_ret_regs_tl_rsp;
  tlul_pkg::tl_h2d_t       sram_ctrl_ret_ram_tl_req;
  tlul_pkg::tl_d2h_t       sram_ctrl_ret_ram_tl_rsp;
  clkmgr_pkg::clkmgr_out_t       clkmgr_clocks;
  clkmgr_pkg::clkmgr_cg_en_t       clkmgr_cg_en;
  rstmgr_pkg::rstmgr_out_t       rstmgr_resets;
  rstmgr_pkg::rstmgr_rst_en_t       rstmgr_rst_en;
  logic [1:0] rstmgr_por_n;
  logic [31:0] rstmgr_soc_cpu_boot_addr;
  pwrmgr_pkg::pwr_ast_req_t       pwrmgr_pwr_ast_req;
  pwrmgr_pkg::pwr_ast_rsp_t       pwrmgr_pwr_ast_rsp;

  // Create mixed connections to ports
  assign alert_handler_esc_rx[0] = alert_handler_esc_rx_i[0];
  assign alert_handler_esc_rx[1] = alert_handler_esc_rx_i[1];
  assign alert_handler_esc_rx[2] = alert_handler_esc_rx_i[2];
  assign alert_handler_esc_tx_o[0] = alert_handler_esc_tx[0];
  assign alert_handler_esc_tx_o[1] = alert_handler_esc_tx[1];
  assign alert_handler_esc_tx_o[2] = alert_handler_esc_tx[2];


  // Power-on reset
  assign rstmgr_por_n = {rstmgr_pkg::PowerDomains{rst_aon_ni}};

  // Power handshake with the SoC, broken out of pwrmgr's AST struct by hand.
  // Peppermint has no isolation clamps and does not ask the SoC to start or
  // stop the base clocks, so only the main power domain request leaves.
  //
  // The main clock counts as valid only while pwrmgr itself still requests it:
  // on the way into low power the slow FSM leaves SlowPwrStateClocksOff only
  // once the main clock reports invalid, and it drops core_clk_en two states
  // before main_pd_n. Gating here keeps that sequencing intact while still
  // letting the SoC force the clock invalid, e.g. across a PLL relock.
  assign power_main_req_o = !pwrmgr_pwr_ast_req.main_pd_n;
  assign pwrmgr_pwr_ast_rsp = '{
    slow_clk_val: clk_aon_ok_i,
    core_clk_val: clk_main_ok_i & pwrmgr_pwr_ast_req.core_clk_en,
    main_pok:     power_main_ok_i
  };

  logic unused_pwr_ast_req_bits;
  assign unused_pwr_ast_req_bits = ^{
    pwrmgr_pwr_ast_req.pwr_clamp_env,
    pwrmgr_pwr_ast_req.pwr_clamp,
    pwrmgr_pwr_ast_req.slow_clk_en
  };

  // The SW-controlled SoC CPU reset.
  assign rst_soc_cpu_no = rstmgr_resets.rst_soc_cpu_n[rstmgr_pkg::DomainAonSel];

  // Boot address of the SoC CPU, driven by a register in rstmgr
  assign soc_cpu_boot_addr_o = rstmgr_soc_cpu_boot_addr[SocCpuBootAddrWidth-1:0];

  // Life cycle function control forwarded registered in AON domain so that the states survive a
  // power down.
  prim_lc_sync #(
    .NumCopies(1),
    .AsyncOn(1),
    .ResetValueIsOn(0)
  ) u_soc_lc_dft_en_sync (
    .clk_i  (clk_aon_i),
    .rst_ni (rstmgr_resets.rst_lc_aon_n[rstmgr_pkg::DomainAonSel]),
    .lc_en_i(lc_ctrl_lc_dft_en_i),
    .lc_en_o({soc_lc_dft_en_o})
  );
  prim_lc_sync #(
    .NumCopies(1),
    .AsyncOn(1),
    .ResetValueIsOn(0)
  ) u_soc_lc_nvm_debug_en_sync (
    .clk_i  (clk_aon_i),
    .rst_ni (rstmgr_resets.rst_lc_aon_n[rstmgr_pkg::DomainAonSel]),
    .lc_en_i(lc_ctrl_lc_nvm_debug_en_i),
    .lc_en_o({soc_lc_nvm_debug_en_o})
  );
  prim_lc_sync #(
    .NumCopies(1),
    .AsyncOn(1),
    .ResetValueIsOn(0)
  ) u_soc_lc_hw_debug_en_sync (
    .clk_i  (clk_aon_i),
    .rst_ni (rstmgr_resets.rst_lc_aon_n[rstmgr_pkg::DomainAonSel]),
    .lc_en_i(lc_ctrl_lc_hw_debug_en_i),
    .lc_en_o({soc_lc_hw_debug_en_o})
  );
  prim_lc_sync #(
    .NumCopies(1),
    .AsyncOn(1),
    .ResetValueIsOn(0)
  ) u_soc_lc_cpu_en_sync (
    .clk_i  (clk_aon_i),
    .rst_ni (rstmgr_resets.rst_lc_aon_n[rstmgr_pkg::DomainAonSel]),
    .lc_en_i(lc_ctrl_lc_cpu_en_i),
    .lc_en_o({soc_lc_cpu_en_o})
  );

  // Currently tied-off
  logic unused_scan_en_i;
  assign unused_scan_en_i = scan_en_i;

  // Clocks and resets to the other power domains
  assign clk_aon_o = clkmgr_clocks.clk_aon_secure;
  assign clk_main_o = clkmgr_clocks.clk_main_secure;
  assign rst_main_aon_no = rstmgr_resets.rst_lc_aon_n[rstmgr_pkg::DomainMainSel];
  assign rst_main_no = rstmgr_resets.rst_lc_main_n[rstmgr_pkg::DomainMainSel];
  assign rst_main_shadowed_no = rstmgr_resets.rst_lc_main_shadowed_n[rstmgr_pkg::DomainMainSel];
  assign rst_main_sys_no = rstmgr_resets.rst_sys_n[rstmgr_pkg::DomainMainSel];

  // Alert handler low power groups (LPGs)
  prim_mubi_pkg::mubi4_t [alert_handler_pkg::NLpg-1:0] lpg_cg_en;
  prim_mubi_pkg::mubi4_t [alert_handler_pkg::NLpg-1:0] lpg_rst_en;

  // ext_por_aon_Aon
  assign lpg_cg_en[0] = prim_mubi_pkg::MuBi4False;
  assign lpg_rst_en[0] = rstmgr_rst_en.por_aon[rstmgr_pkg::DomainAonSel];
  // ext_lc_aon_Aon
  assign lpg_cg_en[1] = prim_mubi_pkg::MuBi4False;
  assign lpg_rst_en[1] = rstmgr_rst_en.lc_aon[rstmgr_pkg::DomainAonSel];
  // secure_lc_main_Main
  assign lpg_cg_en[2] = clkmgr_cg_en.main_secure;
  assign lpg_rst_en[2] = rstmgr_rst_en.lc_main[rstmgr_pkg::DomainMainSel];
  // secure_sys_Main
  assign lpg_cg_en[3] = clkmgr_cg_en.main_secure;
  assign lpg_rst_en[3] = rstmgr_rst_en.sys[rstmgr_pkg::DomainMainSel];
  assign lpg_cg_en[4] = incoming_lpg_cg_en_soc_i[0];
  assign lpg_rst_en[4] = incoming_lpg_rst_en_soc_i[0];
  assign lpg_cg_en[5] = incoming_lpg_cg_en_soc_i[1];
  assign lpg_rst_en[5] = incoming_lpg_rst_en_soc_i[1];
  assign lpg_cg_en[6] = incoming_lpg_cg_en_soc_i[2];
  assign lpg_rst_en[6] = incoming_lpg_rst_en_soc_i[2];
  assign lpg_cg_en[7] = incoming_lpg_cg_en_soc_i[3];
  assign lpg_rst_en[7] = incoming_lpg_rst_en_soc_i[3];
  assign lpg_cg_en[8] = incoming_lpg_cg_en_soc_i[4];
  assign lpg_rst_en[8] = incoming_lpg_rst_en_soc_i[4];
  assign lpg_cg_en[9] = incoming_lpg_cg_en_soc_i[5];
  assign lpg_rst_en[9] = incoming_lpg_rst_en_soc_i[5];
  assign lpg_cg_en[10] = incoming_lpg_cg_en_soc_i[6];
  assign lpg_rst_en[10] = incoming_lpg_rst_en_soc_i[6];
  assign lpg_cg_en[11] = incoming_lpg_cg_en_soc_i[7];
  assign lpg_rst_en[11] = incoming_lpg_rst_en_soc_i[7];

// Tie off unused clock- and reset enables
//VCS coverage off
// pragma coverage off
  prim_mubi_pkg::mubi4_t [0:0] unused_cg_en;
  prim_mubi_pkg::mubi4_t [11:0] unused_rst_en;

  assign unused_cg_en[0] = clkmgr_cg_en.aon_secure;

  assign unused_rst_en[0] = rstmgr_rst_en.lc_aon[rstmgr_pkg::DomainMainSel];
  assign unused_rst_en[1] = rstmgr_rst_en.lc_aon_shadowed[rstmgr_pkg::DomainAonSel];
  assign unused_rst_en[2] = rstmgr_rst_en.lc_aon_shadowed[rstmgr_pkg::DomainMainSel];
  assign unused_rst_en[3] = rstmgr_rst_en.lc_main[rstmgr_pkg::DomainAonSel];
  assign unused_rst_en[4] = rstmgr_rst_en.lc_main_shadowed[rstmgr_pkg::DomainAonSel];
  assign unused_rst_en[5] = rstmgr_rst_en.lc_main_shadowed[rstmgr_pkg::DomainMainSel];
  assign unused_rst_en[6] = rstmgr_rst_en.por_aon[rstmgr_pkg::DomainMainSel];
  assign unused_rst_en[7] = rstmgr_rst_en.por_main[rstmgr_pkg::DomainAonSel];
  assign unused_rst_en[8] = rstmgr_rst_en.por_main[rstmgr_pkg::DomainMainSel];
  assign unused_rst_en[9] = rstmgr_rst_en.soc_cpu[rstmgr_pkg::DomainAonSel];
  assign unused_rst_en[10] = rstmgr_rst_en.soc_cpu[rstmgr_pkg::DomainMainSel];
  assign unused_rst_en[11] = rstmgr_rst_en.sys[rstmgr_pkg::DomainAonSel];
// pragma coverage on
//VCS coverage on


// Tie off unused clocks and resets
//VCS coverage off
// pragma coverage off
  logic [5:0] unused_resets;
  assign unused_resets[0] = rstmgr_resets.rst_lc_aon_shadowed_n[rstmgr_pkg::DomainMainSel];
  assign unused_resets[1] = rstmgr_resets.rst_lc_main_shadowed_n[rstmgr_pkg::DomainAonSel];
  assign unused_resets[2] = rstmgr_resets.rst_por_main_n[rstmgr_pkg::DomainMainSel];
  assign unused_resets[3] = rstmgr_resets.rst_soc_cpu_n[rstmgr_pkg::DomainAonSel];
  assign unused_resets[4] = rstmgr_resets.rst_soc_cpu_n[rstmgr_pkg::DomainMainSel];
  assign unused_resets[5] = rstmgr_resets.rst_sys_n[rstmgr_pkg::DomainAonSel];
// pragma coverage on
//VCS coverage on

  // Instantiation of IPs
  pwrmgr #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[0]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles),
    .EscNumSeverities(AlertHandlerEscNumSeverities),
    .EscPingCountWidth(AlertHandlerEscPingCountWidth)
  ) u_pwrmgr (
    // Clock and reset connections
    .clk_i(clk_aon_i),
    .clk_slow_i(clk_aon_i),
    .clk_lc_i(clk_main_i),
    .clk_esc_i(clk_aon_i),
    .rst_ni(rstmgr_resets.rst_por_aon_n[rstmgr_pkg::DomainAonSel]),
    .rst_main_ni(rstmgr_resets.rst_por_aon_n[rstmgr_pkg::DomainMainSel]),
    .rst_lc_ni(rstmgr_resets.rst_lc_main_n[rstmgr_pkg::DomainAonSel]),
    .rst_esc_ni(rstmgr_resets.rst_lc_aon_n[rstmgr_pkg::DomainAonSel]),
    .rst_slow_ni(rstmgr_resets.rst_por_aon_n[rstmgr_pkg::DomainAonSel]),

    // Interrupts
    .intr_wakeup_o(intr_pwrmgr_wakeup),

    // alert_handler[0]: fatal_fault
    .alert_tx_o(alert_tx[0]),
    .alert_rx_i(alert_rx[0]),

    // Inter-module signals
    .pwr_ast_o(pwrmgr_pwr_ast_req),
    .pwr_ast_i(pwrmgr_pwr_ast_rsp),
    .pwr_rst_o(pwrmgr_pwr_rst_req),
    .pwr_rst_i(pwrmgr_pwr_rst_rsp),
    .pwr_clk_o(pwrmgr_pwr_clk_req),
    .pwr_clk_i(pwrmgr_pwr_clk_rsp),
    .pwr_otp_o(pwrmgr_pwr_otp_req_o),
    .pwr_otp_i(pwrmgr_pwr_otp_rsp_i),
    .pwr_lc_o(pwrmgr_pwr_lc_req_o),
    .pwr_lc_i(pwrmgr_pwr_lc_rsp_i),
    .pwr_nvm_i(pwrmgr_pkg::PWR_NVM_DEFAULT),
    .esc_rst_tx_i(alert_handler_esc_tx[3]),
    .esc_rst_rx_o(alert_handler_esc_rx[3]),
    .pwr_cpu_i(rv_core_ibex_pwrmgr_i),
    .wakeups_i(wakeup_main_i),
    .rstreqs_i('0),
    .ndmreset_req_i(rv_dm_ndmreset_req_i),
    .strap_o(pwrmgr_strap_o),
    .low_power_o(),
    .rom_ctrl_i(pwrmgr_rom_ctrl_i),
    .fetch_en_o(pwrmgr_fetch_en_o),
    .lc_dft_en_i(lc_ctrl_lc_dft_en_i),
    .lc_hw_debug_en_i(lc_ctrl_lc_hw_debug_en_i),
    .sw_rst_req_i(rstmgr_sw_rst_req),
    .tl_i(pwrmgr_tl_req),
    .tl_o(pwrmgr_tl_rsp)
  );

  rstmgr #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[2:1]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles),
    .SecCheck(SecRstmgrCheck),
    .SecMaxSyncDelay(SecRstmgrMaxSyncDelay)
  ) u_rstmgr (
    // Clock and reset connections
    .clk_i(clk_aon_i),
    .clk_por_i(clk_aon_i),
    .clk_aon_i(clk_aon_i),
    .clk_main_i(clk_main_i),
    .rst_ni(rstmgr_resets.rst_lc_aon_n[rstmgr_pkg::DomainAonSel]),
    .rst_por_ni(rstmgr_resets.rst_por_aon_n[rstmgr_pkg::DomainAonSel]),

    // DFT/scan connections
    .scanmode_i,
    .scan_rst_ni,

    // alert_handler[1]: fatal_fault
    // alert_handler[2]: fatal_cnsty_fault
    .alert_tx_o(alert_tx[2:1]),
    .alert_rx_i(alert_rx[2:1]),

    // Inter-module signals
    .por_n_i(rstmgr_por_n),
    .pwr_i(pwrmgr_pwr_rst_req),
    .pwr_o(pwrmgr_pwr_rst_rsp),
    .resets_o(rstmgr_resets),
    .rst_en_o(rstmgr_rst_en),
    .alert_dump_i(alert_handler_crashdump),
    .cpu_dump_i(rv_core_ibex_crash_dump_i),
    .sw_rst_req_o(rstmgr_sw_rst_req),
    .soc_cpu_boot_addr_o(rstmgr_soc_cpu_boot_addr),
    .tl_i(rstmgr_tl_req),
    .tl_o(rstmgr_tl_rsp)
  );

  clkmgr #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[4:3]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles)
  ) u_clkmgr (
    // Clock and reset connections
    .clk_i(clk_aon_i),
    .clk_main_i(clk_main_i),
    .clk_aon_i(clk_aon_i),
    .rst_shadowed_ni(rstmgr_resets.rst_lc_aon_shadowed_n[rstmgr_pkg::DomainAonSel]),
    .rst_ni(rstmgr_resets.rst_lc_aon_n[rstmgr_pkg::DomainAonSel]),
    .rst_aon_ni(rstmgr_resets.rst_lc_aon_n[rstmgr_pkg::DomainAonSel]),
    .rst_main_ni(rstmgr_resets.rst_lc_main_n[rstmgr_pkg::DomainAonSel]),
    .rst_root_ni(rstmgr_resets.rst_por_aon_n[rstmgr_pkg::DomainAonSel]),
    .rst_root_main_ni(rstmgr_resets.rst_por_main_n[rstmgr_pkg::DomainAonSel]),

    // DFT/scan connections
    .scanmode_i,

    // alert_handler[3]: recov_fault
    // alert_handler[4]: fatal_fault
    .alert_tx_o(alert_tx[4:3]),
    .alert_rx_i(alert_rx[4:3]),

    // Inter-module signals
    .clocks_o(clkmgr_clocks),
    .cg_en_o(clkmgr_cg_en),
    .jitter_en_o(),
    .pwr_i(pwrmgr_pwr_clk_req),
    .pwr_o(pwrmgr_pwr_clk_rsp),
    .idle_i(prim_mubi_pkg::MuBi4False),
    .tl_i(clkmgr_tl_req),
    .tl_o(clkmgr_tl_rsp)
  );

  alert_handler #(
    .AlertSkewCycles(top_pkg::AlertSkewCycles),
    .RndCnstLfsrSeed(RndCnstAlertHandlerLfsrSeed),
    .RndCnstLfsrPerm(RndCnstAlertHandlerLfsrPerm),
    .EscNumSeverities(AlertHandlerEscNumSeverities),
    .EscPingCountWidth(AlertHandlerEscPingCountWidth)
  ) u_alert_handler (
    // Clock and reset connections
    .clk_i(clk_aon_i),
    .clk_edn_i(clkmgr_clocks.clk_main_secure),
    .rst_shadowed_ni(rstmgr_resets.rst_lc_aon_shadowed_n[rstmgr_pkg::DomainAonSel]),
    .rst_ni(rstmgr_resets.rst_lc_aon_n[rstmgr_pkg::DomainAonSel]),
    .rst_edn_ni(rstmgr_resets.rst_lc_main_n[rstmgr_pkg::DomainMainSel]),

    // Interrupts
    .intr_classa_o(intr_alert_handler_classa),
    .intr_classb_o(intr_alert_handler_classb),
    .intr_classc_o(intr_alert_handler_classc),
    .intr_classd_o(intr_alert_handler_classd),


    // Inter-module signals
    .crashdump_o(alert_handler_crashdump),
    .edn_o(edn0_edn_req_o),
    .edn_i(edn0_edn_rsp_i),
    .esc_rx_i(alert_handler_esc_rx),
    .esc_tx_o(alert_handler_esc_tx),
    .tl_i(alert_handler_tl_req),
    .tl_o(alert_handler_tl_rsp),

    // Alert signals
    .alert_rx_o(alert_rx),
    .alert_tx_i(alert_tx),

    // Reset and clock gating indications for each low power group
    .lpg_cg_en_i (lpg_cg_en ),
    .lpg_rst_en_i(lpg_rst_en)
  );

  sram_ctrl #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[5]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles),
    .RndCnstSramKey(RndCnstSramCtrlRetSramKey),
    .RndCnstSramNonce(RndCnstSramCtrlRetSramNonce),
    .RndCnstLfsrSeed(RndCnstSramCtrlRetLfsrSeed),
    .RndCnstLfsrPerm(RndCnstSramCtrlRetLfsrPerm),
    .MemSizeRam(8192),
    .InstSize(SramCtrlRetInstSize),
    .NumRamInst(SramCtrlRetNumRamInst),
    .InstrExec(SramCtrlRetInstrExec),
    .NumPrinceRoundsHalf(SramCtrlRetNumPrinceRoundsHalf),
    .Outstanding(SramCtrlRetOutstanding),
    .EccCorrection(SramCtrlRetEccCorrection)
  ) u_sram_ctrl_ret (
    // Clock and reset connections
    .clk_i(clk_aon_i),
    .clk_otp_i(clk_main_i),
    .rst_ni(rstmgr_resets.rst_lc_aon_n[rstmgr_pkg::DomainAonSel]),
    .rst_otp_ni(rstmgr_resets.rst_lc_main_n[rstmgr_pkg::DomainMainSel]),

    // alert_handler[5]: fatal_error
    .alert_tx_o(alert_tx[5]),
    .alert_rx_i(alert_rx[5]),

    // RACL policies
    .racl_policy_sel_ranges_ram_i('{top_racl_pkg::RACL_RANGE_T_DEFAULT}),

    // Inter-module signals
    .sram_otp_key_o(otp_ctrl_sram_otp_key_req_o),
    .sram_otp_key_i(otp_ctrl_sram_otp_key_rsp_i),
    .ram_cfg_i('{default: prim_ram_1p_pkg::RAM_1P_CFG_REQ_DEFAULT}),
    .ram_cfg_o(),
    .lc_escalate_en_i(lc_ctrl_lc_escalate_en_i),
    .lc_hw_debug_en_i(lc_ctrl_lc_hw_debug_en_i),
    .otp_en_sram_ifetch_i(prim_mubi_pkg::MuBi8False),
    .racl_policies_i(top_racl_pkg::RACL_POLICY_VEC_DEFAULT),
    .racl_error_o(),
    .sram_rerror_o(),
    .regs_tl_i(sram_ctrl_ret_regs_tl_req),
    .regs_tl_o(sram_ctrl_ret_regs_tl_rsp),
    .ram_tl_i(sram_ctrl_ret_ram_tl_req),
    .ram_tl_o(sram_ctrl_ret_ram_tl_rsp)
  );


  // Interrupt vector to PLIC rv_plic in power domain Main
  assign intr_vector_o = {
    intr_alert_handler_classd,
    intr_alert_handler_classc,
    intr_alert_handler_classb,
    intr_alert_handler_classa,
    intr_pwrmgr_wakeup
  };

  // Instantiation of TL-UL crossbars
  xbar_aon u_xbar_aon (
    .clk_aon_i(clk_aon_i),
    .rst_aon_ni(rstmgr_resets.rst_lc_aon_n[rstmgr_pkg::DomainAonSel]),

    // port: tl_main
    .tl_main_i(main_tl_aon_req_i),
    .tl_main_o(main_tl_aon_rsp_o),

    // port: tl_pwrmgr
    .tl_pwrmgr_o(pwrmgr_tl_req),
    .tl_pwrmgr_i(pwrmgr_tl_rsp),

    // port: tl_rstmgr
    .tl_rstmgr_o(rstmgr_tl_req),
    .tl_rstmgr_i(rstmgr_tl_rsp),

    // port: tl_clkmgr
    .tl_clkmgr_o(clkmgr_tl_req),
    .tl_clkmgr_i(clkmgr_tl_rsp),

    // port: tl_alert_handler
    .tl_alert_handler_o(alert_handler_tl_req),
    .tl_alert_handler_i(alert_handler_tl_rsp),

    // port: tl_sram_ctrl_ret__regs
    .tl_sram_ctrl_ret__regs_o(sram_ctrl_ret_regs_tl_req),
    .tl_sram_ctrl_ret__regs_i(sram_ctrl_ret_regs_tl_rsp),

    // port: tl_sram_ctrl_ret__ram
    .tl_sram_ctrl_ret__ram_o(sram_ctrl_ret_ram_tl_req),
    .tl_sram_ctrl_ret__ram_i(sram_ctrl_ret_ram_tl_rsp),

    .scanmode_i
  );



  // Make sure scanmode_i is never X (including during reset)
  `ASSERT_KNOWN(scanmodeKnown, scanmode_i, clk_main_i, 0)

endmodule
