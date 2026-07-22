// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Assertions on the Peppermint power handshake with the SoC
//
// Bound to top_peppermint in chip_pwr_handshake_bind.sv, which chip_sim_cfg.hjson names in
// sim_tops. Every signal checked is a port of the top, so any testbench instantiating it gets these
// checks.
//
// TODO: add the handshake ordering rules once the spec is signed off (peppermint-embargoed#30).
//   Three are agreed: main-domain reset asserts before power and clock are removed, both are stable
//   before it is released, and rst_soc_cpu_no does not drop when the main domain powers off. Follow
//   top_earlgrey/dv/sva/clk_ctrl_and_main_pd_sva_if.sv and its MainPdHandshakeOn_A/Off_A pair.

`include "prim_assert.sv"

interface chip_pwr_handshake_sva_if (
  input wire clk_aon_i,
  input wire por_ni,
  input wire rst_main_no_i  // Output of the DUT, hence the _no, and an input here
);

  // Cycles allowed between POR releasing and the main domain leaving reset. Observed is under
  // twenty, a handful of pwrmgr slow-FSM states; generous because only a hang needs catching here
  localparam int NumAonClksMainRstRelease = 100;

  // Set by a test to switch these assertions off, for instance one that deliberately breaks the
  // handshake or drives the power inputs itself. By default, all the assertions are enabled.
  bit disable_sva;

  // The main domain has to leave reset once POR releases
  //
  // When it does not, pwrmgr is usually stuck in SlowPwrStateMainPowerOn waiting for main_pok with
  // no fault reported, and the first symptom is the rom_ctrl check timing out tens of milliseconds
  // later, nowhere near the cause. Also catches the day the power_main_req polarity defect is fixed
  // and the chip_if supply model has to stop inverting (TODO peppermint-embargoed#37).
  //
  // Triggered on POR release, so it cannot be reset-disabled. Low-power entry never retriggers it.
  MainRstReleasedAfterPor_A:
    assert property (@(posedge clk_aon_i) disable iff (disable_sva)
                     $rose(por_ni) |-> ##[1:NumAonClksMainRstRelease] rst_main_no_i)
    else `ASSERT_ERROR(MainRstReleasedAfterPor_A)

  // The main domain is still in reset when POR releases
  //
  // Without this, the assertion above is satisfied at cycle 1 by a reset that was already released,
  // so the pair proves an actual transition. POR has been held NumAonClksPorAssert cycles by
  // now, so there is no race against rstmgr dropping rst_main_no.
  MainRstAssertedAtPorRelease_A:
    assert property (@(posedge clk_aon_i) disable iff (disable_sva)
                     $rose(por_ni) |-> !rst_main_no_i)
    else `ASSERT_ERROR(MainRstAssertedAtPorRelease_A)

endinterface: chip_pwr_handshake_sva_if
