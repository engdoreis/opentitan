// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef OPENTITAN_SW_DEVICE_SILICON_CREATOR_ROM_LIB_ROM_INIT_H_
#define OPENTITAN_SW_DEVICE_SILICON_CREATOR_ROM_LIB_ROM_INIT_H_

#include <stdint.h>

#include "sw/device/lib/base/macros.h"
#include "sw/device/silicon_creator/lib/error.h"
#include "sw/device/silicon_creator/rom/lib/rom.h"

#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus

/**
 * A RAM copy of the OTP word controlling how to handle flash ECC errors.
 *
 * Shared with the assembly flash exception handler
 * (`sw/device/silicon_creator/lib/flash_exc_handler.S`).
 */
extern uint32_t flash_ecc_exc_handler_en;

/**
 * Performs once-per-boot initialization of ROM modules and peripherals.
 *
 * @param ctx[in,out] The ROM context.
 * @return Result of the operation.
 */
OT_WARN_UNUSED_RESULT rom_error_t rom_init(rom_ctx_t *ctx);

#ifdef __cplusplus
}  // extern "C"
#endif  // __cplusplus

#endif  // OPENTITAN_SW_DEVICE_SILICON_CREATOR_ROM_LIB_ROM_INIT_H_
