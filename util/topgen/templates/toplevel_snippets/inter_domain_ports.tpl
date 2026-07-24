## Copyright lowRISC contributors (OpenTitan project).
## Licensed under the Apache License, Version 2.0, see LICENSE for details.
## SPDX-License-Identifier: Apache-2.0
##
## Clocks / resets this power domain exports to the other power domains.
## Only emitted for tops opting into `inter_domain.flat_clk_rst`; the
## receiving side declares the matching inputs in port_special_signals.tpl.
<%import topgen.lib as lib%>\
<%page args="top, domain, mgr"/>\
<%
signals = lib.get_inter_domain_clk_rst_out(top, domain, mgr)
max_typewidth = max((len(lib.im_defname(s)) for s in signals), default=0)
%>\
% if signals:
  // ${'Clocks' if mgr == 'clkmgr' else 'Resets'} to the other power domains
  % for sig in signals:
  output ${lib.ljust(lib.im_defname(sig), max_typewidth)} ${lib.inter_domain_port(sig['name'], 'o')},
  % endfor
% endif
