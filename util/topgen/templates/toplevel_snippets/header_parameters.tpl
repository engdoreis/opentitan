## Copyright lowRISC contributors (OpenTitan project).
## Licensed under the Apache License, Version 2.0, see LICENSE for details.
## SPDX-License-Identifier: Apache-2.0
<%import topgen.lib as lib%>\
<%page args="top, domain, feedthrough"/>\
<%
domain_modules = lib.get_all_modules(top, domain=domain)
# Escalation receivers may live in a domain other than the one hosting
# the alert_handler instance.
if domain != '' and not lib.find_modules(domain_modules, "alert_handler"):
  domain_modules = domain_modules + lib.find_modules(top["module"], "alert_handler")
last_modidx_with_params = -1
for idx, module in enumerate(domain_modules):
  if len(module["param_list"]):
    last_modidx_with_params = idx
%>\
% if lib.num_rom_ctrl(lib.get_all_modules(top)) == 0:
  // Manually defined parameters
  parameter BootRomInitFile = "",

% endif
  // Auto-inferred parameters
% for m in domain_modules:
  % if not lib.is_inst(m):
<% continue %>
  % endif
<% param_list_filtered = [p for p in m["param_list"] if p.get("local") == "false" and p.get("expose") == "true"] %>\
  % if not feedthrough and param_list_filtered:
  // parameters for ${m['name']}
  % endif
  % for p_exp in param_list_filtered:
<%
    p_type = p_exp.get('type')
    p_type_word = p_type + ' ' if p_type else ''

    p_lhs = f'{p_type_word}{p_exp["name_top"]}'

    if 'unpacked_dimensions' in p_exp:
      p_lhs += p_exp['unpacked_dimensions']

    p_rhs = p_exp['default']

    params_follow = not loop.last or loop.parent.index < last_modidx_with_params
    comma_char = ',' if params_follow else ''
%>\
    % if feedthrough:
  .${p_exp["name_top"]}(${p_exp["name_top"]})${comma_char}
    % else:
      % if 12 + len(p_lhs) + 3 + len(str(p_rhs)) + 1 < 100:
  parameter ${p_lhs} = ${p_rhs}${comma_char}
      % else:
  parameter ${p_lhs} =
      ${p_rhs}${comma_char}
      % endif
    % endif
  % endfor
% endfor
