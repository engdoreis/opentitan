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
  input  ahb_m2s_t ahb_sub_m2s_i,
  output ahb_s2m_t ahb_sub_s2m_o,
  output tl_h2d_t  socmbx_tl_h_o,
  input  tl_d2h_t  socmbx_tl_h_i,

  // Egress
  input  tl_h2d_t  ctn_tl_d_i,
  output tl_d2h_t  ctn_tl_d_o,
  output ahb_m2s_t ahb_mgr_m2s_o,
  input  ahb_s2m_t ahb_mgr_s2m_i
);

  ahb_to_tlul u_ahb_to_tlul (
    .clk_i,
    .rst_ni,
    .tl_o  (socmbx_tl_h_o),
    .tl_i  (socmbx_tl_h_i),
    .ahb_i (ahb_sub_m2s_i),
    .ahb_o (ahb_sub_s2m_o)
  );

  ahb_from_tlul u_ahb_from_tlul (
    .clk_i,
    .rst_ni,
    .tl_i  (ctn_tl_d_i),
    .tl_o  (ctn_tl_d_o),
    .ahb_o (ahb_mgr_m2s_o),
    .ahb_i (ahb_mgr_s2m_i)
  );

endmodule
