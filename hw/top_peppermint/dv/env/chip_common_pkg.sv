// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Parameters, types and constants shared throughout the Peppermint top-level testbench.
//
// This package holds the chip-level facts that both the testbench module and the UVM environment
// need, and carry no dependency on UVM. Keeping them out of chip_env_pkg lets tb.sv import them
// without pulling in the environment classes, and gives the agents and models being built a single
// place to agree with the testbench on widths and addresses.
//
// TODO: the environment should be told these by tb.sv through uvm_config_db rather than importing
//   them, which also moves this file to tb/ (peppermint-embargoed#45).
package chip_common_pkg;

  import dv_utils_pkg::uint;

  // Base clock frequencies.
  //
  // clk_main is the post-reset PLL output. Firmware programs the PLL register-map mirror model to
  // raise it to 400 MHz, at which point the model retunes the clk_rst_if that drives it, so the
  // value below is only what clk_main comes up at.
  // clk_aon is nominally 32.768 kHz. The clk_rst_if API takes whole kHz, so it is modelled at
  // 33 kHz; the 0.7 percent error is immaterial to the boot-latency sanity check, and the property
  // that matters, that clk_main is not an integer multiple of clk_aon, still holds.
  parameter int ClkMainResetFreqMhz = 25;
  parameter int ClkAonFreqKhz       = 33;

  // How long POR is held, counted in AON clock cycles so that it stays correct if the AON frequency
  // changes. Anything less than one AON cycle is not reliably seen.
  parameter int NumAonClksPorAssert = 10;

  // Budget for the rom_ctrl check to complete after reset. rom_ctrl digests the whole 192 KiB ROM
  // through KMAC on clk_main, which runs at the 25 MHz PLL reset default until firmware raises it.
  //
  // TODO: revisit when the clock, reset and power managers are real (peppermint-embargoed#33).
  // 100 ms is about 3x the slowest of 33 measured smoke runs (32.4 ms). Over-budgeted on purpose:
  // it costs only a slower report on a genuine hang, and the power-handshake class of hang is
  // caught within about 3 ms by MainRstReleasedAfterPor_A regardless.
  parameter int RomCheckTimeoutNs = 100_000_000;

  // Width of the external noise-source bus into entropy_src.
  //
  // This must match the EntropySrcRngBusWidth parameter of top_peppermint. tb.sv compares the two
  // at time zero and fatals on a mismatch.
  parameter int EsRngBusWidth = 4;

  // Bit rate of the external noise source
  parameter int EsRngBitRateKbps   = 400;
  parameter int EsRngSampleRateKhz = EsRngBitRateKbps / EsRngBusWidth;

  // Base of the SW test framework window, in the unmapped DV space carved out of the rv_core_ibex
  // CFG region, where the simulation SRAM is mapped so a C test on Ibex can report status and logs
  // without needing a real peripheral.
  parameter bit [top_pkg::TL_AW-1:0] SW_DV_START_ADDR =
      tl_main_pkg::ADDR_SPACE_RV_CORE_IBEX__CFG +
      rv_core_ibex_reg_pkg::RV_CORE_IBEX_DV_SIM_WINDOW_OFFSET;

  // Auto-generated parameters, supplying NUM_ALERTS and LIST_OF_ALERTS. The file is named after
  // chip_env_pkg because topgen's template is, and the sibling tops also include it from
  // chip_common_pkg, so the naming is the shared convention.
  `include "autogen/chip_env_pkg__params.sv"

endpackage: chip_common_pkg
