## Copyright lowRISC contributors (OpenTitan project).
## Licensed under the Apache License, Version 2.0, see LICENSE for details.
## SPDX-License-Identifier: Apache-2.0
<%import topgen.lib as lib%>\
<%from topgen.merge import alert_handler_signals%>\
<%page args="top, feature_info, cio_info, gen_bkdr_loader"/>\
% if top.get('ast', True):
    // Base clocks from AST
    .ast_base_clks_i(ast_base_clks),
% else:
    // Externally supplied base clocks
% for clk in top['clocks'].typed_clocks().ast_clks:
    .${clk}(${clk}),
% endfor
% endif

    // Manual DFT signals
    .scan_rst_ni(scan_rst_n),
% for domain in feature_info["has_scan_en"]:
% if feature_info["has_scan_en"][domain]:
    .scan_en_i  (scan_en   ),
<% break %>
% endif
% endfor
    .scanmode_i (scanmode  ),
% for alert_group in top['incoming_alert'].keys():

    // Incoming alerts for group ${alert_group}
    .incoming_alert_${alert_group}_tx_i(incoming_alert_${alert_group}_tx),
    .incoming_alert_${alert_group}_rx_o(incoming_alert_${alert_group}_rx),
    .incoming_lpg_cg_en_${alert_group}_i(incoming_lpg_cg_en_${alert_group}),
    .incoming_lpg_rst_en_${alert_group}_i(incoming_lpg_rst_en_${alert_group}),
% endfor
% for irq_group in top['incoming_interrupt'].keys():

    // Incoming interrupts for group ${irq_group}
    .incoming_interrupt_${irq_group}_i(incoming_interrupt_${irq_group}),
% endfor

% if feature_info["has_pinmux"]:
% if cio_info["num_mio_pads"] != 0:
% if gen_bkdr_loader:
    // Multiplexed I/O to backdoor
    .mio_in_i (mio_bkdr_in ),
    .mio_out_o(mio_bkdr_out),
    .mio_oe_o (mio_bkdr_oe ),
% else:
    // Multiplexed I/O
    .mio_in_i (mio_in ),
    .mio_out_o(mio_out),
    .mio_oe_o (mio_oe ),
% endif

% endif
% if cio_info["num_dio_total"] != 0:
    // Dedicated I/O
    .dio_in_i (dio_in ),
    .dio_out_o(dio_out),
    .dio_oe_o (dio_oe ),

% endif
    // Pad attributes
% if gen_bkdr_loader:
    .mio_attr_o(mio_bkdr_attr),
% else:
    .mio_attr_o(mio_attr),
% endif
    .dio_attr_o(dio_attr),

% endif\
