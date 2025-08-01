// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// This clas provides knobs to set the weights for various seq random variables.
class pattgen_seq_cfg extends uvm_object;
  `uvm_object_utils(pattgen_seq_cfg)
  `uvm_object_new

  // knobs for number of requests sent to dut
  uint pattgen_min_num_trans         = 10;
  uint pattgen_max_num_trans         = 30;

  // knobs for number of retry after reset
  // for stress_all, stress_all_with_rand_reset
  uint pattgen_min_num_runs          = 1;
  uint pattgen_max_num_runs          = 5;

  // see the specification document, the effective values of prediv, len, and reps
  // are incremented from the corresponding register values

  uint pattgen_min_prediv            = PredivMinValue;
  uint pattgen_max_prediv            = PredivMaxValue;
  uint pattgen_min_len               = LenMinValue;
  uint pattgen_max_len               = LenMaxValue;
  uint pattgen_min_reps              = RepsMinValue;
  uint pattgen_max_reps              = RepsMaxValue;

  uint pattgen_sync_channels_pct     = 30;  // in percentage

  // for error_vseq
  uint error_injected_pct            = 10;  // in percentage
  uint data_top_pct                  = 10;
  uint data_bottom_pct               = 80;
  uint data_middle_pct               = 10;

endclass : pattgen_seq_cfg
