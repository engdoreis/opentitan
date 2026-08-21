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

/* Table of forward branch Control Flow Integrity (CFI) counters.
*
* Columns: Name, Initital Value.
*
* Each counter is indexed by Name. The Initial Value is used to initialize the
* counters with unique values with a good hamming distance. The values are
* restricted to 11-bit to be able use immediate load instructions.

* Encoding generated with
* $ ./util/design/sparse-fsm-encode.py -d 6 -m 7 -n 11 \
*     --avoid-zero -s 1630646358
*
* Minimum Hamming distance: 6
* Maximum Hamming distance: 8
* Minimum Hamming weight: 6
* Maximum Hamming weight: 8
*/
// clang-format off
#define ROM_CFI_FUNC_COUNTERS_TABLE(X) \
  X(kCfiRomMain,         0x4ab) \
  X(kCfiRomInit,         0x1df) \
  X(kCfiRomVerify,       0x2ec) \
  X(kCfiRomVerifyImm,    0x565) \
  X(kCfiRomTryBoot,      0x7b6) \
  X(kCfiRomPreBootCheck, 0x339) \
  X(kCfiRomBoot,         0x65a)
// clang-format on

// Define counters and constant values required by the CFI counter macros.
CFI_DEFINE_COUNTERS(ROM_CFI_FUNC_COUNTERS_TABLE);

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

  uint32_t *rom_counters;
} rom_ctx_t;

/**
 * The first C function executed by the ROM (defined in `rom.c`)
 */
noreturn void rom_main(void);

#ifdef __cplusplus
}  // extern "C"
#endif  // __cplusplus

#endif  // OPENTITAN_SW_DEVICE_SILICON_CREATOR_ROM_LIB_ROM_H_
