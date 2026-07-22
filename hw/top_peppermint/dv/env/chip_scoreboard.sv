// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Peppermint top-level scoreboard
//
// Intentionally lightweight: top-level tests are directed and SW-driven, with stimulus and checks
// contained in the sequence / C test. Alert integrity and per-alert checks are handled by SVA / SW,
// not the scoreboard.
class chip_scoreboard extends cip_base_scoreboard #(
    .CFG_T (chip_env_cfg   ),
    .RAL_T (chip_reg_block ),
    .COV_T (chip_env_cov   )
  );
  `uvm_component_utils(chip_scoreboard)

  // TODO: add the analysis connections for the streams the top-level checks need. Prefer
  //   uvm_analysis_imp_decl imports with write_* methods over TLM FIFOs plus get() loops, though
  //   note cip_base_scoreboard hands down FIFOs for the TL, alert and EDN streams.

  // Standard SV/UVM methods
  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  // Class specific methods
  extern virtual function void reset(string kind = "HARD");
endclass: chip_scoreboard


function chip_scoreboard::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction: new

function void chip_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // TODO: create the analysis imports
endfunction: build_phase

task chip_scoreboard::run_phase(uvm_phase phase);
  // Disable alert signal integrity check to avoid false alert on low_power_group_en or
  // alert_init. Alert signal integrity can be checked by assertions.
  check_alert_sig_int_err = 0;
  // Disable individual alert checking. Alerts will be checked in SW or DV sequence.
  do_alert_check = 0;
  super.run_phase(phase);
endtask: run_phase

function void chip_scoreboard::reset(string kind = "HARD");
  super.reset(kind);
endfunction: reset
