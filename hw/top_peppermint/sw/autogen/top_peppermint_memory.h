// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------//
// PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
// util/topgen.py -t hw/top_peppermint/data/top_peppermint.hjson
//                -o hw/top_peppermint/

#ifndef OPENTITAN_HW_TOP_PEPPERMINT_SW_AUTOGEN_TOP_PEPPERMINT_MEMORY_H_
#define OPENTITAN_HW_TOP_PEPPERMINT_SW_AUTOGEN_TOP_PEPPERMINT_MEMORY_H_

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
 * Memory base for ram memory on sram_ctrl_ret_aon in top peppermint.
 */
#define TOP_PEPPERMINT_SRAM_CTRL_RET_AON_RAM_BASE_ADDR 0x40470000

/**
 * Memory size for ram memory on sram_ctrl_ret_aon in top peppermint.
 */
#define TOP_PEPPERMINT_SRAM_CTRL_RET_AON_RAM_SIZE_BYTES 0x2000

/**
 * Memory base for ram memory on sram_ctrl_main in top peppermint.
 */
#define TOP_PEPPERMINT_SRAM_CTRL_MAIN_RAM_BASE_ADDR 0x10000000

/**
 * Memory size for ram memory on sram_ctrl_main in top peppermint.
 */
#define TOP_PEPPERMINT_SRAM_CTRL_MAIN_RAM_SIZE_BYTES 0x30000

/**
 * Memory base for rom memory on rom_ctrl in top peppermint.
 */
#define TOP_PEPPERMINT_ROM_CTRL_ROM_BASE_ADDR 0x20000

/**
 * Memory size for rom memory on rom_ctrl in top peppermint.
 */
#define TOP_PEPPERMINT_ROM_CTRL_ROM_SIZE_BYTES 0x20000

/**
 * Memory base for ctn memory on ahb_bridge in top peppermint.
 */
#define TOP_PEPPERMINT_AHB_BRIDGE_CTN_BASE_ADDR 0x80000000

/**
 * Memory size for ctn memory on ahb_bridge in top peppermint.
 */
#define TOP_PEPPERMINT_AHB_BRIDGE_CTN_SIZE_BYTES 0x10000000


/**
 * Peripheral base address for pwrmgr in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_PWRMGR_BASE_ADDR 0x40400000

/**
 * Peripheral size for pwrmgr in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_PWRMGR_BASE_ADDR and
 * `TOP_PEPPERMINT_PWRMGR_BASE_ADDR + TOP_PEPPERMINT_PWRMGR_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_PWRMGR_SIZE_BYTES 0x80
/**
 * Peripheral base address for rstmgr in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_RSTMGR_BASE_ADDR 0x40410000

/**
 * Peripheral size for rstmgr in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_RSTMGR_BASE_ADDR and
 * `TOP_PEPPERMINT_RSTMGR_BASE_ADDR + TOP_PEPPERMINT_RSTMGR_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_RSTMGR_SIZE_BYTES 0x40
/**
 * Peripheral base address for clkmgr in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_CLKMGR_BASE_ADDR 0x40420000

/**
 * Peripheral size for clkmgr in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_CLKMGR_BASE_ADDR and
 * `TOP_PEPPERMINT_CLKMGR_BASE_ADDR + TOP_PEPPERMINT_CLKMGR_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_CLKMGR_SIZE_BYTES 0x40
/**
 * Peripheral base address for alert_handler in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_ALERT_HANDLER_BASE_ADDR 0x40450000

/**
 * Peripheral size for alert_handler in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_ALERT_HANDLER_BASE_ADDR and
 * `TOP_PEPPERMINT_ALERT_HANDLER_BASE_ADDR + TOP_PEPPERMINT_ALERT_HANDLER_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_ALERT_HANDLER_SIZE_BYTES 0x800
/**
 * Peripheral base address for rv_timer_aon in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_RV_TIMER_AON_BASE_ADDR 0x40430000

/**
 * Peripheral size for rv_timer_aon in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_RV_TIMER_AON_BASE_ADDR and
 * `TOP_PEPPERMINT_RV_TIMER_AON_BASE_ADDR + TOP_PEPPERMINT_RV_TIMER_AON_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_RV_TIMER_AON_SIZE_BYTES 0x200
/**
 * Peripheral base address for regs device on sram_ctrl_ret_aon in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_SRAM_CTRL_RET_AON_REGS_BASE_ADDR 0x40460000

/**
 * Peripheral size for regs device on sram_ctrl_ret_aon in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_SRAM_CTRL_RET_AON_REGS_BASE_ADDR and
 * `TOP_PEPPERMINT_SRAM_CTRL_RET_AON_REGS_BASE_ADDR + TOP_PEPPERMINT_SRAM_CTRL_RET_AON_REGS_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_SRAM_CTRL_RET_AON_REGS_SIZE_BYTES 0x40
/**
 * Peripheral base address for core device on otp_ctrl in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_OTP_CTRL_CORE_BASE_ADDR 0x30130000

/**
 * Peripheral size for core device on otp_ctrl in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_OTP_CTRL_CORE_BASE_ADDR and
 * `TOP_PEPPERMINT_OTP_CTRL_CORE_BASE_ADDR + TOP_PEPPERMINT_OTP_CTRL_CORE_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_OTP_CTRL_CORE_SIZE_BYTES 0x4000
/**
 * Peripheral base address for prim device on otp_macro in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_OTP_MACRO_PRIM_BASE_ADDR 0x30140000

/**
 * Peripheral size for prim device on otp_macro in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_OTP_MACRO_PRIM_BASE_ADDR and
 * `TOP_PEPPERMINT_OTP_MACRO_PRIM_BASE_ADDR + TOP_PEPPERMINT_OTP_MACRO_PRIM_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_OTP_MACRO_PRIM_SIZE_BYTES 0x20
/**
 * Peripheral base address for regs device on lc_ctrl in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_LC_CTRL_REGS_BASE_ADDR 0x30150000

/**
 * Peripheral size for regs device on lc_ctrl in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_LC_CTRL_REGS_BASE_ADDR and
 * `TOP_PEPPERMINT_LC_CTRL_REGS_BASE_ADDR + TOP_PEPPERMINT_LC_CTRL_REGS_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_LC_CTRL_REGS_SIZE_BYTES 0x100
/**
 * Peripheral base address for regs device on rv_dm in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_RV_DM_REGS_BASE_ADDR 0x21200000

/**
 * Peripheral size for regs device on rv_dm in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_RV_DM_REGS_BASE_ADDR and
 * `TOP_PEPPERMINT_RV_DM_REGS_BASE_ADDR + TOP_PEPPERMINT_RV_DM_REGS_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_RV_DM_REGS_SIZE_BYTES 0x10
/**
 * Peripheral base address for mem device on rv_dm in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_RV_DM_MEM_BASE_ADDR 0x50000

/**
 * Peripheral size for mem device on rv_dm in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_RV_DM_MEM_BASE_ADDR and
 * `TOP_PEPPERMINT_RV_DM_MEM_BASE_ADDR + TOP_PEPPERMINT_RV_DM_MEM_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_RV_DM_MEM_SIZE_BYTES 0x1000
/**
 * Peripheral base address for rv_plic in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_RV_PLIC_BASE_ADDR 0x28000000

/**
 * Peripheral size for rv_plic in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_RV_PLIC_BASE_ADDR and
 * `TOP_PEPPERMINT_RV_PLIC_BASE_ADDR + TOP_PEPPERMINT_RV_PLIC_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_RV_PLIC_SIZE_BYTES 0x8000000
/**
 * Peripheral base address for rv_timer in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_RV_TIMER_BASE_ADDR 0x21190000

/**
 * Peripheral size for rv_timer in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_RV_TIMER_BASE_ADDR and
 * `TOP_PEPPERMINT_RV_TIMER_BASE_ADDR + TOP_PEPPERMINT_RV_TIMER_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_RV_TIMER_SIZE_BYTES 0x200
/**
 * Peripheral base address for aes in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_AES_BASE_ADDR 0x21100000

/**
 * Peripheral size for aes in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_AES_BASE_ADDR and
 * `TOP_PEPPERMINT_AES_BASE_ADDR + TOP_PEPPERMINT_AES_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_AES_SIZE_BYTES 0x100
/**
 * Peripheral base address for hmac in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_HMAC_BASE_ADDR 0x21110000

/**
 * Peripheral size for hmac in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_HMAC_BASE_ADDR and
 * `TOP_PEPPERMINT_HMAC_BASE_ADDR + TOP_PEPPERMINT_HMAC_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_HMAC_SIZE_BYTES 0x2000
/**
 * Peripheral base address for kmac in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_KMAC_BASE_ADDR 0x21120000

/**
 * Peripheral size for kmac in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_KMAC_BASE_ADDR and
 * `TOP_PEPPERMINT_KMAC_BASE_ADDR + TOP_PEPPERMINT_KMAC_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_KMAC_SIZE_BYTES 0x1000
/**
 * Peripheral base address for otbn in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_OTBN_BASE_ADDR 0x21130000

/**
 * Peripheral size for otbn in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_OTBN_BASE_ADDR and
 * `TOP_PEPPERMINT_OTBN_BASE_ADDR + TOP_PEPPERMINT_OTBN_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_OTBN_SIZE_BYTES 0x10000
/**
 * Peripheral base address for keymgr_dpe in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_KEYMGR_DPE_BASE_ADDR 0x21140000

/**
 * Peripheral size for keymgr_dpe in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_KEYMGR_DPE_BASE_ADDR and
 * `TOP_PEPPERMINT_KEYMGR_DPE_BASE_ADDR + TOP_PEPPERMINT_KEYMGR_DPE_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_KEYMGR_DPE_SIZE_BYTES 0x100
/**
 * Peripheral base address for csrng in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_CSRNG_BASE_ADDR 0x21150000

/**
 * Peripheral size for csrng in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_CSRNG_BASE_ADDR and
 * `TOP_PEPPERMINT_CSRNG_BASE_ADDR + TOP_PEPPERMINT_CSRNG_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_CSRNG_SIZE_BYTES 0x80
/**
 * Peripheral base address for entropy_src in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_ENTROPY_SRC_BASE_ADDR 0x21160000

/**
 * Peripheral size for entropy_src in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_ENTROPY_SRC_BASE_ADDR and
 * `TOP_PEPPERMINT_ENTROPY_SRC_BASE_ADDR + TOP_PEPPERMINT_ENTROPY_SRC_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_ENTROPY_SRC_SIZE_BYTES 0x100
/**
 * Peripheral base address for edn0 in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_EDN0_BASE_ADDR 0x21170000

/**
 * Peripheral size for edn0 in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_EDN0_BASE_ADDR and
 * `TOP_PEPPERMINT_EDN0_BASE_ADDR + TOP_PEPPERMINT_EDN0_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_EDN0_SIZE_BYTES 0x80
/**
 * Peripheral base address for edn1 in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_EDN1_BASE_ADDR 0x21180000

/**
 * Peripheral size for edn1 in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_EDN1_BASE_ADDR and
 * `TOP_PEPPERMINT_EDN1_BASE_ADDR + TOP_PEPPERMINT_EDN1_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_EDN1_SIZE_BYTES 0x80
/**
 * Peripheral base address for regs device on sram_ctrl_main in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_SRAM_CTRL_MAIN_REGS_BASE_ADDR 0x211C0000

/**
 * Peripheral size for regs device on sram_ctrl_main in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_SRAM_CTRL_MAIN_REGS_BASE_ADDR and
 * `TOP_PEPPERMINT_SRAM_CTRL_MAIN_REGS_BASE_ADDR + TOP_PEPPERMINT_SRAM_CTRL_MAIN_REGS_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_SRAM_CTRL_MAIN_REGS_SIZE_BYTES 0x40
/**
 * Peripheral base address for regs device on rom_ctrl in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_ROM_CTRL_REGS_BASE_ADDR 0x211E0000

/**
 * Peripheral size for regs device on rom_ctrl in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_ROM_CTRL_REGS_BASE_ADDR and
 * `TOP_PEPPERMINT_ROM_CTRL_REGS_BASE_ADDR + TOP_PEPPERMINT_ROM_CTRL_REGS_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_ROM_CTRL_REGS_SIZE_BYTES 0x80
/**
 * Peripheral base address for dma in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_DMA_BASE_ADDR 0x22010000

/**
 * Peripheral size for dma in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_DMA_BASE_ADDR and
 * `TOP_PEPPERMINT_DMA_BASE_ADDR + TOP_PEPPERMINT_DMA_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_DMA_SIZE_BYTES 0x200
/**
 * Peripheral base address for core device on mbx0 in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_MBX0_CORE_BASE_ADDR 0x22000000

/**
 * Peripheral size for core device on mbx0 in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_MBX0_CORE_BASE_ADDR and
 * `TOP_PEPPERMINT_MBX0_CORE_BASE_ADDR + TOP_PEPPERMINT_MBX0_CORE_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_MBX0_CORE_SIZE_BYTES 0x80
/**
 * Peripheral base address for core device on mbx1 in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_MBX1_CORE_BASE_ADDR 0x22000100

/**
 * Peripheral size for core device on mbx1 in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_MBX1_CORE_BASE_ADDR and
 * `TOP_PEPPERMINT_MBX1_CORE_BASE_ADDR + TOP_PEPPERMINT_MBX1_CORE_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_MBX1_CORE_SIZE_BYTES 0x80
/**
 * Peripheral base address for cfg device on rv_core_ibex in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_RV_CORE_IBEX_CFG_BASE_ADDR 0x211F0000

/**
 * Peripheral size for cfg device on rv_core_ibex in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_RV_CORE_IBEX_CFG_BASE_ADDR and
 * `TOP_PEPPERMINT_RV_CORE_IBEX_CFG_BASE_ADDR + TOP_PEPPERMINT_RV_CORE_IBEX_CFG_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_RV_CORE_IBEX_CFG_SIZE_BYTES 0x800

/**
 * MMIO Region
 *
 * MMIO region excludes any memory that is separate from the module
 * configuration space, i.e. ROM, main SRAM and mailbox SoC window are excluded
 * but retention SRAM is included.
 */
#define TOP_PEPPERMINT_MMIO_BASE_ADDR 0x21100000
#define TOP_PEPPERMINT_MMIO_SIZE_BYTES 0x1F372000

#endif  // __ASSEMBLER__

#endif  // OPENTITAN_HW_TOP_PEPPERMINT_SW_AUTOGEN_TOP_PEPPERMINT_MEMORY_H_
