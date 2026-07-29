// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------//
// PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
// util/topgen.py -t hw/top_peppermint/data/top_peppermint.hjson
//                -o hw/top_peppermint/

#ifndef OPENTITAN_HW_TOP_PEPPERMINT_SW_AUTOGEN_TOP_PEPPERMINT_SOC_MBX_MEMORY_H_
#define OPENTITAN_HW_TOP_PEPPERMINT_SW_AUTOGEN_TOP_PEPPERMINT_SOC_MBX_MEMORY_H_

/**
 * @file
 * @brief Assembler-only Top-Specific Definitions.
 *
 * This file contains preprocessor definitions for use within assembly code.
 *
 * These are not shared with C/C++ code because these are only allowed to be
 * preprocessor definitions, no data or type declarations are allowed. The
 * assembler is also stricter about literals (not allowing suffixes for
 * signed/unsigned which are sensible to use for unsigned values in C/C++).
 */

// Include guard for assembler
#ifdef __ASSEMBLER__


/**
 * Peripheral base address for soc device on mbx0 in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_SOC_MBX_MBX0_SOC_BASE_ADDR 0x0

/**
 * Peripheral size for soc device on mbx0 in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_SOC_MBX_MBX0_SOC_BASE_ADDR and
 * `TOP_PEPPERMINT_SOC_MBX_MBX0_SOC_BASE_ADDR + TOP_PEPPERMINT_SOC_MBX_MBX0_SOC_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_SOC_MBX_MBX0_SOC_SIZE_BYTES 0x20
/**
 * Peripheral base address for soc device on mbx1 in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_SOC_MBX_MBX1_SOC_BASE_ADDR 0x100

/**
 * Peripheral size for soc device on mbx1 in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_SOC_MBX_MBX1_SOC_BASE_ADDR and
 * `TOP_PEPPERMINT_SOC_MBX_MBX1_SOC_BASE_ADDR + TOP_PEPPERMINT_SOC_MBX_MBX1_SOC_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_SOC_MBX_MBX1_SOC_SIZE_BYTES 0x20


#endif  // __ASSEMBLER__

#endif  // OPENTITAN_HW_TOP_PEPPERMINT_SW_AUTOGEN_TOP_PEPPERMINT_SOC_MBX_MEMORY_H_
