// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Peppermint top-level base test
//
// The base class dv_base_test creates cfg and env, and looks up the UVM_TEST_SEQ plusarg to run
// the selected vseq - so nothing more is required for a basic run.
class chip_base_test extends cip_base_test #(
    .ENV_T(chip_env),
    .CFG_T(chip_env_cfg)
  );
  `uvm_component_utils(chip_base_test)

  // Standard SV/UVM methods
  extern function new(string name, uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
endclass: chip_base_test


function chip_base_test::new(string name, uvm_component parent = null);
  super.new(name, parent);
endfunction: new

function void chip_base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);

  // The following plusargs are only valid for SW based tests (i.e., no stubbed CPU).
  //
  // Knob to configure writing SW logs to a separate file (enabled by default).
  void'($value$plusargs("write_sw_logs_to_file=%0b", cfg.write_sw_logs_to_file));

  // Knob to set the sw_test_timeout_ns (set to 12ms by default)
  void'($value$plusargs("sw_test_timeout_ns=%0d", cfg.sw_test_timeout_ns));

  // TODO: SW image selection

  // Generous top-level timeout, sized to sit above RomCheckTimeoutNs with room for the test itself
  // TODO: revisit when the clock, reset and power managers are real (peppermint-embargoed#33).
  test_timeout_ns = 200_000_000;
  test_timeout_ns = `DV_MAX2(test_timeout_ns, 5 * cfg.sw_test_timeout_ns);
  `uvm_info(`gfn, $sformatf("test_timeout_ns = %0d", test_timeout_ns), UVM_LOW)

  // TODO: add OTP-image select plusarg (LC state) and use_jtag_dmi knob
endfunction: build_phase
