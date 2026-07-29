// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

module clkmgr_bind;
`ifndef GATE_LEVEL
  bind clkmgr tlul_assert #(
    .EndpointType("Device")
  ) tlul_assert_device (.clk_i, .rst_ni, .h2d(tl_i), .d2h(tl_o));

  // In top-level testbench, do not bind the csr_assert_fpv to reduce simulation time.
`ifndef TOP_LEVEL_DV
  bind clkmgr clkmgr_csr_assert_fpv clkmgr_csr_assert (.clk_i, .rst_ni, .h2d(tl_i), .d2h(tl_o));
`endif

  bind clkmgr clkmgr_pwrmgr_sva_if #(.IS_USB(0)) clkmgr_pwrmgr_main_sva_if (
    .clk_i,
    .rst_ni,
    .clk_en(pwr_i.main_ip_clk_en),
    .status(pwr_o.main_status)
  );

  // Assertions for transactional clocks.

  // AON clock gating enables.
  bind clkmgr clkmgr_aon_cg_en_sva_if clkmgr_aon_cg_aon_secure (
    .cg_en(cg_en_o.aon_secure == prim_mubi_pkg::MuBi4True)
  );

  // Non-AON clock gating enables with no software control.
  bind clkmgr clkmgr_cg_en_sva_if clkmgr_cg_main_secure (
    .clk(clk_main),
    .rst_n(rst_main_ni),
    .ip_clk_en(clk_main_en),
    .sw_clk_en(1'b1),
    .scanmode(prim_mubi_pkg::MuBi4False),
    .cg_en(cg_en_o.main_secure == prim_mubi_pkg::MuBi4True)
  );

  // Software controlled gating enables.
  // Hint controlled gating enables.
`endif
endmodule : clkmgr_bind
