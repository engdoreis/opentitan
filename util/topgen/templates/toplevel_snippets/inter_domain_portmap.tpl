## Copyright lowRISC contributors (OpenTitan project).
## Licensed under the Apache License, Version 2.0, see LICENSE for details.
## SPDX-License-Identifier: Apache-2.0
##
## Connect the clocks / resets this power domain exports to the nets carrying
## them to the other power domains. Only emitted for tops opting into
## `inter_domain.flat_clk_rst`.
<%import topgen.lib as lib%>\
<%page args="top, domain, mgr"/>\
<%
signals = lib.get_inter_domain_clk_rst_out(top, domain, mgr)
%>\
% if signals:
    // ${'Clocks' if mgr == 'clkmgr' else 'Resets'} to the other power domains
  % for sig in signals:
    .${lib.inter_domain_port(sig['name'], 'o')}(${sig['name']}),
  % endfor
% endif
