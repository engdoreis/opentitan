// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef OPENTITAN_SW_DEVICE_SILICON_CREATOR_ROM_LIB_ROM_TRY_BOOT_H_
#define OPENTITAN_SW_DEVICE_SILICON_CREATOR_ROM_LIB_ROM_TRY_BOOT_H_

#include "sw/device/lib/base/macros.h"
#include "sw/device/silicon_creator/lib/error.h"
#include "sw/device/silicon_creator/rom/lib/rom.h"

#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus

/**
 * Attempts to boot ROM_EXTs in the order given by the boot policy module.
 *
 * @param ctx The ROM context.
 * @return Result of the last attempt.
 */
OT_WARN_UNUSED_RESULT rom_error_t rom_try_boot(rom_ctx_t *ctx);

#ifdef __cplusplus
}  // extern "C"
#endif  // __cplusplus

#endif  // OPENTITAN_SW_DEVICE_SILICON_CREATOR_ROM_LIB_ROM_TRY_BOOT_H_
