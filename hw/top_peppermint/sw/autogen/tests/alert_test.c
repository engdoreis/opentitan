// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
// clang-format off

//
// ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------//
// PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
// util/topgen.py -t hw/top_peppermint/data/top_peppermint.hjson
//                -o hw/top_peppermint/
#include "sw/device/lib/arch/boot_stage.h"
#include "sw/device/lib/base/mmio.h"
#include "sw/device/lib/dif/autogen/dif_aes_autogen.h"
#include "sw/device/lib/dif/autogen/dif_alert_handler_autogen.h"
#include "sw/device/lib/dif/autogen/dif_clkmgr_autogen.h"
#include "sw/device/lib/dif/autogen/dif_csrng_autogen.h"
#include "sw/device/lib/dif/autogen/dif_dma_autogen.h"
#include "sw/device/lib/dif/autogen/dif_edn_autogen.h"
#include "sw/device/lib/dif/autogen/dif_entropy_src_autogen.h"
#include "sw/device/lib/dif/autogen/dif_hmac_autogen.h"
#include "sw/device/lib/dif/autogen/dif_keymgr_dpe_autogen.h"
#include "sw/device/lib/dif/autogen/dif_kmac_autogen.h"
#include "sw/device/lib/dif/autogen/dif_lc_ctrl_autogen.h"
#include "sw/device/lib/dif/autogen/dif_mbx_autogen.h"
#include "sw/device/lib/dif/autogen/dif_otbn_autogen.h"
#include "sw/device/lib/dif/autogen/dif_otp_ctrl_autogen.h"
#include "sw/device/lib/dif/autogen/dif_pwrmgr_autogen.h"
#include "sw/device/lib/dif/autogen/dif_rom_ctrl_autogen.h"
#include "sw/device/lib/dif/autogen/dif_rstmgr_autogen.h"
#include "sw/device/lib/dif/autogen/dif_rv_core_ibex_autogen.h"
#include "sw/device/lib/dif/autogen/dif_rv_plic_autogen.h"
#include "sw/device/lib/dif/autogen/dif_rv_timer_autogen.h"
#include "sw/device/lib/dif/autogen/dif_sram_ctrl_autogen.h"
#include "sw/device/lib/testing/alert_handler_testutils.h"
#include "sw/device/lib/testing/test_framework/FreeRTOSConfig.h"
#include "sw/device/lib/testing/test_framework/check.h"
#include "sw/device/lib/testing/test_framework/ottf_test_config.h"

#include "hw/top/alert_handler_regs.h"  // Generated.
#include "hw/top_peppermint/sw/autogen/top_peppermint.h"

OTTF_DEFINE_TEST_CONFIG();

static dif_alert_handler_t alert_handler;
static dif_aes_t aes;
static dif_clkmgr_t clkmgr;
static dif_csrng_t csrng;
static dif_dma_t dma;
static dif_edn_t edn0;
static dif_edn_t edn1;
static dif_entropy_src_t entropy_src;
static dif_hmac_t hmac;
static dif_keymgr_dpe_t keymgr_dpe;
static dif_kmac_t kmac;
static dif_lc_ctrl_t lc_ctrl;
static dif_mbx_t mbx0;
static dif_mbx_t mbx1;
static dif_otbn_t otbn;
static dif_otp_ctrl_t otp_ctrl;
static dif_pwrmgr_t pwrmgr;
static dif_rom_ctrl_t rom_ctrl;
static dif_rstmgr_t rstmgr;
static dif_rv_core_ibex_t rv_core_ibex;
static dif_rv_plic_t rv_plic;
static dif_rv_timer_t rv_timer;
static dif_sram_ctrl_t sram_ctrl_main;
static dif_sram_ctrl_t sram_ctrl_ret;

/**
 * Initialize the peripherals used in this test.
 */
static void init_peripherals(void) {
  mmio_region_t base_addr;
  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_ALERT_HANDLER_BASE_ADDR);
  CHECK_DIF_OK(dif_alert_handler_init(base_addr, &alert_handler));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_AES_BASE_ADDR);
  CHECK_DIF_OK(dif_aes_init(base_addr, &aes));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_CLKMGR_BASE_ADDR);
  CHECK_DIF_OK(dif_clkmgr_init(base_addr, &clkmgr));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_CSRNG_BASE_ADDR);
  CHECK_DIF_OK(dif_csrng_init(base_addr, &csrng));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_DMA_BASE_ADDR);
  CHECK_DIF_OK(dif_dma_init(base_addr, &dma));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_EDN0_BASE_ADDR);
  CHECK_DIF_OK(dif_edn_init(base_addr, &edn0));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_EDN1_BASE_ADDR);
  CHECK_DIF_OK(dif_edn_init(base_addr, &edn1));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_ENTROPY_SRC_BASE_ADDR);
  CHECK_DIF_OK(dif_entropy_src_init(base_addr, &entropy_src));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_HMAC_BASE_ADDR);
  CHECK_DIF_OK(dif_hmac_init(base_addr, &hmac));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_KEYMGR_DPE_BASE_ADDR);
  CHECK_DIF_OK(dif_keymgr_dpe_init(base_addr, &keymgr_dpe));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_KMAC_BASE_ADDR);
  CHECK_DIF_OK(dif_kmac_init(base_addr, &kmac));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_LC_CTRL_REGS_BASE_ADDR);
  CHECK_DIF_OK(dif_lc_ctrl_init(base_addr, &lc_ctrl));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_MBX0_CORE_BASE_ADDR);
  CHECK_DIF_OK(dif_mbx_init(base_addr, &mbx0));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_MBX1_CORE_BASE_ADDR);
  CHECK_DIF_OK(dif_mbx_init(base_addr, &mbx1));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_OTBN_BASE_ADDR);
  CHECK_DIF_OK(dif_otbn_init(base_addr, &otbn));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_OTP_CTRL_CORE_BASE_ADDR);
  CHECK_DIF_OK(dif_otp_ctrl_init(base_addr, &otp_ctrl));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_PWRMGR_BASE_ADDR);
  CHECK_DIF_OK(dif_pwrmgr_init(base_addr, &pwrmgr));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_ROM_CTRL_REGS_BASE_ADDR);
  CHECK_DIF_OK(dif_rom_ctrl_init(base_addr, &rom_ctrl));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_RSTMGR_BASE_ADDR);
  CHECK_DIF_OK(dif_rstmgr_init(base_addr, &rstmgr));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_RV_CORE_IBEX_CFG_BASE_ADDR);
  CHECK_DIF_OK(dif_rv_core_ibex_init(base_addr, &rv_core_ibex));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_RV_PLIC_BASE_ADDR);
  CHECK_DIF_OK(dif_rv_plic_init(base_addr, &rv_plic));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_RV_TIMER_BASE_ADDR);
  CHECK_DIF_OK(dif_rv_timer_init(base_addr, &rv_timer));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_SRAM_CTRL_MAIN_REGS_BASE_ADDR);
  CHECK_DIF_OK(dif_sram_ctrl_init(base_addr, &sram_ctrl_main));

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_SRAM_CTRL_RET_REGS_BASE_ADDR);
  CHECK_DIF_OK(dif_sram_ctrl_init(base_addr, &sram_ctrl_ret));

}

/**
 * Configure the alert handler to escalate on alerts upto phase 1 (i.e. wipe
 * secret) but not trigger reset. Then CPU can check if alert_handler triggers the correct
 * alert_cause register.
 */
static void alert_handler_config(void) {
  dif_alert_handler_alert_t alerts[ALERT_HANDLER_PARAM_N_ALERTS];
  dif_alert_handler_class_t alert_classes[ALERT_HANDLER_PARAM_N_ALERTS];

  // Enable all incoming alerts and configure them to classa.
  // This alert should never fire because we do not expect any incoming alerts.
  for (dif_alert_handler_alert_t i = 0; i < ALERT_HANDLER_PARAM_N_ALERTS; ++i) {
    alerts[i] = i;
    alert_classes[i] = kDifAlertHandlerClassA;
  }

  dif_alert_handler_escalation_phase_t esc_phases[] = {
      {.phase = kDifAlertHandlerClassStatePhase0,
       .signal = 0,
       .duration_cycles = 2000}};

  dif_alert_handler_class_config_t class_config = {
      .auto_lock_accumulation_counter = kDifToggleDisabled,
      .accumulator_threshold = 0,
      .irq_deadline_cycles = 10000,
      .escalation_phases = esc_phases,
      .escalation_phases_len = ARRAYSIZE(esc_phases),
      .crashdump_escalation_phase = kDifAlertHandlerClassStatePhase1,
  };

  dif_alert_handler_class_config_t class_configs[] = {class_config,
                                                      class_config};

  dif_alert_handler_class_t classes[] = {kDifAlertHandlerClassA,
                                         kDifAlertHandlerClassB};
  dif_alert_handler_config_t config = {
      .alerts = alerts,
      .alert_classes = alert_classes,
      .alerts_len = ARRAYSIZE(alerts),
      .classes = classes,
      .class_configs = class_configs,
      .classes_len = ARRAYSIZE(class_configs),
      .ping_timeout = 1000,
  };

 CHECK_STATUS_OK(alert_handler_testutils_configure_all(&alert_handler, config,
                                        kDifToggleEnabled));
}

// Trigger alert for each module by writing one to `alert_test` register.
// Then check alert_handler's alert_cause register to make sure the correct alert reaches
// alert_handler.
static void trigger_alert_test(void) {
  bool is_cause;
  dif_alert_handler_alert_t exp_alert;

  // Write aes's alert_test reg and check alert_cause.
  for (dif_aes_alert_t i = 0; i < 2; ++i) {
    CHECK_DIF_OK(dif_aes_alert_force(&aes, kDifAesAlertRecovCtrlUpdateErr + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdAesRecovCtrlUpdateErr + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // Write clkmgr's alert_test reg and check alert_cause.
  for (dif_clkmgr_alert_t i = 0; i < 2; ++i) {
    CHECK_DIF_OK(dif_clkmgr_alert_force(&clkmgr, kDifClkmgrAlertRecovFault + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdClkmgrRecovFault + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // Write csrng's alert_test reg and check alert_cause.
  for (dif_csrng_alert_t i = 0; i < 2; ++i) {
    CHECK_DIF_OK(dif_csrng_alert_force(&csrng, kDifCsrngAlertRecovAlert + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdCsrngRecovAlert + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // Write dma's alert_test reg and check alert_cause.
  for (dif_dma_alert_t i = 0; i < 1; ++i) {
    CHECK_DIF_OK(dif_dma_alert_force(&dma, kDifDmaAlertFatalFault + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdDmaFatalFault + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // Write edn's alert_test reg and check alert_cause.
  for (dif_edn_alert_t i = 0; i < 2; ++i) {
    CHECK_DIF_OK(dif_edn_alert_force(&edn0, kDifEdnAlertRecovAlert + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdEdn0RecovAlert + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // Write edn's alert_test reg and check alert_cause.
  for (dif_edn_alert_t i = 0; i < 2; ++i) {
    CHECK_DIF_OK(dif_edn_alert_force(&edn1, kDifEdnAlertRecovAlert + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdEdn1RecovAlert + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // Write entropy_src's alert_test reg and check alert_cause.
  for (dif_entropy_src_alert_t i = 0; i < 2; ++i) {
    CHECK_DIF_OK(dif_entropy_src_alert_force(&entropy_src, kDifEntropySrcAlertRecovAlert + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdEntropySrcRecovAlert + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // Write hmac's alert_test reg and check alert_cause.
  for (dif_hmac_alert_t i = 0; i < 1; ++i) {
    CHECK_DIF_OK(dif_hmac_alert_force(&hmac, kDifHmacAlertFatalFault + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdHmacFatalFault + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // Write keymgr_dpe's alert_test reg and check alert_cause.
  for (dif_keymgr_dpe_alert_t i = 0; i < 2; ++i) {
    CHECK_DIF_OK(dif_keymgr_dpe_alert_force(&keymgr_dpe, kDifKeymgrDpeAlertRecovOperationErr + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdKeymgrDpeRecovOperationErr + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // Write kmac's alert_test reg and check alert_cause.
  for (dif_kmac_alert_t i = 0; i < 2; ++i) {
    CHECK_DIF_OK(dif_kmac_alert_force(&kmac, kDifKmacAlertRecovOperationErr + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdKmacRecovOperationErr + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // Write lc_ctrl's alert_test reg and check alert_cause.
  for (dif_lc_ctrl_alert_t i = 0; i < 3; ++i) {
    CHECK_DIF_OK(dif_lc_ctrl_alert_force(&lc_ctrl, kDifLcCtrlAlertFatalProgError + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdLcCtrlFatalProgError + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // Write mbx's alert_test reg and check alert_cause.
  for (dif_mbx_alert_t i = 0; i < 2; ++i) {
    CHECK_DIF_OK(dif_mbx_alert_force(&mbx0, kDifMbxAlertFatalFault + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdMbx0FatalFault + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // Write mbx's alert_test reg and check alert_cause.
  for (dif_mbx_alert_t i = 0; i < 2; ++i) {
    CHECK_DIF_OK(dif_mbx_alert_force(&mbx1, kDifMbxAlertFatalFault + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdMbx1FatalFault + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // Write otbn's alert_test reg and check alert_cause.
  for (dif_otbn_alert_t i = 0; i < 2; ++i) {
    CHECK_DIF_OK(dif_otbn_alert_force(&otbn, kDifOtbnAlertFatal + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdOtbnFatal + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // TODO(lowrisc/opentitan#20348): Enable otp_ctrl when this is fixed.
  if (kBootStage != kBootStageOwner) {
    // Write otp_ctrl's alert_test reg and check alert_cause.
    for (dif_otp_ctrl_alert_t i = 0; i < 5; ++i) {
      CHECK_DIF_OK(dif_otp_ctrl_alert_force(&otp_ctrl, kDifOtpCtrlAlertFatalMacroError + i));

      // Verify that alert handler received it.
      exp_alert = (int)kTopPeppermintAlertIdOtpCtrlFatalMacroError + i;
      CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
          &alert_handler, exp_alert, &is_cause));
      CHECK(is_cause, "Expect alert %d!", exp_alert);

      // Clear alert cause register
      CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
          &alert_handler, exp_alert));
    }
  }

  // Write pwrmgr's alert_test reg and check alert_cause.
  for (dif_pwrmgr_alert_t i = 0; i < 1; ++i) {
    CHECK_DIF_OK(dif_pwrmgr_alert_force(&pwrmgr, kDifPwrmgrAlertFatalFault + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdPwrmgrFatalFault + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // Write rom_ctrl's alert_test reg and check alert_cause.
  for (dif_rom_ctrl_alert_t i = 0; i < 1; ++i) {
    CHECK_DIF_OK(dif_rom_ctrl_alert_force(&rom_ctrl, kDifRomCtrlAlertFatal + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdRomCtrlFatal + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // Write rstmgr's alert_test reg and check alert_cause.
  for (dif_rstmgr_alert_t i = 0; i < 2; ++i) {
    CHECK_DIF_OK(dif_rstmgr_alert_force(&rstmgr, kDifRstmgrAlertFatalFault + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdRstmgrFatalFault + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // Write rv_core_ibex's alert_test reg and check alert_cause.
  for (dif_rv_core_ibex_alert_t i = 0; i < 4; ++i) {
    CHECK_DIF_OK(dif_rv_core_ibex_alert_force(&rv_core_ibex, kDifRvCoreIbexAlertFatalSwErr + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdRvCoreIbexFatalSwErr + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // Write rv_plic's alert_test reg and check alert_cause.
  for (dif_rv_plic_alert_t i = 0; i < 1; ++i) {
    CHECK_DIF_OK(dif_rv_plic_alert_force(&rv_plic, kDifRvPlicAlertFatalFault + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdRvPlicFatalFault + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // Write rv_timer's alert_test reg and check alert_cause.
  for (dif_rv_timer_alert_t i = 0; i < 1; ++i) {
    CHECK_DIF_OK(dif_rv_timer_alert_force(&rv_timer, kDifRvTimerAlertFatalFault + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdRvTimerFatalFault + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // Write sram_ctrl's alert_test reg and check alert_cause.
  for (dif_sram_ctrl_alert_t i = 0; i < 1; ++i) {
    CHECK_DIF_OK(dif_sram_ctrl_alert_force(&sram_ctrl_main, kDifSramCtrlAlertFatalError + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdSramCtrlMainFatalError + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }

  // Write sram_ctrl's alert_test reg and check alert_cause.
  for (dif_sram_ctrl_alert_t i = 0; i < 1; ++i) {
    CHECK_DIF_OK(dif_sram_ctrl_alert_force(&sram_ctrl_ret, kDifSramCtrlAlertFatalError + i));

    // Verify that alert handler received it.
    exp_alert = (int)kTopPeppermintAlertIdSramCtrlRetFatalError + i;
    CHECK_DIF_OK(dif_alert_handler_alert_is_cause(
        &alert_handler, exp_alert, &is_cause));
    CHECK(is_cause, "Expect alert %d!", exp_alert);

    // Clear alert cause register
    CHECK_DIF_OK(dif_alert_handler_alert_acknowledge(
        &alert_handler, exp_alert));
  }
}

bool test_main(void) {
  init_peripherals();
  alert_handler_config();
  trigger_alert_test();
  return true;
}
