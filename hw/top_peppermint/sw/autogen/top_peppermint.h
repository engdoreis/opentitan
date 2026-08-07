// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------//
// PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
// util/topgen.py -t hw/top_peppermint/data/top_peppermint.hjson
//                -o hw/top_peppermint/

#ifndef OPENTITAN_HW_TOP_PEPPERMINT_SW_AUTOGEN_TOP_PEPPERMINT_H_
#define OPENTITAN_HW_TOP_PEPPERMINT_SW_AUTOGEN_TOP_PEPPERMINT_H_

/**
 * @file
 * @brief Top-specific Definitions
 *
 * This file contains preprocessor and type definitions for use within the
 * device C/C++ codebase.
 *
 * These definitions are for information that depends on the top-specific chip
 * configuration, which includes:
 * - Device Memory Information (for Peripherals and Memory)
 * - PLIC Interrupt ID Names and Source Mappings
 * - Alert ID Names and Source Mappings
 * - Power Manager Wakeups
 */

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Peripheral base address for pwrmgr in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_PWRMGR_BASE_ADDR 0x40400000u

/**
 * Peripheral size for pwrmgr in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_PWRMGR_BASE_ADDR and
 * `TOP_PEPPERMINT_PWRMGR_BASE_ADDR + TOP_PEPPERMINT_PWRMGR_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_PWRMGR_SIZE_BYTES 0x80u

/**
 * Peripheral base address for rstmgr in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_RSTMGR_BASE_ADDR 0x40410000u

/**
 * Peripheral size for rstmgr in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_RSTMGR_BASE_ADDR and
 * `TOP_PEPPERMINT_RSTMGR_BASE_ADDR + TOP_PEPPERMINT_RSTMGR_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_RSTMGR_SIZE_BYTES 0x40u

/**
 * Peripheral base address for clkmgr in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_CLKMGR_BASE_ADDR 0x40420000u

/**
 * Peripheral size for clkmgr in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_CLKMGR_BASE_ADDR and
 * `TOP_PEPPERMINT_CLKMGR_BASE_ADDR + TOP_PEPPERMINT_CLKMGR_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_CLKMGR_SIZE_BYTES 0x40u

/**
 * Peripheral base address for alert_handler in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_ALERT_HANDLER_BASE_ADDR 0x40450000u

/**
 * Peripheral size for alert_handler in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_ALERT_HANDLER_BASE_ADDR and
 * `TOP_PEPPERMINT_ALERT_HANDLER_BASE_ADDR + TOP_PEPPERMINT_ALERT_HANDLER_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_ALERT_HANDLER_SIZE_BYTES 0x800u

/**
 * Peripheral base address for rv_timer_aon in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_RV_TIMER_AON_BASE_ADDR 0x40430000u

/**
 * Peripheral size for rv_timer_aon in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_RV_TIMER_AON_BASE_ADDR and
 * `TOP_PEPPERMINT_RV_TIMER_AON_BASE_ADDR + TOP_PEPPERMINT_RV_TIMER_AON_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_RV_TIMER_AON_SIZE_BYTES 0x200u

/**
 * Peripheral base address for regs device on sram_ctrl_ret_aon in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_SRAM_CTRL_RET_AON_REGS_BASE_ADDR 0x40460000u

/**
 * Peripheral size for regs device on sram_ctrl_ret_aon in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_SRAM_CTRL_RET_AON_REGS_BASE_ADDR and
 * `TOP_PEPPERMINT_SRAM_CTRL_RET_AON_REGS_BASE_ADDR + TOP_PEPPERMINT_SRAM_CTRL_RET_AON_REGS_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_SRAM_CTRL_RET_AON_REGS_SIZE_BYTES 0x40u

/**
 * Peripheral base address for core device on otp_ctrl in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_OTP_CTRL_CORE_BASE_ADDR 0x30130000u

/**
 * Peripheral size for core device on otp_ctrl in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_OTP_CTRL_CORE_BASE_ADDR and
 * `TOP_PEPPERMINT_OTP_CTRL_CORE_BASE_ADDR + TOP_PEPPERMINT_OTP_CTRL_CORE_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_OTP_CTRL_CORE_SIZE_BYTES 0x4000u

/**
 * Peripheral base address for prim device on otp_macro in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_OTP_MACRO_PRIM_BASE_ADDR 0x30140000u

/**
 * Peripheral size for prim device on otp_macro in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_OTP_MACRO_PRIM_BASE_ADDR and
 * `TOP_PEPPERMINT_OTP_MACRO_PRIM_BASE_ADDR + TOP_PEPPERMINT_OTP_MACRO_PRIM_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_OTP_MACRO_PRIM_SIZE_BYTES 0x20u

/**
 * Peripheral base address for regs device on lc_ctrl in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_LC_CTRL_REGS_BASE_ADDR 0x30150000u

/**
 * Peripheral size for regs device on lc_ctrl in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_LC_CTRL_REGS_BASE_ADDR and
 * `TOP_PEPPERMINT_LC_CTRL_REGS_BASE_ADDR + TOP_PEPPERMINT_LC_CTRL_REGS_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_LC_CTRL_REGS_SIZE_BYTES 0x100u

/**
 * Peripheral base address for regs device on rv_dm in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_RV_DM_REGS_BASE_ADDR 0x21200000u

/**
 * Peripheral size for regs device on rv_dm in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_RV_DM_REGS_BASE_ADDR and
 * `TOP_PEPPERMINT_RV_DM_REGS_BASE_ADDR + TOP_PEPPERMINT_RV_DM_REGS_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_RV_DM_REGS_SIZE_BYTES 0x10u

/**
 * Peripheral base address for mem device on rv_dm in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_RV_DM_MEM_BASE_ADDR 0x50000u

/**
 * Peripheral size for mem device on rv_dm in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_RV_DM_MEM_BASE_ADDR and
 * `TOP_PEPPERMINT_RV_DM_MEM_BASE_ADDR + TOP_PEPPERMINT_RV_DM_MEM_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_RV_DM_MEM_SIZE_BYTES 0x1000u

/**
 * Peripheral base address for rv_plic in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_RV_PLIC_BASE_ADDR 0x28000000u

/**
 * Peripheral size for rv_plic in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_RV_PLIC_BASE_ADDR and
 * `TOP_PEPPERMINT_RV_PLIC_BASE_ADDR + TOP_PEPPERMINT_RV_PLIC_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_RV_PLIC_SIZE_BYTES 0x8000000u

/**
 * Peripheral base address for rv_timer in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_RV_TIMER_BASE_ADDR 0x21190000u

/**
 * Peripheral size for rv_timer in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_RV_TIMER_BASE_ADDR and
 * `TOP_PEPPERMINT_RV_TIMER_BASE_ADDR + TOP_PEPPERMINT_RV_TIMER_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_RV_TIMER_SIZE_BYTES 0x200u

/**
 * Peripheral base address for aes in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_AES_BASE_ADDR 0x21100000u

/**
 * Peripheral size for aes in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_AES_BASE_ADDR and
 * `TOP_PEPPERMINT_AES_BASE_ADDR + TOP_PEPPERMINT_AES_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_AES_SIZE_BYTES 0x100u

/**
 * Peripheral base address for hmac in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_HMAC_BASE_ADDR 0x21110000u

/**
 * Peripheral size for hmac in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_HMAC_BASE_ADDR and
 * `TOP_PEPPERMINT_HMAC_BASE_ADDR + TOP_PEPPERMINT_HMAC_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_HMAC_SIZE_BYTES 0x2000u

/**
 * Peripheral base address for kmac in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_KMAC_BASE_ADDR 0x21120000u

/**
 * Peripheral size for kmac in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_KMAC_BASE_ADDR and
 * `TOP_PEPPERMINT_KMAC_BASE_ADDR + TOP_PEPPERMINT_KMAC_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_KMAC_SIZE_BYTES 0x1000u

/**
 * Peripheral base address for otbn in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_OTBN_BASE_ADDR 0x21130000u

/**
 * Peripheral size for otbn in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_OTBN_BASE_ADDR and
 * `TOP_PEPPERMINT_OTBN_BASE_ADDR + TOP_PEPPERMINT_OTBN_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_OTBN_SIZE_BYTES 0x10000u

/**
 * Peripheral base address for keymgr_dpe in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_KEYMGR_DPE_BASE_ADDR 0x21140000u

/**
 * Peripheral size for keymgr_dpe in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_KEYMGR_DPE_BASE_ADDR and
 * `TOP_PEPPERMINT_KEYMGR_DPE_BASE_ADDR + TOP_PEPPERMINT_KEYMGR_DPE_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_KEYMGR_DPE_SIZE_BYTES 0x100u

/**
 * Peripheral base address for csrng in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_CSRNG_BASE_ADDR 0x21150000u

/**
 * Peripheral size for csrng in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_CSRNG_BASE_ADDR and
 * `TOP_PEPPERMINT_CSRNG_BASE_ADDR + TOP_PEPPERMINT_CSRNG_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_CSRNG_SIZE_BYTES 0x80u

/**
 * Peripheral base address for entropy_src in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_ENTROPY_SRC_BASE_ADDR 0x21160000u

/**
 * Peripheral size for entropy_src in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_ENTROPY_SRC_BASE_ADDR and
 * `TOP_PEPPERMINT_ENTROPY_SRC_BASE_ADDR + TOP_PEPPERMINT_ENTROPY_SRC_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_ENTROPY_SRC_SIZE_BYTES 0x100u

/**
 * Peripheral base address for edn0 in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_EDN0_BASE_ADDR 0x21170000u

/**
 * Peripheral size for edn0 in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_EDN0_BASE_ADDR and
 * `TOP_PEPPERMINT_EDN0_BASE_ADDR + TOP_PEPPERMINT_EDN0_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_EDN0_SIZE_BYTES 0x80u

/**
 * Peripheral base address for edn1 in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_EDN1_BASE_ADDR 0x21180000u

/**
 * Peripheral size for edn1 in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_EDN1_BASE_ADDR and
 * `TOP_PEPPERMINT_EDN1_BASE_ADDR + TOP_PEPPERMINT_EDN1_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_EDN1_SIZE_BYTES 0x80u

/**
 * Peripheral base address for regs device on sram_ctrl_main in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_SRAM_CTRL_MAIN_REGS_BASE_ADDR 0x211C0000u

/**
 * Peripheral size for regs device on sram_ctrl_main in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_SRAM_CTRL_MAIN_REGS_BASE_ADDR and
 * `TOP_PEPPERMINT_SRAM_CTRL_MAIN_REGS_BASE_ADDR + TOP_PEPPERMINT_SRAM_CTRL_MAIN_REGS_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_SRAM_CTRL_MAIN_REGS_SIZE_BYTES 0x40u

/**
 * Peripheral base address for regs device on rom_ctrl in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_ROM_CTRL_REGS_BASE_ADDR 0x211E0000u

/**
 * Peripheral size for regs device on rom_ctrl in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_ROM_CTRL_REGS_BASE_ADDR and
 * `TOP_PEPPERMINT_ROM_CTRL_REGS_BASE_ADDR + TOP_PEPPERMINT_ROM_CTRL_REGS_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_ROM_CTRL_REGS_SIZE_BYTES 0x80u

/**
 * Peripheral base address for dma in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_DMA_BASE_ADDR 0x22010000u

/**
 * Peripheral size for dma in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_DMA_BASE_ADDR and
 * `TOP_PEPPERMINT_DMA_BASE_ADDR + TOP_PEPPERMINT_DMA_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_DMA_SIZE_BYTES 0x200u

/**
 * Peripheral base address for core device on mbx0 in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_MBX0_CORE_BASE_ADDR 0x22000000u

/**
 * Peripheral size for core device on mbx0 in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_MBX0_CORE_BASE_ADDR and
 * `TOP_PEPPERMINT_MBX0_CORE_BASE_ADDR + TOP_PEPPERMINT_MBX0_CORE_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_MBX0_CORE_SIZE_BYTES 0x80u

/**
 * Peripheral base address for core device on mbx1 in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_MBX1_CORE_BASE_ADDR 0x22000100u

/**
 * Peripheral size for core device on mbx1 in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_MBX1_CORE_BASE_ADDR and
 * `TOP_PEPPERMINT_MBX1_CORE_BASE_ADDR + TOP_PEPPERMINT_MBX1_CORE_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_MBX1_CORE_SIZE_BYTES 0x80u

/**
 * Peripheral base address for cfg device on rv_core_ibex in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_RV_CORE_IBEX_CFG_BASE_ADDR 0x211F0000u

/**
 * Peripheral size for cfg device on rv_core_ibex in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_RV_CORE_IBEX_CFG_BASE_ADDR and
 * `TOP_PEPPERMINT_RV_CORE_IBEX_CFG_BASE_ADDR + TOP_PEPPERMINT_RV_CORE_IBEX_CFG_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_RV_CORE_IBEX_CFG_SIZE_BYTES 0x800u


/**
 * Memory base address for ram memory on sram_ctrl_ret_aon in top peppermint.
 */
#define TOP_PEPPERMINT_SRAM_CTRL_RET_AON_RAM_BASE_ADDR 0x40470000u

/**
 * Memory size for ram memory on sram_ctrl_ret_aon in top peppermint.
 */
#define TOP_PEPPERMINT_SRAM_CTRL_RET_AON_RAM_SIZE_BYTES 0x2000u

/**
 * Memory base address for ram memory on sram_ctrl_main in top peppermint.
 */
#define TOP_PEPPERMINT_SRAM_CTRL_MAIN_RAM_BASE_ADDR 0x10000000u

/**
 * Memory size for ram memory on sram_ctrl_main in top peppermint.
 */
#define TOP_PEPPERMINT_SRAM_CTRL_MAIN_RAM_SIZE_BYTES 0x30000u

/**
 * Memory base address for rom memory on rom_ctrl in top peppermint.
 */
#define TOP_PEPPERMINT_ROM_CTRL_ROM_BASE_ADDR 0x20000u

/**
 * Memory size for rom memory on rom_ctrl in top peppermint.
 */
#define TOP_PEPPERMINT_ROM_CTRL_ROM_SIZE_BYTES 0x30000u

/**
 * Memory base address for ctn memory on ahb_bridge in top peppermint.
 */
#define TOP_PEPPERMINT_AHB_BRIDGE_CTN_BASE_ADDR 0x80000000u

/**
 * Memory size for ctn memory on ahb_bridge in top peppermint.
 */
#define TOP_PEPPERMINT_AHB_BRIDGE_CTN_SIZE_BYTES 0x10000000u


/**
 * PLIC Interrupt Source Peripheral.
 *
 * Enumeration used to determine which peripheral asserted the corresponding
 * interrupt.
 */
typedef enum top_peppermint_plic_peripheral {
  kTopPeppermintPlicPeripheralUnknown = 0, /**< Unknown Peripheral */
  kTopPeppermintPlicPeripheralPwrmgr = 1, /**< pwrmgr */
  kTopPeppermintPlicPeripheralAlertHandler = 2, /**< alert_handler */
  kTopPeppermintPlicPeripheralRvTimerAon = 3, /**< rv_timer_aon */
  kTopPeppermintPlicPeripheralOtpCtrl = 4, /**< otp_ctrl */
  kTopPeppermintPlicPeripheralRvTimer = 5, /**< rv_timer */
  kTopPeppermintPlicPeripheralHmac = 6, /**< hmac */
  kTopPeppermintPlicPeripheralKmac = 7, /**< kmac */
  kTopPeppermintPlicPeripheralOtbn = 8, /**< otbn */
  kTopPeppermintPlicPeripheralKeymgrDpe = 9, /**< keymgr_dpe */
  kTopPeppermintPlicPeripheralCsrng = 10, /**< csrng */
  kTopPeppermintPlicPeripheralEntropySrc = 11, /**< entropy_src */
  kTopPeppermintPlicPeripheralEdn0 = 12, /**< edn0 */
  kTopPeppermintPlicPeripheralEdn1 = 13, /**< edn1 */
  kTopPeppermintPlicPeripheralDma = 14, /**< dma */
  kTopPeppermintPlicPeripheralMbx0 = 15, /**< mbx0 */
  kTopPeppermintPlicPeripheralMbx1 = 16, /**< mbx1 */
  kTopPeppermintPlicPeripheralLast = 16, /**< \internal Final PLIC peripheral */
} top_peppermint_plic_peripheral_t;

/**
 * PLIC Interrupt Source.
 *
 * Enumeration of all PLIC interrupt sources. The interrupt sources belonging to
 * the same peripheral are guaranteed to be consecutive.
 */
typedef enum top_peppermint_plic_irq_id {
  kTopPeppermintPlicIrqIdNone = 0, /**< No Interrupt */
  kTopPeppermintPlicIrqIdPwrmgrWakeup = 1, /**< pwrmgr_wakeup */
  kTopPeppermintPlicIrqIdAlertHandlerClassa = 2, /**< alert_handler_classa */
  kTopPeppermintPlicIrqIdAlertHandlerClassb = 3, /**< alert_handler_classb */
  kTopPeppermintPlicIrqIdAlertHandlerClassc = 4, /**< alert_handler_classc */
  kTopPeppermintPlicIrqIdAlertHandlerClassd = 5, /**< alert_handler_classd */
  kTopPeppermintPlicIrqIdRvTimerAonTimerExpiredHart0Timer0 = 6, /**< rv_timer_aon_timer_expired_hart0_timer0 */
  kTopPeppermintPlicIrqIdOtpCtrlOtpOperationDone = 7, /**< otp_ctrl_otp_operation_done */
  kTopPeppermintPlicIrqIdOtpCtrlOtpError = 8, /**< otp_ctrl_otp_error */
  kTopPeppermintPlicIrqIdRvTimerTimerExpiredHart0Timer0 = 9, /**< rv_timer_timer_expired_hart0_timer0 */
  kTopPeppermintPlicIrqIdHmacHmacDone = 10, /**< hmac_hmac_done */
  kTopPeppermintPlicIrqIdHmacFifoEmpty = 11, /**< hmac_fifo_empty */
  kTopPeppermintPlicIrqIdHmacHmacErr = 12, /**< hmac_hmac_err */
  kTopPeppermintPlicIrqIdKmacKmacDone = 13, /**< kmac_kmac_done */
  kTopPeppermintPlicIrqIdKmacFifoEmpty = 14, /**< kmac_fifo_empty */
  kTopPeppermintPlicIrqIdKmacKmacErr = 15, /**< kmac_kmac_err */
  kTopPeppermintPlicIrqIdOtbnDone = 16, /**< otbn_done */
  kTopPeppermintPlicIrqIdKeymgrDpeOpDone = 17, /**< keymgr_dpe_op_done */
  kTopPeppermintPlicIrqIdCsrngCsCmdReqDone = 18, /**< csrng_cs_cmd_req_done */
  kTopPeppermintPlicIrqIdCsrngCsEntropyReq = 19, /**< csrng_cs_entropy_req */
  kTopPeppermintPlicIrqIdCsrngCsHwInstExc = 20, /**< csrng_cs_hw_inst_exc */
  kTopPeppermintPlicIrqIdCsrngCsFatalErr = 21, /**< csrng_cs_fatal_err */
  kTopPeppermintPlicIrqIdEntropySrcEsEntropyValid = 22, /**< entropy_src_es_entropy_valid */
  kTopPeppermintPlicIrqIdEntropySrcEsHealthTestFailed = 23, /**< entropy_src_es_health_test_failed */
  kTopPeppermintPlicIrqIdEntropySrcEsObserveFifoReady = 24, /**< entropy_src_es_observe_fifo_ready */
  kTopPeppermintPlicIrqIdEntropySrcEsFatalErr = 25, /**< entropy_src_es_fatal_err */
  kTopPeppermintPlicIrqIdEdn0EdnCmdReqDone = 26, /**< edn0_edn_cmd_req_done */
  kTopPeppermintPlicIrqIdEdn0EdnFatalErr = 27, /**< edn0_edn_fatal_err */
  kTopPeppermintPlicIrqIdEdn1EdnCmdReqDone = 28, /**< edn1_edn_cmd_req_done */
  kTopPeppermintPlicIrqIdEdn1EdnFatalErr = 29, /**< edn1_edn_fatal_err */
  kTopPeppermintPlicIrqIdDmaDmaDone = 30, /**< dma_dma_done */
  kTopPeppermintPlicIrqIdDmaDmaChunkDone = 31, /**< dma_dma_chunk_done */
  kTopPeppermintPlicIrqIdDmaDmaError = 32, /**< dma_dma_error */
  kTopPeppermintPlicIrqIdMbx0MbxReady = 33, /**< mbx0_mbx_ready */
  kTopPeppermintPlicIrqIdMbx0MbxAbort = 34, /**< mbx0_mbx_abort */
  kTopPeppermintPlicIrqIdMbx0MbxError = 35, /**< mbx0_mbx_error */
  kTopPeppermintPlicIrqIdMbx1MbxReady = 36, /**< mbx1_mbx_ready */
  kTopPeppermintPlicIrqIdMbx1MbxAbort = 37, /**< mbx1_mbx_abort */
  kTopPeppermintPlicIrqIdMbx1MbxError = 38, /**< mbx1_mbx_error */
  kTopPeppermintPlicIrqIdSocIrq0 = 39, /**< soc_irq_0 */
  kTopPeppermintPlicIrqIdSocIrq1 = 40, /**< soc_irq_1 */
  kTopPeppermintPlicIrqIdSocIrq2 = 41, /**< soc_irq_2 */
  kTopPeppermintPlicIrqIdSocIrq3 = 42, /**< soc_irq_3 */
  kTopPeppermintPlicIrqIdLast = 42, /**< \internal The Last Valid Interrupt ID. */
} top_peppermint_plic_irq_id_t;

/**
 * PLIC Interrupt Source to Peripheral Map
 *
 * This array is a mapping from `top_peppermint_plic_irq_id_t` to
 * `top_peppermint_plic_peripheral_t`.
 */
extern const top_peppermint_plic_peripheral_t
    top_peppermint_plic_interrupt_for_peripheral[43];

/**
 * PLIC Interrupt Target.
 *
 * Enumeration used to determine which set of IE, CC, threshold registers to
 * access for a given interrupt target.
 */
typedef enum top_peppermint_plic_target {
  kTopPeppermintPlicTargetIbex0 = 0, /**< Ibex Core 0 */
  kTopPeppermintPlicTargetLast = 0, /**< \internal Final PLIC target */
} top_peppermint_plic_target_t;


/**
 * Alert Handler Source Peripheral.
 *
 * Enumeration used to determine which peripheral asserted the corresponding
 * alert.
 */
typedef enum top_peppermint_alert_peripheral {
  kTopPeppermintAlertPeripheralExternal = 0, /**< External Peripheral */
  kTopPeppermintAlertPeripheralPwrmgr = 1, /**< pwrmgr */
  kTopPeppermintAlertPeripheralRstmgr = 2, /**< rstmgr */
  kTopPeppermintAlertPeripheralClkmgr = 3, /**< clkmgr */
  kTopPeppermintAlertPeripheralRvTimerAon = 4, /**< rv_timer_aon */
  kTopPeppermintAlertPeripheralSramCtrlRetAon = 5, /**< sram_ctrl_ret_aon */
  kTopPeppermintAlertPeripheralOtpCtrl = 6, /**< otp_ctrl */
  kTopPeppermintAlertPeripheralLcCtrl = 7, /**< lc_ctrl */
  kTopPeppermintAlertPeripheralRvDm = 8, /**< rv_dm */
  kTopPeppermintAlertPeripheralRvPlic = 9, /**< rv_plic */
  kTopPeppermintAlertPeripheralRvTimer = 10, /**< rv_timer */
  kTopPeppermintAlertPeripheralAes = 11, /**< aes */
  kTopPeppermintAlertPeripheralHmac = 12, /**< hmac */
  kTopPeppermintAlertPeripheralKmac = 13, /**< kmac */
  kTopPeppermintAlertPeripheralOtbn = 14, /**< otbn */
  kTopPeppermintAlertPeripheralKeymgrDpe = 15, /**< keymgr_dpe */
  kTopPeppermintAlertPeripheralCsrng = 16, /**< csrng */
  kTopPeppermintAlertPeripheralEntropySrc = 17, /**< entropy_src */
  kTopPeppermintAlertPeripheralEdn0 = 18, /**< edn0 */
  kTopPeppermintAlertPeripheralEdn1 = 19, /**< edn1 */
  kTopPeppermintAlertPeripheralSramCtrlMain = 20, /**< sram_ctrl_main */
  kTopPeppermintAlertPeripheralRomCtrl = 21, /**< rom_ctrl */
  kTopPeppermintAlertPeripheralDma = 22, /**< dma */
  kTopPeppermintAlertPeripheralMbx0 = 23, /**< mbx0 */
  kTopPeppermintAlertPeripheralMbx1 = 24, /**< mbx1 */
  kTopPeppermintAlertPeripheralRvCoreIbex = 25, /**< rv_core_ibex */
  kTopPeppermintAlertPeripheralLast = 25, /**< \internal Final Alert peripheral */
} top_peppermint_alert_peripheral_t;

/**
 * Alert Handler Alert Source.
 *
 * Enumeration of all Alert Handler Alert Sources. The alert sources belonging to
 * the same peripheral are guaranteed to be consecutive.
 */
typedef enum top_peppermint_alert_id {
  kTopPeppermintAlertIdPwrmgrFatalFault = 0, /**< pwrmgr_fatal_fault */
  kTopPeppermintAlertIdRstmgrFatalFault = 1, /**< rstmgr_fatal_fault */
  kTopPeppermintAlertIdRstmgrFatalCnstyFault = 2, /**< rstmgr_fatal_cnsty_fault */
  kTopPeppermintAlertIdClkmgrRecovFault = 3, /**< clkmgr_recov_fault */
  kTopPeppermintAlertIdClkmgrFatalFault = 4, /**< clkmgr_fatal_fault */
  kTopPeppermintAlertIdRvTimerAonFatalFault = 5, /**< rv_timer_aon_fatal_fault */
  kTopPeppermintAlertIdSramCtrlRetAonFatalError = 6, /**< sram_ctrl_ret_aon_fatal_error */
  kTopPeppermintAlertIdOtpCtrlFatalMacroError = 7, /**< otp_ctrl_fatal_macro_error */
  kTopPeppermintAlertIdOtpCtrlFatalCheckError = 8, /**< otp_ctrl_fatal_check_error */
  kTopPeppermintAlertIdOtpCtrlFatalBusIntegError = 9, /**< otp_ctrl_fatal_bus_integ_error */
  kTopPeppermintAlertIdOtpCtrlFatalPrimOtpAlert = 10, /**< otp_ctrl_fatal_prim_otp_alert */
  kTopPeppermintAlertIdOtpCtrlRecovPrimOtpAlert = 11, /**< otp_ctrl_recov_prim_otp_alert */
  kTopPeppermintAlertIdLcCtrlFatalProgError = 12, /**< lc_ctrl_fatal_prog_error */
  kTopPeppermintAlertIdLcCtrlFatalStateError = 13, /**< lc_ctrl_fatal_state_error */
  kTopPeppermintAlertIdLcCtrlFatalBusIntegError = 14, /**< lc_ctrl_fatal_bus_integ_error */
  kTopPeppermintAlertIdRvDmFatalFault = 15, /**< rv_dm_fatal_fault */
  kTopPeppermintAlertIdRvPlicFatalFault = 16, /**< rv_plic_fatal_fault */
  kTopPeppermintAlertIdRvTimerFatalFault = 17, /**< rv_timer_fatal_fault */
  kTopPeppermintAlertIdAesRecovCtrlUpdateErr = 18, /**< aes_recov_ctrl_update_err */
  kTopPeppermintAlertIdAesFatalFault = 19, /**< aes_fatal_fault */
  kTopPeppermintAlertIdHmacFatalFault = 20, /**< hmac_fatal_fault */
  kTopPeppermintAlertIdKmacRecovOperationErr = 21, /**< kmac_recov_operation_err */
  kTopPeppermintAlertIdKmacFatalFaultErr = 22, /**< kmac_fatal_fault_err */
  kTopPeppermintAlertIdOtbnFatal = 23, /**< otbn_fatal */
  kTopPeppermintAlertIdOtbnRecov = 24, /**< otbn_recov */
  kTopPeppermintAlertIdKeymgrDpeRecovOperationErr = 25, /**< keymgr_dpe_recov_operation_err */
  kTopPeppermintAlertIdKeymgrDpeFatalFaultErr = 26, /**< keymgr_dpe_fatal_fault_err */
  kTopPeppermintAlertIdCsrngRecovAlert = 27, /**< csrng_recov_alert */
  kTopPeppermintAlertIdCsrngFatalAlert = 28, /**< csrng_fatal_alert */
  kTopPeppermintAlertIdEntropySrcRecovAlert = 29, /**< entropy_src_recov_alert */
  kTopPeppermintAlertIdEntropySrcFatalAlert = 30, /**< entropy_src_fatal_alert */
  kTopPeppermintAlertIdEdn0RecovAlert = 31, /**< edn0_recov_alert */
  kTopPeppermintAlertIdEdn0FatalAlert = 32, /**< edn0_fatal_alert */
  kTopPeppermintAlertIdEdn1RecovAlert = 33, /**< edn1_recov_alert */
  kTopPeppermintAlertIdEdn1FatalAlert = 34, /**< edn1_fatal_alert */
  kTopPeppermintAlertIdSramCtrlMainFatalError = 35, /**< sram_ctrl_main_fatal_error */
  kTopPeppermintAlertIdRomCtrlFatal = 36, /**< rom_ctrl_fatal */
  kTopPeppermintAlertIdDmaFatalFault = 37, /**< dma_fatal_fault */
  kTopPeppermintAlertIdMbx0FatalFault = 38, /**< mbx0_fatal_fault */
  kTopPeppermintAlertIdMbx0RecovFault = 39, /**< mbx0_recov_fault */
  kTopPeppermintAlertIdMbx1FatalFault = 40, /**< mbx1_fatal_fault */
  kTopPeppermintAlertIdMbx1RecovFault = 41, /**< mbx1_recov_fault */
  kTopPeppermintAlertIdRvCoreIbexFatalSwErr = 42, /**< rv_core_ibex_fatal_sw_err */
  kTopPeppermintAlertIdRvCoreIbexRecovSwErr = 43, /**< rv_core_ibex_recov_sw_err */
  kTopPeppermintAlertIdRvCoreIbexFatalHwErr = 44, /**< rv_core_ibex_fatal_hw_err */
  kTopPeppermintAlertIdRvCoreIbexRecovHwErr = 45, /**< rv_core_ibex_recov_hw_err */
  kTopPeppermintAlertIdIncomingSocSocFatalAlert0 = 46, /**< incoming_soc_soc_fatal_alert_0 */
  kTopPeppermintAlertIdIncomingSocSocFatalAlert1 = 47, /**< incoming_soc_soc_fatal_alert_1 */
  kTopPeppermintAlertIdIncomingSocSocFatalAlert2 = 48, /**< incoming_soc_soc_fatal_alert_2 */
  kTopPeppermintAlertIdIncomingSocSocFatalAlert3 = 49, /**< incoming_soc_soc_fatal_alert_3 */
  kTopPeppermintAlertIdLast = 49, /**< \internal The Last Valid Alert ID. */
} top_peppermint_alert_id_t;

/**
 * Alert Handler Alert Source to Peripheral Map
 *
 * This array is a mapping from `top_peppermint_alert_id_t` to
 * `top_peppermint_alert_peripheral_t`.
 */
extern const top_peppermint_alert_peripheral_t
    top_peppermint_alert_for_peripheral[50];

/**
 * Power Manager Wakeup Signals
 */
typedef enum top_peppermint_power_manager_wake_ups {
  kTopPeppermintPowerManagerWakeUpsSocWkupReq = 0, /**<  */
  kTopPeppermintPowerManagerWakeUpsLast = 0, /**< \internal Last valid pwrmgr wakeup signal */
} top_peppermint_power_manager_wake_ups_t;

/**
 * Reset Manager Software Controlled Resets
 */
typedef enum top_peppermint_reset_manager_sw_resets {
  kTopPeppermintResetManagerSwResetsSocCpu = 0, /**<  */
  kTopPeppermintResetManagerSwResetsLast = 0, /**< \internal Last valid rstmgr software reset request */
} top_peppermint_reset_manager_sw_resets_t;

/**
 * Power Manager Reset Request Signals
 */
typedef enum top_peppermint_power_manager_reset_requests {
  kTopPeppermintPowerManagerResetRequestsSocRstReq = 0, /**<  */
  kTopPeppermintPowerManagerResetRequestsLast = 0, /**< \internal Last valid pwrmgr reset_request signal */
} top_peppermint_power_manager_reset_requests_t;

/**
 * Clock Manager Software-Controlled ("Gated") Clocks.
 *
 * The Software has full control over these clocks.
 */
typedef enum top_peppermint_gateable_clocks {
  kTopPeppermintGateableClocksLast = -1, /**< \internal Last Valid Gateable Clock */
} top_peppermint_gateable_clocks_t;

/**
 * Clock Manager Software-Hinted Clocks.
 *
 * The Software has partial control over these clocks. It can ask them to stop,
 * but the clock manager is in control of whether the clock actually is stopped.
 */
typedef enum top_peppermint_hintable_clocks {
  kTopPeppermintHintableClocksLast = -1, /**< \internal Last Valid Hintable Clock */
} top_peppermint_hintable_clocks_t;

/**
 * MMIO Region
 *
 * MMIO region excludes any memory that is separate from the module
 * configuration space, i.e. ROM, main SRAM and mailbox SoC window are excluded
 * but retention SRAM is included.
 */
#define TOP_PEPPERMINT_MMIO_BASE_ADDR 0x21100000u
#define TOP_PEPPERMINT_MMIO_SIZE_BYTES 0x1F372000u

// Header Extern Guard
#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // OPENTITAN_HW_TOP_PEPPERMINT_SW_AUTOGEN_TOP_PEPPERMINT_H_
