// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
${gencmd}
<%
import topgen.lib as lib

domain = "Main"

feature_info = {}
cio_info = {}
%>\
<%include file="/toplevel_snippets/info_dicts.tpl" args="top=top, feature_info=feature_info, cio_info=cio_info" />\
`include "prim_assert.sv"

module ${top["name"]}_pd_${domain.lower()} #(
<%include file="/toplevel_snippets/header_parameters.tpl" args="top=top, domain=domain, feedthrough=False" />\
) (
<%include file="/toplevel_snippets/port_intermodule_signals.tpl" args="top=top, domain=domain, last_snippet=False" />\
  output lc_ctrl_pkg::lc_tx_t lc_ctrl_lc_nvm_debug_en_o,
  output lc_ctrl_pkg::lc_tx_t lc_ctrl_lc_cpu_en_o,

  // Power gating control of the main power domain by the power controller of
  // the wider SoC.
  input logic power_main_iso_en_i,
  input logic power_main_sw_en_i,
  input logic power_main_sw_en_phy_i,

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

  // OTP HW_CFG broadcast signals; struct breakout done by hand.
  assign csrng_otp_en_csrng_sw_app_read =
      otp_ctrl_otp_broadcast.hw_cfg1_data.en_csrng_sw_app_read;
  assign sram_ctrl_main_otp_en_sram_ifetch =
      otp_ctrl_otp_broadcast.hw_cfg1_data.en_sram_ifetch;
  assign lc_ctrl_otp_device_id =
      otp_ctrl_otp_broadcast.hw_cfg0_data.device_id;
  assign lc_ctrl_otp_manuf_state =
      otp_ctrl_otp_broadcast.hw_cfg0_data.manuf_state;
  assign keymgr_dpe_device_id =
      otp_ctrl_otp_broadcast.hw_cfg0_data.device_id;

  logic unused_otp_broadcast_bits;
  assign unused_otp_broadcast_bits = ^{
    otp_ctrl_otp_broadcast.valid,
    otp_ctrl_otp_broadcast.hw_cfg0_data.hw_cfg0_digest,
    otp_ctrl_otp_broadcast.hw_cfg1_data.hw_cfg1_digest,
    otp_ctrl_otp_broadcast.hw_cfg1_data.unallocated
    // No hardware consumer for the SoC debug state: the debug policy block
    // is not instantiated in Peppermint. The OTP field has been removed.
  };

  // Ibex-specific assignments.
  assign rv_core_ibex_irq_timer = intr_rv_timer_timer_expired_hart0_timer0;
  assign rv_core_ibex_hart_id   = '0;
  assign rv_core_ibex_boot_addr = tl_main_pkg::ADDR_SPACE_ROM_CTRL__ROM;

  // Unconditionally disable the late debug feature (early debug).
  assign rv_dm_otp_dis_rv_dm_late_debug = prim_mubi_pkg::MuBi8True;

  // Life cycle function control to the Aon power domain.
  assign lc_ctrl_lc_nvm_debug_en_o = lc_ctrl_lc_nvm_debug_en;
  assign lc_ctrl_lc_cpu_en_o       = lc_ctrl_lc_cpu_en;

  // These signals drive physical cells only.
  logic unused_power_gating_ctrl;
  assign unused_power_gating_ctrl = ^{
    power_main_iso_en_i,
    power_main_sw_en_i,
    power_main_sw_en_phy_i
  };

  // Chip IO tie-off.
  otp_macro_pkg::otp_test_vect_t cio_otp_macro_test_d2p_o;
  otp_macro_pkg::otp_test_vect_t cio_otp_macro_test_en_d2p_o;

  logic unused_cio_bits;
  assign unused_cio_bits = ^{
    cio_otp_macro_test_d2p_o,
    cio_otp_macro_test_en_d2p_o
  };

<%include file="/toplevel_snippets/clk_reset_lpg_assigns.tpl" args="top=top, feature_info=feature_info, domain=domain" />\

<%include file="/toplevel_snippets/module_instantiations.tpl" args="top=top, domain=domain" />\

<%include file="/toplevel_snippets/interrupt_assigns.tpl" args="top=top, domain=domain" />\

<%include file="/toplevel_snippets/xbar_instantiations.tpl" args="top=top, domain=domain" />\

<%include file="/toplevel_snippets/cio_assigns.tpl" args="top=top, feature_info=feature_info, cio_info=cio_info, domain=domain" />\

% if lib.find_module(top["module"], "clkmgr").get("domain") == domain:
  // Make sure scanmode_i is never X (including during reset)
  `ASSERT_KNOWN(scanmodeKnown, scanmode_i, clk_main_i, 0)
% endif\

endmodule
