// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

package clkmgr_pkg;


  // clocks generated and broadcast
  typedef struct packed {
    logic clk_aon_secure;
    logic clk_main_secure;
  } clkmgr_out_t;

  // clock gating indication for alert handler
  typedef struct packed {
    prim_mubi_pkg::mubi4_t aon_secure;
    prim_mubi_pkg::mubi4_t main_secure;
  } clkmgr_cg_en_t;

  parameter int NumOutputClk = 2;



endpackage // clkmgr_pkg
