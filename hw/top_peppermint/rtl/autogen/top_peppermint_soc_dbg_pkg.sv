// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------//
// PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
//
// util/topgen.py -t hw/top_peppermint/data/top_peppermint.hjson
//                -o hw/top_peppermint/

package top_peppermint_soc_dbg_pkg;
  /**
   * Peripheral base address for dmi device on lc_ctrl in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_SOC_DBG_LC_CTRL_DMI_BASE_ADDR = 32'h3000;

  /**
   * Peripheral size in bytes for dmi device on lc_ctrl in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_SOC_DBG_LC_CTRL_DMI_SIZE_BYTES = 32'h1000;

  /**
   * Peripheral base address for dbg device on rv_dm in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_SOC_DBG_RV_DM_DBG_BASE_ADDR = 32'h0;

  /**
   * Peripheral size in bytes for dbg device on rv_dm in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_SOC_DBG_RV_DM_DBG_SIZE_BYTES = 32'h200;


endpackage
