// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sw/device/silicon_creator/rom/lib/rom_init.h"

#include <stdbool.h>
#include <stdint.h>

#include "sw/device/lib/arch/device.h"
#include "sw/device/lib/base/bitfield.h"
#include "sw/device/lib/base/csr.h"
#include "sw/device/lib/base/hardened.h"
#include "sw/device/lib/base/macros.h"
#include "sw/device/lib/base/memory.h"
#include "sw/device/silicon_creator/lib/base/sec_mmio.h"
#include "sw/device/silicon_creator/lib/base/static_critical_version.h"
#include "sw/device/silicon_creator/lib/boot_log.h"
#include "sw/device/silicon_creator/lib/build_info.h"
#include "sw/device/silicon_creator/lib/cfi.h"
#include "sw/device/silicon_creator/lib/drivers/ast.h"
#include "sw/device/silicon_creator/lib/drivers/otp.h"
#include "sw/device/silicon_creator/lib/drivers/pinmux.h"
#include "sw/device/silicon_creator/lib/drivers/pwrmgr.h"
#include "sw/device/silicon_creator/lib/drivers/retention_sram.h"
#include "sw/device/silicon_creator/lib/drivers/rnd.h"
#include "sw/device/silicon_creator/lib/drivers/rstmgr.h"
#include "sw/device/silicon_creator/lib/drivers/sensor_ctrl.h"
#include "sw/device/silicon_creator/lib/drivers/uart.h"
#include "sw/device/silicon_creator/lib/drivers/watchdog.h"
#include "sw/device/silicon_creator/lib/error.h"
#include "sw/device/silicon_creator/lib/nvm_ctrl.h"
#include "sw/device/silicon_creator/lib/shutdown.h"
#include "sw/device/silicon_creator/rom/lib/rom.h"
#include "sw/device/silicon_creator/rom/lib/rom_epmp.h"

#include "hw/top/hmac_regs.h"  // Generated.
#include "hw/top/otp_ctrl_regs.h"
#include "hw/top/rstmgr_regs.h"

// A ram copy of the OTP word controlling how to handle flash ECC errors.
// This is a global shared with `flash_exception_handler`.
uint32_t flash_ecc_exc_handler_en = 0;

static inline bool rom_console_enabled(void) {
  return otp_read32(OTP_CTRL_PARAM_OWNER_SW_CFG_ROM_BANNER_EN_OFFSET) !=
         kHardenedBoolFalse;
}

/**
 * Prints a banner during bootup.
 *
 * OpenTitan:ssss-pppp-rr
 *
 * Where:
 * - ssss: Silicon Creator ID.
 * - pppp: Product ID.
 * - rr: Revision ID.
 */

static void rom_banner(void) {
  if (!rom_console_enabled()) {
    return;
  }
  //                          a t i T n e p O
  const uint64_t kTitle1 = 0x617469546e65704f;
  //                          : n
  const uint32_t kTitle2 = 0x3a6e;
  const uint32_t kNewline = 0x0a0d;
  lifecycle_hw_rev_t hw;
  lifecycle_hw_rev_get(&hw);
  uart_write_imm(kTitle1);
  uart_write_imm(kTitle2);
  uart_write_hex(hw.silicon_creator_id, sizeof(hw.silicon_creator_id), '-');
  uart_write_hex(hw.product_id, sizeof(hw.product_id), '-');
  uart_write_hex(hw.revision_id, sizeof(hw.revision_id), kNewline);
}
/**
 * Performs once-per-boot initialization of ROM modules and peripherals.
 */
OT_WARN_UNUSED_RESULT
rom_error_t rom_init(rom_ctx_t *ctx) {
  CFI_FUNC_COUNTER_INCREMENT(ctx->rom_counters, kCfiRomInit, 1);
  sec_mmio_init();
  uint32_t reset_reasons = rstmgr_reason_get();
  ctx->reset_reason_check =
      reset_reasons ^
      (otp_read32(
           OTP_CTRL_PARAM_OWNER_SW_CFG_ROM_RESET_REASON_CHECK_VALUE_OFFSET) &
       0xFFFF);
  if (reset_reasons != (1U << RSTMGR_RESET_INFO_LOW_POWER_EXIT_BIT)) {
    // The above compares all bits, rather than just the one indication "low
    // power exit", because if there is any other reset reason, besides
    // LOW_POWER_EXIT, it means that the chip did full reset while coming out of
    // low power.  In that case, the state of AON IP blocks would have been
    // reset, and the ROM should not treat this as "waking from low power".
    ctx->waking_from_low_power = kHardenedBoolFalse;

    // Initialize pinmux configuration so we can use the UART, (except if waking
    // up from low power, as the pinmux will in such case have retained its
    // previous configuration.)
    pinmux_init();
  } else {
    ctx->waking_from_low_power = kHardenedBoolTrue;
  }

  // Configure UART0 as stdout.
  uart_init(kUartNCOValue);

  // Set static_critical region format version.
  static_critical_version = kStaticCriticalVersion2;

  // There are no conditional checks before writing to this CSR because it is
  // expected that if relevant Ibex countermeasures are disabled, this will
  // result in a nop.
  CSR_WRITE(CSR_REG_SECURESEED, rnd_uint32());

  // Write the OTP value to bits 0 to 5 of the cpuctrl CSR.
  uint32_t cpuctrl_csr;
  CSR_READ(CSR_REG_CPUCTRL, &cpuctrl_csr);
  cpuctrl_csr = bitfield_field32_write(
      cpuctrl_csr, (bitfield_field32_t){.mask = 0x3f, .index = 0},
      otp_read32(OTP_CTRL_PARAM_CREATOR_SW_CFG_CPUCTRL_OFFSET));
  CSR_WRITE(CSR_REG_CPUCTRL, cpuctrl_csr);

  ctx->lc_state = lifecycle_state_get();

  // Update epmp config for debug rom according to lifecycle state.
  rom_epmp_config_debug_rom(ctx->lc_state);

  if (launder32(ctx->waking_from_low_power) != kHardenedBoolTrue) {
    HARDENED_CHECK_EQ(ctx->waking_from_low_power, kHardenedBoolFalse);
    // Re-initialize the watchdog timer, if the RESET was caused by anything
    // besides waking from low power (which would have left the watchdog in its
    // previous configuration).
    watchdog_init(ctx->lc_state);
    SEC_MMIO_WRITE_INCREMENT(kWatchdogSecMmioInit);

    // Re-initialize sensor_ctrl.
    HARDENED_RETURN_IF_ERROR(sensor_ctrl_configure(ctx->lc_state));
    pwrmgr_cdc_sync(kSensorCtrlSyncCycles);
  } else {
    HARDENED_CHECK_EQ(ctx->waking_from_low_power, kHardenedBoolTrue);
  }

  // Initialize the shutdown policy.
  HARDENED_RETURN_IF_ERROR(shutdown_init(ctx->lc_state));

  nvm_ctrl_init();
  SEC_MMIO_WRITE_INCREMENT(kNvmCtrlSecMmioInit);
  flash_ecc_exc_handler_en = otp_read32(
      OTP_CTRL_PARAM_OWNER_SW_CFG_ROM_FLASH_ECC_EXC_HANDLER_EN_OFFSET);

  // Initialize in-memory copy of the ePMP register configuration.
  rom_epmp_state_init(ctx->lc_state);

  // Check that AST is in the expected state.
  HARDENED_RETURN_IF_ERROR(ast_check(ctx->lc_state));

  // Initialize the retention RAM based on the reset reason and the OTP value.
  // Note: Retention RAM is always reset on PoR regardless of the OTP value.
  uint32_t reset_mask =
      (1 << kRstmgrReasonPowerOn) |
      otp_read32(OTP_CTRL_PARAM_CREATOR_SW_CFG_RET_RAM_RESET_MASK_OFFSET);
  if ((reset_reasons & reset_mask) != 0) {
    retention_sram_init();
    // The high nybble controls the retram readback enable.
    retention_sram_readback_enable(
        otp_read32(OTP_CTRL_PARAM_OWNER_SW_CFG_ROM_SRAM_READBACK_EN_OFFSET) >>
        4);
    retention_sram_get()->creator.last_shutdown_reason = kErrorOk;
  }

  // Initialize boot_log
  boot_log_t *boot_log = &retention_sram_get()->creator.boot_log;
  memset(boot_log, 0, sizeof(*boot_log));
  boot_log->identifier = kBootLogIdentifier;
  boot_log->chip_version = kBuildInfo.scm_revision;
  boot_log->retention_ram_initialized =
      reset_reasons & reset_mask ? kHardenedBoolTrue : kHardenedBoolFalse;

  // Always store the retention RAM version so the ROM_EXT can depend on its
  // accuracy even after scrambling.
  retention_sram_get()->version = kRetentionSramVersion4;

  // Store the reset reason in retention RAM.
  retention_sram_get()->creator.reset_reasons = reset_reasons;

  // Print a nice message.
  if (ctx->waking_from_low_power != kHardenedBoolTrue) {
    rom_banner();
  }
  // This function is a NOP unless ROM is built for an fpga.
  device_fpga_version_print();

  // Double check the reset reason value against the OTP-defined value.
  ctx->reset_reason_check =
      launder32(ctx->reset_reason_check) ^ rstmgr_reason_get();
  uint32_t check_val =
      otp_read32(
          OTP_CTRL_PARAM_OWNER_SW_CFG_ROM_RESET_REASON_CHECK_VALUE_OFFSET) >>
      16;
  if (launder32(check_val) != kHardenedBoolFalse) {
    // Double-check the reset reason.
    if (launder32(check_val) == ctx->reset_reason_check) {
      HARDENED_CHECK_EQ(check_val, ctx->reset_reason_check);
      // Reset reasons equal, do nothing.
    } else {
      return kErrorRomResetReasonFault;
    }
  } else {
    // Configured to not double-check the reset reason.
    HARDENED_CHECK_EQ(check_val, kHardenedBoolFalse);
  }

  // Clear the register if configured to do so.
  if (otp_read32(
          OTP_CTRL_PARAM_OWNER_SW_CFG_ROM_PRESERVE_RESET_REASON_EN_OFFSET) !=
      kHardenedBoolTrue) {
    rstmgr_reason_clear(reset_reasons);
  }

  sec_mmio_check_values(rnd_uint32());
  sec_mmio_check_counters(/*expected_check_count=*/1);

  CFI_FUNC_COUNTER_INCREMENT(ctx->rom_counters, kCfiRomInit, 2);
  return kErrorOk;
}
