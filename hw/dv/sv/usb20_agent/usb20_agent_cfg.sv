// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class usb20_agent_cfg extends dv_base_agent_cfg;

  // interface handle used by driver, monitor & the sequencer, via cfg handle
  virtual usb20_block_if bif;
  virtual clk_rst_if clk_rst_if_i;

  `uvm_object_utils_begin(usb20_agent_cfg)
  `uvm_object_utils_end

  `uvm_object_new

endclass
