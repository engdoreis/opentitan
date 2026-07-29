// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// SoC Proxy (Peppermint): minimal placeholder for the future AHB<->TL-UL
// bridge. The main crossbar already arbitrates every internal host (CPU,
// DMA) down to a single "ctn" device port, so there is nothing left to mux
// here -- this module just forwards that port straight out to the chip
// boundary.

module soc_proxy (
  input logic clk_i,
  input logic rst_ni,

  input  tlul_pkg::tl_h2d_t ctn_tl_i,
  output tlul_pkg::tl_d2h_t ctn_tl_o,

  output tlul_pkg::tl_h2d_t ctn_tl_h2d_o,
  input  tlul_pkg::tl_d2h_t ctn_tl_d2h_i
);

  logic unused_clk_rst;
  assign unused_clk_rst = ^{clk_i, rst_ni};

  assign ctn_tl_h2d_o = ctn_tl_i;
  assign ctn_tl_o     = ctn_tl_d2h_i;

endmodule
