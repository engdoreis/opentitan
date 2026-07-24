## Copyright lowRISC contributors (OpenTitan project).
## Licensed under the Apache License, Version 2.0, see LICENSE for details.
## SPDX-License-Identifier: Apache-2.0
<%import topgen.lib as lib%>\
<%from topgen.clocks import Clocks%>\
<%from topgen.merge import get_alerts_with_unique_lpg_idx%>\
<%from topgen.resets import Resets%>\
<%page args="top, feature_info, domain"/>\
<%
domain_has_clkmgr = lib.find_module(top["module"], "clkmgr", domain=domain) is not None
domain_has_rstmgr = lib.find_module(top["module"], "rstmgr", domain=domain) is not None
domain_has_alert_handler = lib.find_module(top["module"], "alert_handler", domain=domain) is not None
# Clocks and resets this domain hands to the other power domains individually.
flat_clk_rst = lib.flat_inter_domain_clk_rst(top)
exported_clk_rst = (lib.get_inter_domain_clk_rst_out(top, domain, "clkmgr") +
                    lib.get_inter_domain_clk_rst_out(top, domain, "rstmgr"))
exported_paths = {sig["src"] for sig in exported_clk_rst}
# Without an alert handler in this domain, nothing consumes the clock gating and reset
# enable indication signals. Tie them off if they enter this domain as inputs (in the
# clkmgr / rstmgr domains they are consumed by the output ports).
if flat_clk_rst:
  tie_off_cg_en = tie_off_clocks = domain_has_clkmgr
  tie_off_rst_en = tie_off_resets = domain_has_rstmgr
else:
  tie_off_cg_en = domain_has_alert_handler or not domain_has_clkmgr
  tie_off_rst_en = domain_has_alert_handler or not domain_has_rstmgr
  tie_off_clocks = not domain_has_clkmgr
  tie_off_resets = not domain_has_rstmgr
# The tie-off vectors below are sized from these sets, so a domain that leaves
# nothing unused must not declare them at all.
# get all known typed clocks and add them to a dict
# this is used to generate the tie-off assignments further below
clocks = top['clocks']
assert isinstance(clocks, Clocks)
typed_clocks = clocks.typed_clocks()
unused_cg_en = {lib.get_clock_lpg_path(top, clk, domain) for clk in typed_clocks.all_clocks()}
unused_clocks = {lib.get_clock_path(top, clk, domain) for clk in typed_clocks.all_clocks()}

# get all known resets and add them to a dict
# this is used to generate the tie-off assignments further below
resets = top['resets']
assert isinstance(resets, Resets)
output_rsts = resets.get_top_resets()
unused_rst_en = set()
unused_resets = set()

for rst in output_rsts:
  for dom in top['power']['domains']:
    path = lib.get_reset_lpg_path(top, resets.get_reset_by_name(rst.name)._asdict(), domain, False, dom)
    unused_rst_en.add(path)
    unused_resets.add(lib.get_reset_path(top, {'name': rst.name, 'domain': dom}, domain))
    if rst.shadowed:
      path = lib.get_reset_lpg_path(top, resets.get_reset_by_name(rst.name)._asdict(), domain, True, dom)
      unused_rst_en.add(path)
      unused_resets.add(lib.get_reset_path(top, {'name': rst.name, 'domain': dom}, domain, True))

# Go over all modules of power domain at hand and remove all used resets and clocks from the
# respective unused_ set.
for m in lib.get_all_modules(top, domain=domain):
  if not lib.is_inst(m):
    continue
  for clock_sig in m.get("clock_connections").values():
    unused_clocks.discard(clock_sig)
  for port, reset in m.get("reset_connections").items():
    unused_resets.discard(lib.get_reset_path(top, {'name': reset['name'], 'domain': reset['domain']}, domain))
    if lib.is_shadowed_port(name_to_block[m['type']], port):
      unused_resets.discard(lib.get_reset_path(top, {'name': reset['name'], 'domain': reset['domain']}, domain, True))

# Anything handed to another power domain is used, wherever it ends up.
unused_cg_en  -= exported_paths
unused_clocks -= exported_paths
unused_rst_en -= exported_paths
unused_resets -= exported_paths

tie_off_clocks = tie_off_clocks and bool(unused_clocks)
tie_off_resets = tie_off_resets and bool(unused_resets)
%>\
% if exported_clk_rst:
  // Clocks and resets to the other power domains
% for sig in exported_clk_rst:
  assign ${lib.inter_domain_port(sig['name'], 'o')} = ${sig['src']};
% endfor

% endif
% if domain_has_alert_handler:
  // Alert handler low power groups (LPGs)
  prim_mubi_pkg::mubi4_t [alert_handler_pkg::NLpg-1:0] lpg_cg_en;
  prim_mubi_pkg::mubi4_t [alert_handler_pkg::NLpg-1:0] lpg_rst_en;

<% k = 0 %>\
% for lpg in top['alert_lpgs']:
  // ${lpg['name']}
<%
  # Clocks in an "ext"-src group are never turned into a managed
  # clkmgr output/cg_en field at all, and are never gated.
  if lpg['clock_group'] is not None and lpg['clock_group'].src == "ext":
    cg_en = "prim_mubi_pkg::MuBi4False"
  else:
    cg_en = lib.get_clock_lpg_path(top, lpg['clock_connection'], domain, lpg['unmanaged_clock'])
    unused_cg_en.discard(cg_en)
  rst_en = lib.get_reset_lpg_path(top, lpg['reset_connection'], domain, False, None, lpg['unmanaged_reset'])
  unused_rst_en.discard(rst_en)
%>\
  assign lpg_cg_en[${k}] = ${cg_en};
  assign lpg_rst_en[${k}] = ${rst_en};
<% k += 1 %>\
% endfor
% for alert_group, alerts in top['incoming_alert'].items():
  % for unique_alert_lpg_entry in get_alerts_with_unique_lpg_idx(alerts):
  assign lpg_cg_en[${k}] = incoming_lpg_cg_en_${alert_group}_i[${unique_alert_lpg_entry["lpg_idx"]}];
  assign lpg_rst_en[${k}] = incoming_lpg_rst_en_${alert_group}_i[${unique_alert_lpg_entry["lpg_idx"]}];
<% k += 1 %>\
  % endfor
% endfor

% endif
## The LPG assigns above discard from these sets, so re-check them here.
<% tie_off_cg_en = tie_off_cg_en and bool(unused_cg_en) %>\
<% tie_off_rst_en = tie_off_rst_en and bool(unused_rst_en) %>\
% if tie_off_cg_en or tie_off_rst_en:
// Tie off unused clock- and reset enables
//VCS coverage off
// pragma coverage off
% if tie_off_cg_en:
  prim_mubi_pkg::mubi4_t [${len(unused_cg_en)-1}:0] unused_cg_en;
% endif
% if tie_off_rst_en:
  prim_mubi_pkg::mubi4_t [${len(unused_rst_en)-1}:0] unused_rst_en;
% endif

% if tie_off_cg_en:
% for i, clk in enumerate(sorted(unused_cg_en)):
  assign unused_cg_en[${i}] = ${clk};
% endfor

% endif
% if tie_off_rst_en:
% for i, rst in enumerate(sorted(unused_rst_en)):
  assign unused_rst_en[${i}] = ${rst};
% endfor
// pragma coverage on
//VCS coverage on
% endif

% endif\

% if domain_has_clkmgr or domain_has_rstmgr:
% for alert_group, lpgs in top['outgoing_alert_lpgs'].items():
  // Outgoing LPGs for alert group ${alert_group}
  % for k, lpg in enumerate(lpgs):
  // ${lpg['name']}
<%
    if lpg['clock_group'] is not None and lpg['clock_group'].src == "ext":
      cg_en = "prim_mubi_pkg::MuBi4False"
    else:
      cg_en = lib.get_clock_lpg_path(top, lpg['clock_connection'], domain, lpg['unmanaged_clock'])
    rst_en = lib.get_reset_lpg_path(top, lpg['reset_connection'], domain, False, None, lpg['unmanaged_reset'])
%>\
% if domain_has_clkmgr:
  assign outgoing_lpg_cg_en_${alert_group}_o[${k}] = ${cg_en};
% endif
% if domain_has_rstmgr:
  assign outgoing_lpg_rst_en_${alert_group}_o[${k}] = ${rst_en};
% endif
  % endfor
% endfor

% endif\

% if tie_off_clocks or tie_off_resets:
// Tie off unused clocks and resets
//VCS coverage off
// pragma coverage off
% if tie_off_clocks:
  logic [${len(unused_clocks)-1}:0] unused_clocks;
% for i, clk in enumerate(sorted(unused_clocks)):
  assign unused_clocks[${i}] = ${clk};
% endfor

% endif\

% if tie_off_resets:
  logic [${len(unused_resets)-1}:0] unused_resets;
% for i, rst_path in enumerate(sorted(unused_resets)):
  assign unused_resets[${i}] = ${rst_path};
% endfor
% endif
// pragma coverage on
//VCS coverage on
% endif
