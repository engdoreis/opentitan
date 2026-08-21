// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <stdint.h>

#include "sw/device/lib/base/hardened.h"
#include "sw/device/lib/base/macros.h"
#include "sw/device/silicon_creator/lib/cfi.h"
#include "sw/device/silicon_creator/lib/drivers/uart.h"
#include "sw/device/silicon_creator/lib/drivers/watchdog.h"
#include "sw/device/silicon_creator/lib/error.h"
#include "sw/device/silicon_creator/lib/shutdown.h"
#include "sw/device/silicon_creator/rom/lib/bootstrap.h"
#include "sw/device/silicon_creator/rom/lib/rom.h"
#include "sw/device/silicon_creator/rom/lib/rom_init.h"
#include "sw/device/silicon_creator/rom/lib/rom_state.h"
#include "sw/device/silicon_creator/rom/lib/rom_try_boot.h"

CFI_DEFINE_COUNTERS_TABLE(rom_counters, ROM_CFI_FUNC_COUNTERS_TABLE);

// Place this in the .bss. to be zero initialized, rom_counters pointer set at
// the top of rom_main() before first use — a non-null pointer initializer would
// place this struct in .data.
static rom_ctx_t earlgrey_rom_ctx;

/**
 * Prints a status message indicating that the ROM is entering bootstrap mode.
 */
static void rom_bootstrap_message(void) {
  //                              a r t s t o o b
  const uint64_t kBootstrap1 = 0x61727473746f6f62;
  //                             \n\r 1 : p
  const uint64_t kBootstrap2 = 0x0a0d313a70;
  uart_write_imm(kBootstrap1);
  uart_write_imm(kBootstrap2);
}

/*
 * The bootstrap request is the `kRomStateBootstrapCheck` and
 * `kRomStateBootstrap` ROM states argument. It must be undefined before
 * entering the `kRomStateBootstrapCheck` state as only the
 * `kRomStateBootstrapCheck` run callback or hooks should set it to either
 * `kHardenedBoolFalse` or `kHardenedBoolTrue`.
 */
static hardened_bool_t bootstrap_request = 0;

enum {
  kRomStateCnt = 4,
};

static OT_WARN_UNUSED_RESULT rom_error_t rom_state_init(void *arg,
                                                        uint32_t *next_state);
static OT_WARN_UNUSED_RESULT rom_error_t
rom_state_bootstrap_check(void *arg, uint32_t *next_state);
static OT_WARN_UNUSED_RESULT rom_error_t
rom_state_bootstrap(void *arg, uint32_t *next_state);
static OT_WARN_UNUSED_RESULT rom_error_t
rom_state_boot_rom_ext(void *arg, uint32_t *next_state);

/**
 * Table of ROM states.
 *
 * Encoding generated with:
 * $ ./util/design/sparse-fsm-encode.py -d 6 -m 4 -n 16 \
 *     -s 519644925 --language=c
 */
// clang-format off
#define ROM_STATES(X)                                                               \
  X(kRomStateInit,           0x5616, rom_state_init, NULL)                          \
  X(kRomStateBootstrapCheck, 0x0a92, rom_state_bootstrap_check, &bootstrap_request) \
  X(kRomStateBootstrap,      0xd0a0, rom_state_bootstrap, &bootstrap_request)       \
  X(kRomStateBootRomExt,     0xed14, rom_state_boot_rom_ext, NULL)
// clang-format on

ROM_STATE_INIT_TABLE(rom_states, kRomStateCnt, ROM_STATES);

static OT_WARN_UNUSED_RESULT rom_error_t rom_state_init(void *arg,
                                                        uint32_t *next_state) {
  CFI_FUNC_COUNTER_INIT(rom_counters, kCfiRomMain);

  CFI_FUNC_COUNTER_PREPCALL(rom_counters, kCfiRomMain, 1, kCfiRomInit);
  HARDENED_RETURN_IF_ERROR(rom_init(&earlgrey_rom_ctx));
  CFI_FUNC_COUNTER_INCREMENT(rom_counters, kCfiRomMain, 3);

  *next_state = kRomStateBootstrapCheck;

  return kErrorOk;
}

static OT_WARN_UNUSED_RESULT rom_error_t
rom_state_bootstrap_check(void *arg, uint32_t *next_state) {
  if (launder32(earlgrey_rom_ctx.waking_from_low_power) != kHardenedBoolTrue) {
    HARDENED_CHECK_EQ(earlgrey_rom_ctx.waking_from_low_power,
                      kHardenedBoolFalse);

    hardened_bool_t *bootstrap_req = (hardened_bool_t *)arg;

    if (launder32(*bootstrap_req) == 0) {
      // The pre_ hook has not set the bootstrap request flag, it has to be
      // checked and set to True or False
      HARDENED_CHECK_EQ(*bootstrap_req, 0);
      *bootstrap_req = bootstrap_requested();
    }

    // The bootstrap request flag must now be True or False.
    if (launder32(*bootstrap_req) == kHardenedBoolTrue) {
      HARDENED_CHECK_EQ(*bootstrap_req, kHardenedBoolTrue);
      *next_state = kRomStateBootstrap;
      return kErrorOk;
    }
  }

  // We are not bootstrapping, aiming for ROM ext.
  *next_state = kRomStateBootRomExt;
  return kErrorOk;
}

static OT_WARN_UNUSED_RESULT rom_error_t
rom_state_bootstrap(void *arg, uint32_t *next_state) {
  hardened_bool_t *bootstrap_req = (hardened_bool_t *)arg;

  if (launder32(*bootstrap_req) == kHardenedBoolTrue) {
    HARDENED_CHECK_EQ(*bootstrap_req, kHardenedBoolTrue);
    rom_bootstrap_message();
    watchdog_disable();
    // `bootstrap` will not return unless there is an error.
    HARDENED_RETURN_IF_ERROR(bootstrap());
  }

  return kErrorRomBootFailed;
}

static OT_WARN_UNUSED_RESULT rom_error_t
rom_state_boot_rom_ext(void *arg, uint32_t *next_state) {
  // `rom_try_boot` will not return unless there is an error.
  CFI_FUNC_COUNTER_PREPCALL(rom_counters, kCfiRomMain, 4, kCfiRomTryBoot);
  return rom_try_boot(&earlgrey_rom_ctx);
}

void rom_main(void) {
  earlgrey_rom_ctx.rom_counters = rom_counters;
  CFI_FUNC_COUNTER_INIT(rom_counters, kCfiRomMain);
  shutdown_finalize(rom_state_fsm_walk(rom_states, kRomStateCnt, kRomStateInit,
                                       rom_states_cfi));
}
