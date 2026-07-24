// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// This interface is used to sample some csr values directly from the rtl
// to avoid any confusion.

<%
from ipgen.clkmgr_gen import get_rg_srcs
rg_srcs = get_rg_srcs(typed_clocks)

## The number of recoverable error bits is:
## 1 for shadow_update
## 2 for each clock measurements
num_recov_errors = 1 + 2 * len(rg_srcs)
num_fatal_errors = 3
# Signal widths in SV can never be 0; a top with no sw-gated/hint-gated
# clocks still needs an unused 1bit placeholders for these buses.
num_sw_clks = max(1, len(typed_clocks['sw_clks']))
num_idle_bits = max(1, len(hint_names))
%>\
interface clkmgr_csrs_if (
  input logic clk,
  input logic [${num_recov_errors-1}:0] recov_err_csr,
  input logic [${num_fatal_errors-1}:0] fatal_err_csr,
  input logic [${num_sw_clks-1}:0] clk_enables,
  input logic [${num_idle_bits-1}:0] clk_hints
);

clocking csrs_cb @(posedge clk);
  input recov_err_csr;
  input fatal_err_csr;
  input clk_enables;
  input clk_hints;
endclocking

endinterface : clkmgr_csrs_if
