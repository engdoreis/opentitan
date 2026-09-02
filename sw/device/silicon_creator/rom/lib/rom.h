// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef OPENTITAN_SW_DEVICE_SILICON_CREATOR_ROM_LIB_ROM_H_
#define OPENTITAN_SW_DEVICE_SILICON_CREATOR_ROM_LIB_ROM_H_

#include <stdint.h>
#include <stdnoreturn.h>

#include "sw/device/lib/base/hardened.h"
#include "sw/device/lib/base/macros.h"
#include "sw/device/silicon_creator/lib/boot_data.h"
#include "sw/device/silicon_creator/lib/cfi.h"
#include "sw/device/silicon_creator/lib/drivers/lifecycle.h"
#include "sw/device/silicon_creator/lib/error.h"
#include "sw/device/silicon_creator/rom/lib/sigverify_otp_keys.h"

#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus

// A context struct with data shared accross ROM states.
typedef struct rom_ctx {
  // Life cycle state of the chip.
  lifecycle_state_t lc_state;
  // Boot data from flash.
  boot_data_t boot_data;
  // Whether we are "simply" waking from low power mode.
  hardened_bool_t waking_from_low_power;
  // First stage (ROM-->ROM_EXT) secure boot keys loaded from OTP.
  sigverify_otp_key_ctx_t sigverify_ctx;
  // A check value for the reset reason.
  uint32_t reset_reason_check;
} rom_ctx_t;

/**
 * The first C function executed by the ROM (defined in `rom.c`)
 */
noreturn void rom_main(void);

#ifdef __cplusplus
}  // extern "C"
#endif  // __cplusplus

#endif  // OPENTITAN_SW_DEVICE_SILICON_CREATOR_ROM_LIB_ROM_H_
