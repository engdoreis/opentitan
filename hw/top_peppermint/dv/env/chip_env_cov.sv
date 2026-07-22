// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Peppermint top-level functional coverage
class chip_env_cov extends cip_base_env_cov #(.CFG_T(chip_env_cfg));
  `uvm_component_utils(chip_env_cov)

  // Standard SV/UVM methods
  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
endclass: chip_env_cov


function chip_env_cov::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction: new

function void chip_env_cov::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction: build_phase
