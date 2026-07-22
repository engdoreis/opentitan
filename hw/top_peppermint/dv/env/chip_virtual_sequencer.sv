// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Peppermint top-level virtual sequencer
class chip_virtual_sequencer extends cip_base_virtual_sequencer #(
    .CFG_T(chip_env_cfg),
    .COV_T(chip_env_cov)
  );
  `uvm_component_utils(chip_virtual_sequencer)

  // TODO: add sequencer handles once the agents exist (see chip_env / chip_env_cfg):
  //   ahb_mgr_sequencer_h       - ahb_sequencer, reuse (Caliptra PR #1312, ingress)
  //   ahb_sub_sequencer_h       - ahb_sub_sequencer, build (egress + neg testing)
  //   pwr_handshake_sequencer_h - pwr_handshake_sequencer, build
  //   jtag_riscv_sequencer_h    - jtag_riscv_sequencer, build (DMI transport)

  // Standard SV/UVM methods
  extern function new(string name, uvm_component parent);
endclass: chip_virtual_sequencer


function chip_virtual_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction: new
