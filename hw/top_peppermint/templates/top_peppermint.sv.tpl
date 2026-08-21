// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
${gencmd}
<%
import re
import topgen.lib as lib
from reggen.params import Parameter

feature_info = {}
cio_info = {}

%>\
<%include file="/toplevel_snippets/info_dicts.tpl" args="top=top, feature_info=feature_info, cio_info=cio_info" />\

// This wrapper hosts all power domain wrappers and the connections between them for ${top["name"]}.
module top_${top["name"]} #(
  // Manually defined parameters
  parameter int unsigned SocCpuBootAddrWidth = 32,

<%include file="/toplevel_snippets/header_parameters.tpl" args="top=top, domain='', feedthrough=False" />\
) (
<%include file="/chiplevel_snippets/port_special_signals.tpl" args="top=top, feature_info=feature_info, cio_info=cio_info" />\
<%include file="/toplevel_snippets/port_intermodule_signals.tpl" args="top=top, domain='', last_snippet=False" />\
  // Power-on reset from the SoC
  input logic rst_aon_ni,

  // Power handshake with the SoC
  output logic power_main_req_o,
  input  logic power_main_ok_i,
  input  logic clk_aon_ok_i,
  input  logic clk_main_ok_i,

  // Power gating control of the main power domain by the power controller of
  // the wider SoC.
  input logic power_main_iso_en_i,
  input logic power_main_sw_en_i,
  input logic power_main_sw_en_phy_i,

  // Reset of the SoC CPU
  output logic rst_soc_cpu_no,

  // Boot address of the SoC CPU
  output logic [SocCpuBootAddrWidth-1:0] soc_cpu_boot_addr_o,

  // Life cycle function control to the wider SoC
  output lc_ctrl_pkg::lc_tx_t soc_lc_dft_en_o,
  output lc_ctrl_pkg::lc_tx_t soc_lc_nvm_debug_en_o,
  output lc_ctrl_pkg::lc_tx_t soc_lc_hw_debug_en_o,
  output lc_ctrl_pkg::lc_tx_t soc_lc_cpu_en_o,

  // Main power domain reset
  output logic rst_main_no
);

  import top_${top["name"]}_pkg::*;
  import prim_pad_wrapper_pkg::*;

  // Inter-Power Domain signals
% for sig in top["inter_pd"]["definitions"]:
  % if isinstance(sig["width"], Parameter):
  ${lib.im_defname(sig)} [${sig["width"].name_top}-1:0] ${sig["signame"]};
  % else:
  ${lib.im_defname(sig)} ${lib.bitarray(sig["width"],1)} ${sig["signame"]};
  % endif
% endfor

  lc_ctrl_pkg::lc_tx_t lc_ctrl_lc_nvm_debug_en;
  lc_ctrl_pkg::lc_tx_t lc_ctrl_lc_cpu_en;

  assign rst_main_no = rst_main_n;

  ///////////////////////////
  // Top-level Main Domain //
  ///////////////////////////
  ${top["name"]}_pd_main #(
<%include file="/toplevel_snippets/header_parameters.tpl" args="top=top, domain='Main', feedthrough=True" />\
  ) ${top["name"]}_pd_main (
    .lc_ctrl_lc_nvm_debug_en_o(lc_ctrl_lc_nvm_debug_en),
    .lc_ctrl_lc_cpu_en_o      (lc_ctrl_lc_cpu_en      ),
    .power_main_iso_en_i,
    .power_main_sw_en_i,
    .power_main_sw_en_phy_i,
<%include file="/toplevel_snippets/special_signals_portmap.tpl" args="top=top, feature_info=feature_info, cio_info=cio_info, domain='Main'" />\

<%include file="/chiplevel_snippets/intermodule_portmap.tpl" args="top=top, target='', domain='Main', inter_pd=True, feedthrough=False, last_snippet=False" />\

<%include file="/chiplevel_snippets/intermodule_portmap.tpl" args="top=top, target='', domain='Main', inter_pd=False, feedthrough=True, last_snippet=True" />\
  );


  ////////////////////////////////
  // Top-level Always-On domain //
  ////////////////////////////////
  ${top["name"]}_pd_aon #(
    .SocCpuBootAddrWidth(SocCpuBootAddrWidth),

<%include file="/toplevel_snippets/header_parameters.tpl" args="top=top, domain='Aon', feedthrough=True" />\
  ) ${top["name"]}_pd_aon (
    .rst_aon_ni,
    .power_main_req_o,
    .power_main_ok_i,
    .clk_aon_ok_i,
    .clk_main_ok_i,
    .rst_soc_cpu_no,
    .soc_cpu_boot_addr_o,
    .soc_lc_dft_en_o,
    .soc_lc_nvm_debug_en_o,
    .soc_lc_hw_debug_en_o,
    .soc_lc_cpu_en_o,
    .lc_ctrl_lc_nvm_debug_en_i(lc_ctrl_lc_nvm_debug_en),
    .lc_ctrl_lc_cpu_en_i      (lc_ctrl_lc_cpu_en      ),
<%include file="/toplevel_snippets/special_signals_portmap.tpl" args="top=top, feature_info=feature_info, cio_info=cio_info, domain='Aon'" />\

<%include file="/chiplevel_snippets/intermodule_portmap.tpl" args="top=top, target='', domain='Aon', inter_pd=True, feedthrough=False, last_snippet=False" />\

<%include file="/chiplevel_snippets/intermodule_portmap.tpl" args="top=top, target='', domain='Aon', inter_pd=False, feedthrough=True, last_snippet=True" />\
  );

endmodule
