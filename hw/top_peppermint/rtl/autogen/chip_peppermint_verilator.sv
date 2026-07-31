// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Chip level for peppermint, Verilator target. This top has no AST: the
// base clocks are plain inputs on top_peppermint, and the handful of signals
// an AST would drive (aon clock, power-on reset, power/clock handshake
// responses) are synthesized here from clk_i/rst_ni, with the remaining
// AST-style status/bypass signals tied off.
//
// All SoC-facing interfaces are exposed as plain chip-level ports: the
// ahb_bridge's AHB egress (manager) and ingress (subordinate) ports to the
// wider SoC, the debug TL-UL window (still raw TL, to be fronted by a bridge
// later), the mailbox DOE interrupts, the noise source interface, the
// incoming SoC alerts, the debug policy bus, and the SoC-side
// power-handshake signals (main power domain request, wakeup request). DMA's
// SYS port, the low-speed IO triggers and pwrmgr's off-chip reset requests
// have no target in this integration and are tied off internally (see
// top_peppermint.hjson's inter_module.connect), so none of them is exposed
// here.
//
// ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------//
// PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
//
// util/topgen.py -t hw/top_peppermint/data/top_peppermint.hjson
//                -o hw/top_peppermint/


module chip_peppermint_verilator (
  // Clock and Reset
  input clk_i,
  input rst_ni,

  // Reset of the SoC CPU, controlled by a reset manager register.
  output logic rst_soc_cpu_no,

  output logic [31:0] soc_cpu_boot_addr_o,

  // Main power domain reset
  output logic rst_main_no,

  // AHB egress port to the wider SoC: the outgoing AHB manager the
  // ahb_bridge drives from the CPU/DMA "ctn" egress window on xbar_main
  // (see hw/top_peppermint/ip/ahb_bridge).
  output ahb_pkg::ahb_h2d_t     soc_mgr_ahb_req_o,
  input  ahb_pkg::ahb_d2h_t     soc_mgr_ahb_rsp_i,

  // AHB ingress port from the wider SoC: the incoming AHB subordinate the
  // ahb_bridge converts into the mailbox crossbar host (mbx0/mbx1.soc).
  input  ahb_pkg::ahb_h2d_t     soc_mbx_ahb_req_i,
  output ahb_pkg::ahb_d2h_t     soc_mbx_ahb_rsp_o,

  // Mailbox interrupts to the SoC (DOE convention).
  output logic mbx0_doe_intr,
  output logic mbx0_doe_intr_en,
  output logic mbx0_doe_intr_support,
  output logic mbx0_doe_async_msg_support,
  output logic mbx1_doe_intr,
  output logic mbx1_doe_intr_en,
  output logic mbx1_doe_intr_support,
  output logic mbx1_doe_async_msg_support,

  // SoC-facing Debug Module Interface window (see xbar_socdbg.hjson): one
  // shared external host port covering lc_ctrl.dmi and rv_dm.dbg. The
  // DMI-over-JTAG TAP lives in the wider SoC.
  input  tlul_pkg::tl_h2d_t soc_dbg_tl_req,
  output tlul_pkg::tl_d2h_t soc_dbg_tl_rsp,

  output lc_ctrl_pkg::lc_tx_t soc_lc_dft_en,
  output lc_ctrl_pkg::lc_tx_t soc_lc_nvm_debug_en,
  output lc_ctrl_pkg::lc_tx_t soc_lc_hw_debug_en,
  output lc_ctrl_pkg::lc_tx_t soc_lc_cpu_en,

  // Noise source interface: enable out, raw noise bits in.
  output logic       es_rng_enable,
  input  logic       es_rng_valid,
  input  logic [3:0] es_rng_bit,
  output logic       es_rng_fips,

  // Alerts from the wider SoC (driven by prim_alert_sender instances with
  // AsyncOn = 1) and the sender-side low power group indications.
  input  prim_alert_pkg::alert_tx_t [top_peppermint_pkg::NIncomingAlertsSoc-1:0] incoming_alert_soc_tx,
  output prim_alert_pkg::alert_rx_t [top_peppermint_pkg::NIncomingAlertsSoc-1:0] incoming_alert_soc_rx,
  input  prim_mubi_pkg::mubi4_t     [top_peppermint_pkg::NIncomingLpgsSoc-1:0]   incoming_lpg_cg_en_soc,
  input  prim_mubi_pkg::mubi4_t     [top_peppermint_pkg::NIncomingLpgsSoc-1:0]   incoming_lpg_rst_en_soc,

  // Main power domain request to the SoC's power manager.
  output logic power_main_req_o,

  // SoC power-handshake wakeup request: wakes the main power domain from
  // low power (pwrmgr wakeup source 0, enabled via WAKEUP_EN).
  input  logic wakeup_main
);

  import top_peppermint_pkg::*;

  //////////////////////////////////////////
  // No AST: synthesize what it would feed //
  //////////////////////////////////////////

  // AON clock divider. Reset is not used because Verilator uses only sync
  // resets (and does not model 'x'); if the divider below were reset,
  // clk_aon would be silenced and the clk_aon logic inside top_peppermint
  // would not get reset.
  logic clk_aon;
  prim_clock_div #(
    .Divisor(4)
  ) u_aon_div (
    .clk_i,
    .rst_ni(1'b1),
    .step_down_req_i('0),
    .step_down_ack_o(),
    .test_en_i('0),
    .clk_o(clk_aon)
  );

  // Base clock inputs of top_peppermint (named after its ports, which
  // the generic portmap snippet connects by identical net name).
  logic clk_main_i;
  logic clk_aon_i;
  assign clk_main_i = clk_i;
  assign clk_aon_i  = clk_aon;

  logic rst_aon_n;
  assign rst_aon_n = rst_ni;

  // No DFT: scan is disabled.
  logic scan_rst_n;
  logic scan_en;
  prim_mubi_pkg::mubi4_t scanmode;
  assign scan_rst_n = 1'b1;
  assign scan_en    = 1'b0;
  assign scanmode   = prim_mubi_pkg::MuBi4False;

  // Power handshake normally answered by the SoC: model an ideal,
  // always-responsive supply by granting the power request immediately. Both
  // base clocks are driven unconditionally above, so they are always reported
  // valid; pd_aon gates the main clock validity with pwrmgr's own clock
  // request, which is what carries the low power sequencing.
  logic power_main_ok;
  logic clk_aon_ok;
  logic clk_main_ok;
  assign power_main_ok = power_main_req_o;
  assign clk_aon_ok    = 1'b1;
  assign clk_main_ok   = 1'b1;

  // clkmgr signals that would normally be wired to AST. Outputs are simply
  // unconsumed; inputs are tied to their inactive/default value.
  prim_mubi_pkg::mubi4_t clk_main_jitter_en;
  prim_mubi_pkg::mubi4_t hi_speed_sel;
  prim_mubi_pkg::mubi4_t div_step_down_req;
  prim_mubi_pkg::mubi4_t all_clk_byp_req;
  prim_mubi_pkg::mubi4_t all_clk_byp_ack;
  prim_mubi_pkg::mubi4_t io_clk_byp_req;
  prim_mubi_pkg::mubi4_t io_clk_byp_ack;
  assign div_step_down_req = prim_mubi_pkg::MuBi4False;
  assign all_clk_byp_ack   = prim_mubi_pkg::MuBi4False;
  assign io_clk_byp_ack    = prim_mubi_pkg::MuBi4False;

  logic unused_ast_facing_outputs;
  assign unused_ast_facing_outputs = ^{
    clk_main_jitter_en,
    hi_speed_sel,
    all_clk_byp_req,
    io_clk_byp_req
  };

  /////////////////////////////////////////////
  // top_peppermint: power domains        //
  /////////////////////////////////////////////
  top_peppermint top_peppermint (
    .rst_aon_ni(rst_aon_n),
    .rst_soc_cpu_no,
    .soc_cpu_boot_addr_o,
    .rst_main_no,
    .power_main_req_o,
    .power_main_ok_i(power_main_ok),
    .clk_aon_ok_i   (clk_aon_ok   ),
    .clk_main_ok_i  (clk_main_ok  ),
    .soc_lc_dft_en_o      (soc_lc_dft_en      ),
    .soc_lc_nvm_debug_en_o(soc_lc_nvm_debug_en),
    .soc_lc_hw_debug_en_o (soc_lc_hw_debug_en ),
    .soc_lc_cpu_en_o      (soc_lc_cpu_en      ),
    // Externally supplied base clocks
    .clk_aon_i(clk_aon_i),
    .clk_main_i(clk_main_i),

    // Manual DFT signals
    .scan_rst_ni(scan_rst_n),
    .scan_en_i  (scan_en   ),
    .scanmode_i (scanmode  ),

    // Incoming alerts for group soc
    .incoming_alert_soc_tx_i(incoming_alert_soc_tx),
    .incoming_alert_soc_rx_o(incoming_alert_soc_rx),
    .incoming_lpg_cg_en_soc_i(incoming_lpg_cg_en_soc),
    .incoming_lpg_rst_en_soc_i(incoming_lpg_rst_en_soc),

    // Regular ports (auto-generated)
    .wakeup_main_i               (wakeup_main          ),
    .es_rng_enable_o             (es_rng_enable        ),
    .es_rng_valid_i              (es_rng_valid         ),
    .es_rng_bit_i                (es_rng_bit           ),
    .es_rng_fips_o               (es_rng_fips          ),
    .mbx0_doe_intr_o             (mbx0_doe_intr        ),
    .mbx0_doe_intr_en_o          (mbx0_doe_intr_en     ),
    .mbx0_doe_intr_support_o     (mbx0_doe_intr_support),
    .mbx0_doe_async_msg_support_o(mbx0_doe_async_msg_support),
    .mbx1_doe_intr_o             (mbx1_doe_intr        ),
    .mbx1_doe_intr_en_o          (mbx1_doe_intr_en     ),
    .mbx1_doe_intr_support_o     (mbx1_doe_intr_support),
    .mbx1_doe_async_msg_support_o(mbx1_doe_async_msg_support),
    .soc_mgr_ahb_req_o           (soc_mgr_ahb_req_o    ),
    .soc_mgr_ahb_rsp_i           (soc_mgr_ahb_rsp_i    ),
    .soc_mbx_ahb_req_i           (soc_mbx_ahb_req_i    ),
    .soc_mbx_ahb_rsp_o           (soc_mbx_ahb_rsp_o    ),
    .soc_dbg_tl_req_i            (soc_dbg_tl_req       ),
    .soc_dbg_tl_rsp_o            (soc_dbg_tl_rsp       )
  );

endmodule
