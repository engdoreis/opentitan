// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

module ahb_bridge
  import ahb_pkg::*;
  import tlul_pkg::*;
(
  input  logic     clk_i,
  input  logic     rst_ni,

  // Ingress
  input  ahb_h2d_t ahb_sub_h2d_i,
  output ahb_d2h_t ahb_sub_d2h_o,
  output tl_h2d_t  socmbx_tl_h_o,
  input  tl_d2h_t  socmbx_tl_h_i,

  // Egress
  input  tl_h2d_t  ctn_tl_d_i,
  output tl_d2h_t  ctn_tl_d_o,
  output ahb_h2d_t ahb_mgr_h2d_o,
  input  ahb_d2h_t ahb_mgr_d2h_i
);

  ahb_to_tlul u_ahb_to_tlul (
    .clk_i,
    .rst_ni,
    .tl_o  (socmbx_tl_h_o),
    .tl_i  (socmbx_tl_h_i),
    .ahb_i (ahb_sub_h2d_i),
    .ahb_o (ahb_sub_d2h_o)
  );

  ahb_from_tlul u_ahb_from_tlul (
    .clk_i,
    .rst_ni,
    .tl_i  (ctn_tl_d_i),
    .tl_o  (ctn_tl_d_o),
    .ahb_o (ahb_mgr_h2d_o),
    .ahb_i (ahb_mgr_d2h_i)
  );

endmodule
