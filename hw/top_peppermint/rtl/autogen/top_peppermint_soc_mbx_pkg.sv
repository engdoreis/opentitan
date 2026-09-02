// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------//
// PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
//
// util/topgen.py -t hw/top_peppermint/data/top_peppermint.hjson
//                -o hw/top_peppermint/

package top_peppermint_soc_mbx_pkg;
  /**
   * Peripheral base address for soc device on mbx0 in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_SOC_MBX_MBX0_SOC_BASE_ADDR = 32'h0;

  /**
   * Peripheral size in bytes for soc device on mbx0 in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_SOC_MBX_MBX0_SOC_SIZE_BYTES = 32'h20;

  /**
   * Peripheral base address for soc device on mbx1 in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_SOC_MBX_MBX1_SOC_BASE_ADDR = 32'h10000;

  /**
   * Peripheral size in bytes for soc device on mbx1 in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_SOC_MBX_MBX1_SOC_SIZE_BYTES = 32'h20;


endpackage
