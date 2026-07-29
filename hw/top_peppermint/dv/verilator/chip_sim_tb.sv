// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

module chip_sim_tb (
  // Clock and Reset
  input clk_i,
  input rst_ni
);

  // DUT: Only clock and reset in port list, I/O driven via XMR
  chip_peppermint_verilator u_dut (
    .clk_i,
    .rst_ni
  );

  `define RV_CORE_IBEX      u_dut.top_peppermint.peppermint_pd_main.u_rv_core_ibex
  `define SIM_SRAM_IF       u_sim_sram.u_sim_sram_if

  // Detect SW test termination.
  sim_sram u_sim_sram (
    .clk_i    (`RV_CORE_IBEX.clk_i),
    .rst_ni   (`RV_CORE_IBEX.rst_ni),
    .tl_in_i  (tlul_pkg::tl_h2d_t'(`RV_CORE_IBEX.u_tlul_req_buf.out_o)),
    .tl_in_o  (),
    .tl_out_o (),
    .tl_out_i ()

  );

  // Connect the sim SRAM directly inside rv_core_ibex.
  assign `RV_CORE_IBEX.tl_win_d2h = u_sim_sram.tl_in_o;

  // Instantiate the SW test status interface & connect signals from sim_sram_if instance
  // instantiated inside sim_sram. Bind would have worked nicely here, but Verilator segfaults
  // when trace is enabled (#3951).
  sw_test_status_if u_sw_test_status_if (
    .clk_i    (`SIM_SRAM_IF.clk_i),
    .rst_ni   (`SIM_SRAM_IF.rst_ni),
    .fetch_en (1'b0),
    .wr_valid (`SIM_SRAM_IF.wr_valid),
    .addr     (`SIM_SRAM_IF.tl_h2d.a_address),
    .data     (`SIM_SRAM_IF.tl_h2d.a_data[15:0])
  );

  // Set the start address of the simulation SRAM.
  // Use offset 0 within the sim SRAM for SW test status indication.
  initial begin
    `SIM_SRAM_IF.start_addr = `VERILATOR_TEST_STATUS_ADDR;
    u_sw_test_status_if.sw_test_status_addr = `SIM_SRAM_IF.start_addr;
  end

  always @(posedge clk_i) begin
    if (u_sw_test_status_if.sw_test_done) begin
      $display("Verilator sim termination requested");
      $display("Your simulation wrote to 0x%h", u_sw_test_status_if.sw_test_status_addr);
      dv_test_status_pkg::dv_test_status(u_sw_test_status_if.sw_test_passed);
      $finish;
    end
  end

  `undef RV_CORE_IBEX
  `undef SIM_SRAM_IF


endmodule // chip_sim_tb
