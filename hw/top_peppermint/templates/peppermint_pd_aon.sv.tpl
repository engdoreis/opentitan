// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
${gencmd}
<%
import topgen.lib as lib

domain = "Aon"

feature_info = {}
cio_info = {}
%>\
<%include file="/toplevel_snippets/info_dicts.tpl" args="top=top, feature_info=feature_info, cio_info=cio_info" />\
`include "prim_assert.sv"

module ${top["name"]}_pd_${domain.lower()} #(
  // Manually defined parameters
  parameter int unsigned SocCpuBootAddrWidth = 32,

<%include file="/toplevel_snippets/header_parameters.tpl" args="top=top, domain=domain, feedthrough=False" />\
) (
<%include file="/toplevel_snippets/port_intermodule_signals.tpl" args="top=top, domain=domain, last_snippet=False" />\
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
<%include file="/toplevel_snippets/port_special_signals.tpl" args="top=top, feature_info=feature_info, cio_info=cio_info, domain=domain" />\
);

  import top_${top["name"]}_pkg::*;
  // Compile-time random constants
  import top_${top["name"]}_rnd_cnst_pkg::*;

<%include file="/toplevel_snippets/localparams.tpl" args="top=top, domain=domain" />\

<%include file="/toplevel_snippets/cio_signals.tpl" args="top=top, feature_info=feature_info, cio_info=cio_info, domain=domain" />\

<%include file="/toplevel_snippets/interrupt_signals.tpl" args="top=top, name_to_block=name_to_block, domain=domain" />\

<%include file="/toplevel_snippets/alert_handler_signals.tpl" args="top=top, feature_info=feature_info, domain=domain" />\

<%include file="/toplevel_snippets/intermodule_signals.tpl" args="top=top, domain=domain" />\

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

  // Boot address of the SoC CPU. Tied off until a source for it exists.
  assign soc_cpu_boot_addr_o = '0;

  // Life cycle function control forwarded registered in AON domain so that the states survive a
  // power down.
<%
  soc_lc_ctrl = [
      ("dft_en", "lc_ctrl_lc_dft_en_i"),
      ("nvm_debug_en", "lc_ctrl_lc_nvm_debug_en_i"),
      ("hw_debug_en", "lc_ctrl_lc_hw_debug_en_i"),
      ("cpu_en", "lc_ctrl_lc_cpu_en_i"),
  ]
%>\
% for name, src in soc_lc_ctrl:
  prim_lc_sync #(
    .NumCopies(1),
    .AsyncOn(1),
    .ResetValueIsOn(0)
  ) u_soc_lc_${name}_sync (
    .clk_i  (clk_aon_i),
    .rst_ni (rstmgr_resets.rst_lc_aon_n[rstmgr_pkg::DomainAonSel]),
    .lc_en_i(${src}),
    .lc_en_o({soc_lc_${name}_o})
  );
% endfor

  // Currently tied-off
  logic unused_scan_en_i;
  assign unused_scan_en_i = scan_en_i;

<%include file="/toplevel_snippets/clk_reset_lpg_assigns.tpl" args="top=top, feature_info=feature_info, domain=domain" />\

<%include file="/toplevel_snippets/module_instantiations.tpl" args="top=top, domain=domain" />\

<%include file="/toplevel_snippets/interrupt_assigns.tpl" args="top=top, domain=domain" />\

<%include file="/toplevel_snippets/xbar_instantiations.tpl" args="top=top, domain=domain" />\

<%include file="/toplevel_snippets/cio_assigns.tpl" args="top=top, feature_info=feature_info, cio_info=cio_info, domain=domain" />\

  // Make sure scanmode_i is never X (including during reset)
  `ASSERT_KNOWN(scanmodeKnown, scanmode_i, clk_main_i, 0)

endmodule
