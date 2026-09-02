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
 * Peripheral base address for rv_timer in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_RV_TIMER_BASE_ADDR 0x40000000u

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
 * Peripheral base address for core device on otp_ctrl in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_OTP_CTRL_CORE_BASE_ADDR 0x40010000u

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
#define TOP_PEPPERMINT_OTP_MACRO_PRIM_BASE_ADDR 0x40020000u

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
#define TOP_PEPPERMINT_LC_CTRL_REGS_BASE_ADDR 0x40030000u

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
 * Peripheral base address for aes in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_AES_BASE_ADDR 0x40100000u

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
#define TOP_PEPPERMINT_HMAC_BASE_ADDR 0x40110000u

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
#define TOP_PEPPERMINT_KMAC_BASE_ADDR 0x40120000u

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
#define TOP_PEPPERMINT_OTBN_BASE_ADDR 0x40130000u

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
#define TOP_PEPPERMINT_KEYMGR_DPE_BASE_ADDR 0x40140000u

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
#define TOP_PEPPERMINT_CSRNG_BASE_ADDR 0x40150000u

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
#define TOP_PEPPERMINT_ENTROPY_SRC_BASE_ADDR 0x40160000u

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
#define TOP_PEPPERMINT_EDN0_BASE_ADDR 0x40170000u

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
#define TOP_PEPPERMINT_EDN1_BASE_ADDR 0x40180000u

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
#define TOP_PEPPERMINT_SRAM_CTRL_MAIN_REGS_BASE_ADDR 0x40200000u

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
#define TOP_PEPPERMINT_ROM_CTRL_REGS_BASE_ADDR 0x40210000u

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
 * Peripheral base address for cfg device on rv_core_ibex in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_RV_CORE_IBEX_CFG_BASE_ADDR 0x40220000u

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
 * Peripheral base address for regs device on rv_dm in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_RV_DM_REGS_BASE_ADDR 0x40230000u

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
#define TOP_PEPPERMINT_RV_DM_MEM_BASE_ADDR 0x10000u

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
 * Peripheral base address for dma in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_DMA_BASE_ADDR 0x40300000u

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
#define TOP_PEPPERMINT_MBX0_CORE_BASE_ADDR 0x40310000u

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
#define TOP_PEPPERMINT_MBX1_CORE_BASE_ADDR 0x40320000u

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
 * Peripheral base address for pwrmgr in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_PWRMGR_BASE_ADDR 0x41000000u

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
#define TOP_PEPPERMINT_RSTMGR_BASE_ADDR 0x41010000u

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
#define TOP_PEPPERMINT_CLKMGR_BASE_ADDR 0x41020000u

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
#define TOP_PEPPERMINT_ALERT_HANDLER_BASE_ADDR 0x41040000u

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
 * Peripheral base address for regs device on sram_ctrl_ret in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_SRAM_CTRL_RET_REGS_BASE_ADDR 0x41050000u

/**
 * Peripheral size for regs device on sram_ctrl_ret in top peppermint.
 *
 * This is the size (in bytes) of the peripheral's reserved memory area. All
 * memory-mapped registers associated with this peripheral should have an
 * address between #TOP_PEPPERMINT_SRAM_CTRL_RET_REGS_BASE_ADDR and
 * `TOP_PEPPERMINT_SRAM_CTRL_RET_REGS_BASE_ADDR + TOP_PEPPERMINT_SRAM_CTRL_RET_REGS_SIZE_BYTES`.
 */
#define TOP_PEPPERMINT_SRAM_CTRL_RET_REGS_SIZE_BYTES 0x40u

/**
 * Peripheral base address for rv_plic in top peppermint.
 *
 * This should be used with #mmio_region_from_addr to access the memory-mapped
 * registers associated with the peripheral (usually via a DIF).
 */
#define TOP_PEPPERMINT_RV_PLIC_BASE_ADDR 0x48000000u

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
#define TOP_PEPPERMINT_ROM_CTRL_ROM_BASE_ADDR 0x40000u

/**
 * Memory size for rom memory on rom_ctrl in top peppermint.
 */
#define TOP_PEPPERMINT_ROM_CTRL_ROM_SIZE_BYTES 0x20000u

/**
 * Memory base address for ram memory on sram_ctrl_ret in top peppermint.
 */
#define TOP_PEPPERMINT_SRAM_CTRL_RET_RAM_BASE_ADDR 0x41100000u

/**
 * Memory size for ram memory on sram_ctrl_ret in top peppermint.
 */
#define TOP_PEPPERMINT_SRAM_CTRL_RET_RAM_SIZE_BYTES 0x2000u

/**
 * Memory base address for ctn memory on ahb_bridge in top peppermint.
 */
#define TOP_PEPPERMINT_AHB_BRIDGE_CTN_BASE_ADDR 0x80000000u

/**
 * Memory size for ctn memory on ahb_bridge in top peppermint.
 */
#define TOP_PEPPERMINT_AHB_BRIDGE_CTN_SIZE_BYTES 0x80000000u


/**
 * PLIC Interrupt Source Peripheral.
 *
 * Enumeration used to determine which peripheral asserted the corresponding
 * interrupt.
 */
typedef enum top_peppermint_plic_peripheral {
  kTopPeppermintPlicPeripheralUnknown = 0, /**< Unknown Peripheral */
  kTopPeppermintPlicPeripheralRvTimer = 1, /**< rv_timer */
  kTopPeppermintPlicPeripheralOtpCtrl = 2, /**< otp_ctrl */
  kTopPeppermintPlicPeripheralHmac = 3, /**< hmac */
  kTopPeppermintPlicPeripheralKmac = 4, /**< kmac */
  kTopPeppermintPlicPeripheralOtbn = 5, /**< otbn */
  kTopPeppermintPlicPeripheralKeymgrDpe = 6, /**< keymgr_dpe */
  kTopPeppermintPlicPeripheralCsrng = 7, /**< csrng */
  kTopPeppermintPlicPeripheralEntropySrc = 8, /**< entropy_src */
  kTopPeppermintPlicPeripheralEdn0 = 9, /**< edn0 */
  kTopPeppermintPlicPeripheralEdn1 = 10, /**< edn1 */
  kTopPeppermintPlicPeripheralDma = 11, /**< dma */
  kTopPeppermintPlicPeripheralMbx0 = 12, /**< mbx0 */
  kTopPeppermintPlicPeripheralMbx1 = 13, /**< mbx1 */
  kTopPeppermintPlicPeripheralPwrmgr = 14, /**< pwrmgr */
  kTopPeppermintPlicPeripheralAlertHandler = 15, /**< alert_handler */
  kTopPeppermintPlicPeripheralLast = 15, /**< \internal Final PLIC peripheral */
} top_peppermint_plic_peripheral_t;

/**
 * PLIC Interrupt Source.
 *
 * Enumeration of all PLIC interrupt sources. The interrupt sources belonging to
 * the same peripheral are guaranteed to be consecutive.
 */
typedef enum top_peppermint_plic_irq_id {
  kTopPeppermintPlicIrqIdNone = 0, /**< No Interrupt */
  kTopPeppermintPlicIrqIdRvTimerTimerExpiredHart0Timer0 = 1, /**< rv_timer_timer_expired_hart0_timer0 */
  kTopPeppermintPlicIrqIdOtpCtrlOtpOperationDone = 2, /**< otp_ctrl_otp_operation_done */
  kTopPeppermintPlicIrqIdOtpCtrlOtpError = 3, /**< otp_ctrl_otp_error */
  kTopPeppermintPlicIrqIdHmacHmacDone = 4, /**< hmac_hmac_done */
  kTopPeppermintPlicIrqIdHmacFifoEmpty = 5, /**< hmac_fifo_empty */
  kTopPeppermintPlicIrqIdHmacHmacErr = 6, /**< hmac_hmac_err */
  kTopPeppermintPlicIrqIdKmacKmacDone = 7, /**< kmac_kmac_done */
  kTopPeppermintPlicIrqIdKmacFifoEmpty = 8, /**< kmac_fifo_empty */
  kTopPeppermintPlicIrqIdKmacKmacErr = 9, /**< kmac_kmac_err */
  kTopPeppermintPlicIrqIdOtbnDone = 10, /**< otbn_done */
  kTopPeppermintPlicIrqIdKeymgrDpeOpDone = 11, /**< keymgr_dpe_op_done */
  kTopPeppermintPlicIrqIdCsrngCsCmdReqDone = 12, /**< csrng_cs_cmd_req_done */
  kTopPeppermintPlicIrqIdCsrngCsEntropyReq = 13, /**< csrng_cs_entropy_req */
  kTopPeppermintPlicIrqIdCsrngCsHwInstExc = 14, /**< csrng_cs_hw_inst_exc */
  kTopPeppermintPlicIrqIdCsrngCsFatalErr = 15, /**< csrng_cs_fatal_err */
  kTopPeppermintPlicIrqIdEntropySrcEsEntropyValid = 16, /**< entropy_src_es_entropy_valid */
  kTopPeppermintPlicIrqIdEntropySrcEsHealthTestFailed = 17, /**< entropy_src_es_health_test_failed */
  kTopPeppermintPlicIrqIdEntropySrcEsObserveFifoReady = 18, /**< entropy_src_es_observe_fifo_ready */
  kTopPeppermintPlicIrqIdEntropySrcEsFatalErr = 19, /**< entropy_src_es_fatal_err */
  kTopPeppermintPlicIrqIdEdn0EdnCmdReqDone = 20, /**< edn0_edn_cmd_req_done */
  kTopPeppermintPlicIrqIdEdn0EdnFatalErr = 21, /**< edn0_edn_fatal_err */
  kTopPeppermintPlicIrqIdEdn1EdnCmdReqDone = 22, /**< edn1_edn_cmd_req_done */
  kTopPeppermintPlicIrqIdEdn1EdnFatalErr = 23, /**< edn1_edn_fatal_err */
  kTopPeppermintPlicIrqIdDmaDmaDone = 24, /**< dma_dma_done */
  kTopPeppermintPlicIrqIdDmaDmaChunkDone = 25, /**< dma_dma_chunk_done */
  kTopPeppermintPlicIrqIdDmaDmaError = 26, /**< dma_dma_error */
  kTopPeppermintPlicIrqIdMbx0MbxReady = 27, /**< mbx0_mbx_ready */
  kTopPeppermintPlicIrqIdMbx0MbxAbort = 28, /**< mbx0_mbx_abort */
  kTopPeppermintPlicIrqIdMbx0MbxError = 29, /**< mbx0_mbx_error */
  kTopPeppermintPlicIrqIdMbx1MbxReady = 30, /**< mbx1_mbx_ready */
  kTopPeppermintPlicIrqIdMbx1MbxAbort = 31, /**< mbx1_mbx_abort */
  kTopPeppermintPlicIrqIdMbx1MbxError = 32, /**< mbx1_mbx_error */
  kTopPeppermintPlicIrqIdPwrmgrWakeup = 33, /**< pwrmgr_wakeup */
  kTopPeppermintPlicIrqIdAlertHandlerClassa = 34, /**< alert_handler_classa */
  kTopPeppermintPlicIrqIdAlertHandlerClassb = 35, /**< alert_handler_classb */
  kTopPeppermintPlicIrqIdAlertHandlerClassc = 36, /**< alert_handler_classc */
  kTopPeppermintPlicIrqIdAlertHandlerClassd = 37, /**< alert_handler_classd */
  kTopPeppermintPlicIrqIdSocIrq0 = 38, /**< soc_irq_0 */
  kTopPeppermintPlicIrqIdSocIrq1 = 39, /**< soc_irq_1 */
  kTopPeppermintPlicIrqIdSocIrq2 = 40, /**< soc_irq_2 */
  kTopPeppermintPlicIrqIdSocIrq3 = 41, /**< soc_irq_3 */
  kTopPeppermintPlicIrqIdLast = 41, /**< \internal The Last Valid Interrupt ID. */
} top_peppermint_plic_irq_id_t;

/**
 * PLIC Interrupt Source to Peripheral Map
 *
 * This array is a mapping from `top_peppermint_plic_irq_id_t` to
 * `top_peppermint_plic_peripheral_t`.
 */
extern const top_peppermint_plic_peripheral_t
    top_peppermint_plic_interrupt_for_peripheral[42];

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
  kTopPeppermintAlertPeripheralRvTimer = 1, /**< rv_timer */
  kTopPeppermintAlertPeripheralOtpCtrl = 2, /**< otp_ctrl */
  kTopPeppermintAlertPeripheralLcCtrl = 3, /**< lc_ctrl */
  kTopPeppermintAlertPeripheralAes = 4, /**< aes */
  kTopPeppermintAlertPeripheralHmac = 5, /**< hmac */
  kTopPeppermintAlertPeripheralKmac = 6, /**< kmac */
  kTopPeppermintAlertPeripheralOtbn = 7, /**< otbn */
  kTopPeppermintAlertPeripheralKeymgrDpe = 8, /**< keymgr_dpe */
  kTopPeppermintAlertPeripheralCsrng = 9, /**< csrng */
  kTopPeppermintAlertPeripheralEntropySrc = 10, /**< entropy_src */
  kTopPeppermintAlertPeripheralEdn0 = 11, /**< edn0 */
  kTopPeppermintAlertPeripheralEdn1 = 12, /**< edn1 */
  kTopPeppermintAlertPeripheralSramCtrlMain = 13, /**< sram_ctrl_main */
  kTopPeppermintAlertPeripheralRomCtrl = 14, /**< rom_ctrl */
  kTopPeppermintAlertPeripheralRvCoreIbex = 15, /**< rv_core_ibex */
  kTopPeppermintAlertPeripheralRvDm = 16, /**< rv_dm */
  kTopPeppermintAlertPeripheralDma = 17, /**< dma */
  kTopPeppermintAlertPeripheralMbx0 = 18, /**< mbx0 */
  kTopPeppermintAlertPeripheralMbx1 = 19, /**< mbx1 */
  kTopPeppermintAlertPeripheralPwrmgr = 20, /**< pwrmgr */
  kTopPeppermintAlertPeripheralRstmgr = 21, /**< rstmgr */
  kTopPeppermintAlertPeripheralClkmgr = 22, /**< clkmgr */
  kTopPeppermintAlertPeripheralSramCtrlRet = 23, /**< sram_ctrl_ret */
  kTopPeppermintAlertPeripheralRvPlic = 24, /**< rv_plic */
  kTopPeppermintAlertPeripheralLast = 24, /**< \internal Final Alert peripheral */
} top_peppermint_alert_peripheral_t;

/**
 * Alert Handler Alert Source.
 *
 * Enumeration of all Alert Handler Alert Sources. The alert sources belonging to
 * the same peripheral are guaranteed to be consecutive.
 */
typedef enum top_peppermint_alert_id {
  kTopPeppermintAlertIdRvTimerFatalFault = 0, /**< rv_timer_fatal_fault */
  kTopPeppermintAlertIdOtpCtrlFatalMacroError = 1, /**< otp_ctrl_fatal_macro_error */
  kTopPeppermintAlertIdOtpCtrlFatalCheckError = 2, /**< otp_ctrl_fatal_check_error */
  kTopPeppermintAlertIdOtpCtrlFatalBusIntegError = 3, /**< otp_ctrl_fatal_bus_integ_error */
  kTopPeppermintAlertIdOtpCtrlFatalPrimOtpAlert = 4, /**< otp_ctrl_fatal_prim_otp_alert */
  kTopPeppermintAlertIdOtpCtrlRecovPrimOtpAlert = 5, /**< otp_ctrl_recov_prim_otp_alert */
  kTopPeppermintAlertIdLcCtrlFatalProgError = 6, /**< lc_ctrl_fatal_prog_error */
  kTopPeppermintAlertIdLcCtrlFatalStateError = 7, /**< lc_ctrl_fatal_state_error */
  kTopPeppermintAlertIdLcCtrlFatalBusIntegError = 8, /**< lc_ctrl_fatal_bus_integ_error */
  kTopPeppermintAlertIdAesRecovCtrlUpdateErr = 9, /**< aes_recov_ctrl_update_err */
  kTopPeppermintAlertIdAesFatalFault = 10, /**< aes_fatal_fault */
  kTopPeppermintAlertIdHmacFatalFault = 11, /**< hmac_fatal_fault */
  kTopPeppermintAlertIdKmacRecovOperationErr = 12, /**< kmac_recov_operation_err */
  kTopPeppermintAlertIdKmacFatalFaultErr = 13, /**< kmac_fatal_fault_err */
  kTopPeppermintAlertIdOtbnFatal = 14, /**< otbn_fatal */
  kTopPeppermintAlertIdOtbnRecov = 15, /**< otbn_recov */
  kTopPeppermintAlertIdKeymgrDpeRecovOperationErr = 16, /**< keymgr_dpe_recov_operation_err */
  kTopPeppermintAlertIdKeymgrDpeFatalFaultErr = 17, /**< keymgr_dpe_fatal_fault_err */
  kTopPeppermintAlertIdCsrngRecovAlert = 18, /**< csrng_recov_alert */
  kTopPeppermintAlertIdCsrngFatalAlert = 19, /**< csrng_fatal_alert */
  kTopPeppermintAlertIdEntropySrcRecovAlert = 20, /**< entropy_src_recov_alert */
  kTopPeppermintAlertIdEntropySrcFatalAlert = 21, /**< entropy_src_fatal_alert */
  kTopPeppermintAlertIdEdn0RecovAlert = 22, /**< edn0_recov_alert */
  kTopPeppermintAlertIdEdn0FatalAlert = 23, /**< edn0_fatal_alert */
  kTopPeppermintAlertIdEdn1RecovAlert = 24, /**< edn1_recov_alert */
  kTopPeppermintAlertIdEdn1FatalAlert = 25, /**< edn1_fatal_alert */
  kTopPeppermintAlertIdSramCtrlMainFatalError = 26, /**< sram_ctrl_main_fatal_error */
  kTopPeppermintAlertIdRomCtrlFatal = 27, /**< rom_ctrl_fatal */
  kTopPeppermintAlertIdRvCoreIbexFatalSwErr = 28, /**< rv_core_ibex_fatal_sw_err */
  kTopPeppermintAlertIdRvCoreIbexRecovSwErr = 29, /**< rv_core_ibex_recov_sw_err */
  kTopPeppermintAlertIdRvCoreIbexFatalHwErr = 30, /**< rv_core_ibex_fatal_hw_err */
  kTopPeppermintAlertIdRvCoreIbexRecovHwErr = 31, /**< rv_core_ibex_recov_hw_err */
  kTopPeppermintAlertIdRvDmFatalFault = 32, /**< rv_dm_fatal_fault */
  kTopPeppermintAlertIdDmaFatalFault = 33, /**< dma_fatal_fault */
  kTopPeppermintAlertIdMbx0FatalFault = 34, /**< mbx0_fatal_fault */
  kTopPeppermintAlertIdMbx0RecovFault = 35, /**< mbx0_recov_fault */
  kTopPeppermintAlertIdMbx1FatalFault = 36, /**< mbx1_fatal_fault */
  kTopPeppermintAlertIdMbx1RecovFault = 37, /**< mbx1_recov_fault */
  kTopPeppermintAlertIdPwrmgrFatalFault = 38, /**< pwrmgr_fatal_fault */
  kTopPeppermintAlertIdRstmgrFatalFault = 39, /**< rstmgr_fatal_fault */
  kTopPeppermintAlertIdRstmgrFatalCnstyFault = 40, /**< rstmgr_fatal_cnsty_fault */
  kTopPeppermintAlertIdClkmgrRecovFault = 41, /**< clkmgr_recov_fault */
  kTopPeppermintAlertIdClkmgrFatalFault = 42, /**< clkmgr_fatal_fault */
  kTopPeppermintAlertIdSramCtrlRetFatalError = 43, /**< sram_ctrl_ret_fatal_error */
  kTopPeppermintAlertIdRvPlicFatalFault = 44, /**< rv_plic_fatal_fault */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert0 = 45, /**< incoming_soc_soc_recov_alert_0 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert1 = 46, /**< incoming_soc_soc_recov_alert_1 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert2 = 47, /**< incoming_soc_soc_recov_alert_2 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert3 = 48, /**< incoming_soc_soc_recov_alert_3 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert4 = 49, /**< incoming_soc_soc_recov_alert_4 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert5 = 50, /**< incoming_soc_soc_recov_alert_5 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert6 = 51, /**< incoming_soc_soc_recov_alert_6 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert7 = 52, /**< incoming_soc_soc_recov_alert_7 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert8 = 53, /**< incoming_soc_soc_recov_alert_8 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert9 = 54, /**< incoming_soc_soc_recov_alert_9 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert10 = 55, /**< incoming_soc_soc_recov_alert_10 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert11 = 56, /**< incoming_soc_soc_recov_alert_11 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert12 = 57, /**< incoming_soc_soc_recov_alert_12 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert13 = 58, /**< incoming_soc_soc_recov_alert_13 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert14 = 59, /**< incoming_soc_soc_recov_alert_14 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert15 = 60, /**< incoming_soc_soc_recov_alert_15 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert16 = 61, /**< incoming_soc_soc_recov_alert_16 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert17 = 62, /**< incoming_soc_soc_recov_alert_17 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert18 = 63, /**< incoming_soc_soc_recov_alert_18 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert19 = 64, /**< incoming_soc_soc_recov_alert_19 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert20 = 65, /**< incoming_soc_soc_recov_alert_20 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert21 = 66, /**< incoming_soc_soc_recov_alert_21 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert22 = 67, /**< incoming_soc_soc_recov_alert_22 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert23 = 68, /**< incoming_soc_soc_recov_alert_23 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert24 = 69, /**< incoming_soc_soc_recov_alert_24 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert25 = 70, /**< incoming_soc_soc_recov_alert_25 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert26 = 71, /**< incoming_soc_soc_recov_alert_26 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert27 = 72, /**< incoming_soc_soc_recov_alert_27 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert28 = 73, /**< incoming_soc_soc_recov_alert_28 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert29 = 74, /**< incoming_soc_soc_recov_alert_29 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert30 = 75, /**< incoming_soc_soc_recov_alert_30 */
  kTopPeppermintAlertIdIncomingSocSocRecovAlert31 = 76, /**< incoming_soc_soc_recov_alert_31 */
  kTopPeppermintAlertIdIncomingSocSocFatalAlert0 = 77, /**< incoming_soc_soc_fatal_alert_0 */
  kTopPeppermintAlertIdIncomingSocSocFatalAlert1 = 78, /**< incoming_soc_soc_fatal_alert_1 */
  kTopPeppermintAlertIdIncomingSocSocFatalAlert2 = 79, /**< incoming_soc_soc_fatal_alert_2 */
  kTopPeppermintAlertIdIncomingSocSocFatalAlert3 = 80, /**< incoming_soc_soc_fatal_alert_3 */
  kTopPeppermintAlertIdIncomingSocSocFatalAlert4 = 81, /**< incoming_soc_soc_fatal_alert_4 */
  kTopPeppermintAlertIdIncomingSocSocFatalAlert5 = 82, /**< incoming_soc_soc_fatal_alert_5 */
  kTopPeppermintAlertIdIncomingSocSocFatalAlert6 = 83, /**< incoming_soc_soc_fatal_alert_6 */
  kTopPeppermintAlertIdIncomingSocSocFatalAlert7 = 84, /**< incoming_soc_soc_fatal_alert_7 */
  kTopPeppermintAlertIdLast = 84, /**< \internal The Last Valid Alert ID. */
} top_peppermint_alert_id_t;

/**
 * Alert Handler Alert Source to Peripheral Map
 *
 * This array is a mapping from `top_peppermint_alert_id_t` to
 * `top_peppermint_alert_peripheral_t`.
 */
extern const top_peppermint_alert_peripheral_t
    top_peppermint_alert_for_peripheral[85];

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
#define TOP_PEPPERMINT_MMIO_BASE_ADDR 0x40000000u
#define TOP_PEPPERMINT_MMIO_SIZE_BYTES 0x10000000u

// Header Extern Guard
#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // OPENTITAN_HW_TOP_PEPPERMINT_SW_AUTOGEN_TOP_PEPPERMINT_H_
