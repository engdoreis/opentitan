// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Peppermint top-level test package
package chip_test_pkg;
  import uvm_pkg::*;
  import cip_base_pkg::*;
  import chip_env_pkg::*;

  // Macro includes
  `include "uvm_macros.svh"
  `include "dv_macros.svh"

  // Package sources
  `include "chip_base_test.sv"
endpackage: chip_test_pkg
