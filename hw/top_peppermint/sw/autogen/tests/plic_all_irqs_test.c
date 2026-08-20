// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
// clang-format off
//
// ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------//
// PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
// util/topgen.py -t hw/top_peppermint/data/top_peppermint.hjson
//                -o hw/top_peppermint/
#include <limits.h>

// This test should avoid otp_ctrl interrupts in rom_ext, since the rom
// extension configures CSR accesses to OTP and AST to become illegal.
//
// This test is getting too big so we need to split it up. To do so,
// each peripheral is given an ID (according to their alphabetical order)
// and we define TEST_MIN_IRQ_PERIPHERAL and TEST_MAX_IRQ_PERIPHERAL to
// choose which ones are being tested.

#ifndef TEST_MIN_IRQ_PERIPHERAL
#define TEST_MIN_IRQ_PERIPHERAL 0
#endif

#ifndef TEST_MAX_IRQ_PERIPHERAL
#define TEST_MAX_IRQ_PERIPHERAL 13
#endif

#include "sw/device/lib/arch/boot_stage.h"
#include "sw/device/lib/base/csr.h"
#include "sw/device/lib/base/mmio.h"
#include "sw/device/lib/dif/autogen/dif_alert_handler_autogen.h"
#include "sw/device/lib/dif/autogen/dif_csrng_autogen.h"
#include "sw/device/lib/dif/autogen/dif_dma_autogen.h"
#include "sw/device/lib/dif/autogen/dif_edn_autogen.h"
#include "sw/device/lib/dif/autogen/dif_entropy_src_autogen.h"
#include "sw/device/lib/dif/autogen/dif_hmac_autogen.h"
#include "sw/device/lib/dif/autogen/dif_keymgr_dpe_autogen.h"
#include "sw/device/lib/dif/autogen/dif_kmac_autogen.h"
#include "sw/device/lib/dif/autogen/dif_mbx_autogen.h"
#include "sw/device/lib/dif/autogen/dif_otbn_autogen.h"
#include "sw/device/lib/dif/autogen/dif_otp_ctrl_autogen.h"
#include "sw/device/lib/dif/autogen/dif_pwrmgr_autogen.h"
#include "sw/device/lib/dif/autogen/dif_rv_plic_autogen.h"
#include "sw/device/lib/dif/autogen/dif_rv_timer_autogen.h"
#include "sw/device/lib/runtime/ibex.h"
#include "sw/device/lib/runtime/irq.h"
#include "sw/device/lib/runtime/log.h"
#include "sw/device/lib/testing/rv_plic_testutils.h"
#include "sw/device/lib/testing/test_framework/check.h"
#include "sw/device/lib/testing/test_framework/ottf_main.h"
#include "sw/device/lib/testing/test_framework/status.h"

#include "hw/top_peppermint/sw/autogen/top_peppermint.h"

#if TEST_MIN_IRQ_PERIPHERAL <= 0 && 0 < TEST_MAX_IRQ_PERIPHERAL
static dif_alert_handler_t alert_handler;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 1 && 1 < TEST_MAX_IRQ_PERIPHERAL
static dif_csrng_t csrng;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 2 && 2 < TEST_MAX_IRQ_PERIPHERAL
static dif_dma_t dma;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 3 && 3 < TEST_MAX_IRQ_PERIPHERAL
static dif_edn_t edn0;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 3 && 3 < TEST_MAX_IRQ_PERIPHERAL
static dif_edn_t edn1;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 4 && 4 < TEST_MAX_IRQ_PERIPHERAL
static dif_entropy_src_t entropy_src;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 5 && 5 < TEST_MAX_IRQ_PERIPHERAL
static dif_hmac_t hmac;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 6 && 6 < TEST_MAX_IRQ_PERIPHERAL
static dif_keymgr_dpe_t keymgr_dpe;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 7 && 7 < TEST_MAX_IRQ_PERIPHERAL
static dif_kmac_t kmac;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 8 && 8 < TEST_MAX_IRQ_PERIPHERAL
static dif_mbx_t mbx0;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 8 && 8 < TEST_MAX_IRQ_PERIPHERAL
static dif_mbx_t mbx1;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 9 && 9 < TEST_MAX_IRQ_PERIPHERAL
static dif_otbn_t otbn;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 10 && 10 < TEST_MAX_IRQ_PERIPHERAL
static dif_otp_ctrl_t otp_ctrl;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 11 && 11 < TEST_MAX_IRQ_PERIPHERAL
static dif_pwrmgr_t pwrmgr;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 12 && 12 < TEST_MAX_IRQ_PERIPHERAL
static dif_rv_timer_t rv_timer;
#endif

static dif_rv_plic_t plic;
static const top_peppermint_plic_target_t kHart = kTopPeppermintPlicTargetIbex0;

/**
 * Flag indicating which peripheral is under test.
 *
 * Declared volatile because it is referenced in the main program flow as well
 * as the ISR.
 */
static volatile top_peppermint_plic_peripheral_t peripheral_expected;

/**
 * Flags indicating the IRQ expected to have triggered and serviced within the
 * peripheral.
 *
 * Declared volatile because it is referenced in the main program flow as well
 * as the ISR.
 */

#if TEST_MIN_IRQ_PERIPHERAL <= 0 && 0 < TEST_MAX_IRQ_PERIPHERAL
static volatile dif_alert_handler_irq_t alert_handler_irq_expected;
static volatile dif_alert_handler_irq_t alert_handler_irq_serviced;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 1 && 1 < TEST_MAX_IRQ_PERIPHERAL
static volatile dif_csrng_irq_t csrng_irq_expected;
static volatile dif_csrng_irq_t csrng_irq_serviced;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 2 && 2 < TEST_MAX_IRQ_PERIPHERAL
static volatile dif_dma_irq_t dma_irq_expected;
static volatile dif_dma_irq_t dma_irq_serviced;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 3 && 3 < TEST_MAX_IRQ_PERIPHERAL
static volatile dif_edn_irq_t edn_irq_expected;
static volatile dif_edn_irq_t edn_irq_serviced;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 4 && 4 < TEST_MAX_IRQ_PERIPHERAL
static volatile dif_entropy_src_irq_t entropy_src_irq_expected;
static volatile dif_entropy_src_irq_t entropy_src_irq_serviced;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 5 && 5 < TEST_MAX_IRQ_PERIPHERAL
static volatile dif_hmac_irq_t hmac_irq_expected;
static volatile dif_hmac_irq_t hmac_irq_serviced;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 6 && 6 < TEST_MAX_IRQ_PERIPHERAL
static volatile dif_keymgr_dpe_irq_t keymgr_dpe_irq_expected;
static volatile dif_keymgr_dpe_irq_t keymgr_dpe_irq_serviced;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 7 && 7 < TEST_MAX_IRQ_PERIPHERAL
static volatile dif_kmac_irq_t kmac_irq_expected;
static volatile dif_kmac_irq_t kmac_irq_serviced;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 8 && 8 < TEST_MAX_IRQ_PERIPHERAL
static volatile dif_mbx_irq_t mbx_irq_expected;
static volatile dif_mbx_irq_t mbx_irq_serviced;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 9 && 9 < TEST_MAX_IRQ_PERIPHERAL
static volatile dif_otbn_irq_t otbn_irq_expected;
static volatile dif_otbn_irq_t otbn_irq_serviced;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 10 && 10 < TEST_MAX_IRQ_PERIPHERAL
static volatile dif_otp_ctrl_irq_t otp_ctrl_irq_expected;
static volatile dif_otp_ctrl_irq_t otp_ctrl_irq_serviced;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 11 && 11 < TEST_MAX_IRQ_PERIPHERAL
static volatile dif_pwrmgr_irq_t pwrmgr_irq_expected;
static volatile dif_pwrmgr_irq_t pwrmgr_irq_serviced;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 12 && 12 < TEST_MAX_IRQ_PERIPHERAL
static volatile dif_rv_timer_irq_t rv_timer_irq_expected;
static volatile dif_rv_timer_irq_t rv_timer_irq_serviced;
#endif

/**
 * Provides external IRQ handling for this test.
 *
 * This function overrides the default OTTF external ISR.
 *
 * For each IRQ, it performs the following:
 * 1. Claims the IRQ fired (finds PLIC IRQ index).
 * 2. Checks that the index belongs to the expected peripheral.
 * 3. Checks that the correct and the only IRQ from the expected peripheral
 *    triggered.
 * 4. Clears the IRQ at the peripheral.
 * 5. Completes the IRQ service at PLIC.
 */
void ottf_external_isr(uint32_t *exc_info) {
  dif_rv_plic_irq_id_t plic_irq_id;
  CHECK_DIF_OK(dif_rv_plic_irq_claim(&plic, kHart, &plic_irq_id));

  top_peppermint_plic_peripheral_t peripheral = (top_peppermint_plic_peripheral_t)
      top_peppermint_plic_interrupt_for_peripheral[plic_irq_id];
  CHECK(peripheral == peripheral_expected,
        "Interrupt from incorrect peripheral: exp = %d, obs = %d",
        peripheral_expected, peripheral);

  switch (peripheral) {
#if TEST_MIN_IRQ_PERIPHERAL <= 0 && 0 < TEST_MAX_IRQ_PERIPHERAL
    case kTopPeppermintPlicPeripheralAlertHandler: {
      dif_alert_handler_irq_t irq =
          (dif_alert_handler_irq_t)(plic_irq_id -
                                    (dif_rv_plic_irq_id_t)
                                        kTopPeppermintPlicIrqIdAlertHandlerClassa);
      CHECK(irq == alert_handler_irq_expected,
            "Incorrect alert_handler IRQ triggered: exp = %d, obs = %d",
            alert_handler_irq_expected, irq);
      alert_handler_irq_serviced = irq;

      dif_alert_handler_irq_state_snapshot_t snapshot;
      CHECK_DIF_OK(dif_alert_handler_irq_get_state(&alert_handler, &snapshot));
      CHECK(snapshot == (dif_alert_handler_irq_state_snapshot_t)(1 << irq),
            "Only alert_handler IRQ %d expected to fire. Actual interrupt "
            "status = %x",
            irq, snapshot);

      CHECK_DIF_OK(dif_alert_handler_irq_acknowledge(&alert_handler, irq));
      break;
    }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 1 && 1 < TEST_MAX_IRQ_PERIPHERAL
    case kTopPeppermintPlicPeripheralCsrng: {
      dif_csrng_irq_t irq =
          (dif_csrng_irq_t)(plic_irq_id -
                            (dif_rv_plic_irq_id_t)
                                kTopPeppermintPlicIrqIdCsrngCsCmdReqDone);
      CHECK(irq == csrng_irq_expected,
            "Incorrect csrng IRQ triggered: exp = %d, obs = %d",
            csrng_irq_expected, irq);
      csrng_irq_serviced = irq;

      dif_csrng_irq_state_snapshot_t snapshot;
      CHECK_DIF_OK(dif_csrng_irq_get_state(&csrng, &snapshot));
      CHECK(snapshot == (dif_csrng_irq_state_snapshot_t)(1 << irq),
            "Only csrng IRQ %d expected to fire. Actual interrupt "
            "status = %x",
            irq, snapshot);

      CHECK_DIF_OK(dif_csrng_irq_acknowledge(&csrng, irq));
      break;
    }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 2 && 2 < TEST_MAX_IRQ_PERIPHERAL
    case kTopPeppermintPlicPeripheralDma: {
      dif_dma_irq_t irq =
          (dif_dma_irq_t)(plic_irq_id -
                          (dif_rv_plic_irq_id_t)
                              kTopPeppermintPlicIrqIdDmaDmaDone);
      CHECK(irq == dma_irq_expected,
            "Incorrect dma IRQ triggered: exp = %d, obs = %d",
            dma_irq_expected, irq);
      dma_irq_serviced = irq;

      dif_dma_irq_state_snapshot_t snapshot;
      CHECK_DIF_OK(dif_dma_irq_get_state(&dma, &snapshot));
      CHECK(snapshot == (dif_dma_irq_state_snapshot_t)(1 << irq),
            "Only dma IRQ %d expected to fire. Actual interrupt "
            "status = %x",
            irq, snapshot);

      if (0x7 & (1 << irq)) {
        // We do not acknowledge status type interrupt at the IP side, but we
        // need to clear the test force register.
        CHECK_DIF_OK(dif_dma_irq_force(&dma, irq, false));
        // In case this status interrupt is asserted by default, we also
        // disable it at this point so that it does not interfere with the
        // rest of the test.
        if ((0x0 & (1 << irq))) {
          CHECK_DIF_OK(dif_dma_irq_set_enabled(&dma, irq, false));
        }
      } else {
        // We acknowledge event type interrupt.
        CHECK_DIF_OK(dif_dma_irq_acknowledge(&dma, irq));
      }
      break;
    }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 3 && 3 < TEST_MAX_IRQ_PERIPHERAL
    case kTopPeppermintPlicPeripheralEdn0: {
      dif_edn_irq_t irq =
          (dif_edn_irq_t)(plic_irq_id -
                          (dif_rv_plic_irq_id_t)
                              kTopPeppermintPlicIrqIdEdn0EdnCmdReqDone);
      CHECK(irq == edn_irq_expected,
            "Incorrect edn0 IRQ triggered: exp = %d, obs = %d",
            edn_irq_expected, irq);
      edn_irq_serviced = irq;

      dif_edn_irq_state_snapshot_t snapshot;
      CHECK_DIF_OK(dif_edn_irq_get_state(&edn0, &snapshot));
      CHECK(snapshot == (dif_edn_irq_state_snapshot_t)(1 << irq),
            "Only edn0 IRQ %d expected to fire. Actual interrupt "
            "status = %x",
            irq, snapshot);

      CHECK_DIF_OK(dif_edn_irq_acknowledge(&edn0, irq));
      break;
    }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 3 && 3 < TEST_MAX_IRQ_PERIPHERAL
    case kTopPeppermintPlicPeripheralEdn1: {
      dif_edn_irq_t irq =
          (dif_edn_irq_t)(plic_irq_id -
                          (dif_rv_plic_irq_id_t)
                              kTopPeppermintPlicIrqIdEdn1EdnCmdReqDone);
      CHECK(irq == edn_irq_expected,
            "Incorrect edn1 IRQ triggered: exp = %d, obs = %d",
            edn_irq_expected, irq);
      edn_irq_serviced = irq;

      dif_edn_irq_state_snapshot_t snapshot;
      CHECK_DIF_OK(dif_edn_irq_get_state(&edn1, &snapshot));
      CHECK(snapshot == (dif_edn_irq_state_snapshot_t)(1 << irq),
            "Only edn1 IRQ %d expected to fire. Actual interrupt "
            "status = %x",
            irq, snapshot);

      CHECK_DIF_OK(dif_edn_irq_acknowledge(&edn1, irq));
      break;
    }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 4 && 4 < TEST_MAX_IRQ_PERIPHERAL
    case kTopPeppermintPlicPeripheralEntropySrc: {
      dif_entropy_src_irq_t irq =
          (dif_entropy_src_irq_t)(plic_irq_id -
                                  (dif_rv_plic_irq_id_t)
                                      kTopPeppermintPlicIrqIdEntropySrcEsEntropyValid);
      CHECK(irq == entropy_src_irq_expected,
            "Incorrect entropy_src IRQ triggered: exp = %d, obs = %d",
            entropy_src_irq_expected, irq);
      entropy_src_irq_serviced = irq;

      dif_entropy_src_irq_state_snapshot_t snapshot;
      CHECK_DIF_OK(dif_entropy_src_irq_get_state(&entropy_src, &snapshot));
      CHECK(snapshot == (dif_entropy_src_irq_state_snapshot_t)(1 << irq),
            "Only entropy_src IRQ %d expected to fire. Actual interrupt "
            "status = %x",
            irq, snapshot);

      CHECK_DIF_OK(dif_entropy_src_irq_acknowledge(&entropy_src, irq));
      break;
    }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 5 && 5 < TEST_MAX_IRQ_PERIPHERAL
    case kTopPeppermintPlicPeripheralHmac: {
      dif_hmac_irq_t irq =
          (dif_hmac_irq_t)(plic_irq_id -
                           (dif_rv_plic_irq_id_t)
                               kTopPeppermintPlicIrqIdHmacHmacDone);
      CHECK(irq == hmac_irq_expected,
            "Incorrect hmac IRQ triggered: exp = %d, obs = %d",
            hmac_irq_expected, irq);
      hmac_irq_serviced = irq;

      dif_hmac_irq_state_snapshot_t snapshot;
      CHECK_DIF_OK(dif_hmac_irq_get_state(&hmac, &snapshot));
      CHECK(snapshot == (dif_hmac_irq_state_snapshot_t)(1 << irq),
            "Only hmac IRQ %d expected to fire. Actual interrupt "
            "status = %x",
            irq, snapshot);

      if (0x2 & (1 << irq)) {
        // We do not acknowledge status type interrupt at the IP side, but we
        // need to clear the test force register.
        CHECK_DIF_OK(dif_hmac_irq_force(&hmac, irq, false));
        // In case this status interrupt is asserted by default, we also
        // disable it at this point so that it does not interfere with the
        // rest of the test.
        if ((0x0 & (1 << irq))) {
          CHECK_DIF_OK(dif_hmac_irq_set_enabled(&hmac, irq, false));
        }
      } else {
        // We acknowledge event type interrupt.
        CHECK_DIF_OK(dif_hmac_irq_acknowledge(&hmac, irq));
      }
      break;
    }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 6 && 6 < TEST_MAX_IRQ_PERIPHERAL
    case kTopPeppermintPlicPeripheralKeymgrDpe: {
      dif_keymgr_dpe_irq_t irq =
          (dif_keymgr_dpe_irq_t)(plic_irq_id -
                                 (dif_rv_plic_irq_id_t)
                                     kTopPeppermintPlicIrqIdKeymgrDpeOpDone);
      CHECK(irq == keymgr_dpe_irq_expected,
            "Incorrect keymgr_dpe IRQ triggered: exp = %d, obs = %d",
            keymgr_dpe_irq_expected, irq);
      keymgr_dpe_irq_serviced = irq;

      dif_keymgr_dpe_irq_state_snapshot_t snapshot;
      CHECK_DIF_OK(dif_keymgr_dpe_irq_get_state(&keymgr_dpe, &snapshot));
      CHECK(snapshot == (dif_keymgr_dpe_irq_state_snapshot_t)(1 << irq),
            "Only keymgr_dpe IRQ %d expected to fire. Actual interrupt "
            "status = %x",
            irq, snapshot);

      CHECK_DIF_OK(dif_keymgr_dpe_irq_acknowledge(&keymgr_dpe, irq));
      break;
    }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 7 && 7 < TEST_MAX_IRQ_PERIPHERAL
    case kTopPeppermintPlicPeripheralKmac: {
      dif_kmac_irq_t irq =
          (dif_kmac_irq_t)(plic_irq_id -
                           (dif_rv_plic_irq_id_t)
                               kTopPeppermintPlicIrqIdKmacKmacDone);
      CHECK(irq == kmac_irq_expected,
            "Incorrect kmac IRQ triggered: exp = %d, obs = %d",
            kmac_irq_expected, irq);
      kmac_irq_serviced = irq;

      dif_kmac_irq_state_snapshot_t snapshot;
      CHECK_DIF_OK(dif_kmac_irq_get_state(&kmac, &snapshot));
      CHECK(snapshot == (dif_kmac_irq_state_snapshot_t)(1 << irq),
            "Only kmac IRQ %d expected to fire. Actual interrupt "
            "status = %x",
            irq, snapshot);

      if (0x2 & (1 << irq)) {
        // We do not acknowledge status type interrupt at the IP side, but we
        // need to clear the test force register.
        CHECK_DIF_OK(dif_kmac_irq_force(&kmac, irq, false));
        // In case this status interrupt is asserted by default, we also
        // disable it at this point so that it does not interfere with the
        // rest of the test.
        if ((0x0 & (1 << irq))) {
          CHECK_DIF_OK(dif_kmac_irq_set_enabled(&kmac, irq, false));
        }
      } else {
        // We acknowledge event type interrupt.
        CHECK_DIF_OK(dif_kmac_irq_acknowledge(&kmac, irq));
      }
      break;
    }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 8 && 8 < TEST_MAX_IRQ_PERIPHERAL
    case kTopPeppermintPlicPeripheralMbx0: {
      dif_mbx_irq_t irq =
          (dif_mbx_irq_t)(plic_irq_id -
                          (dif_rv_plic_irq_id_t)
                              kTopPeppermintPlicIrqIdMbx0MbxReady);
      CHECK(irq == mbx_irq_expected,
            "Incorrect mbx0 IRQ triggered: exp = %d, obs = %d",
            mbx_irq_expected, irq);
      mbx_irq_serviced = irq;

      dif_mbx_irq_state_snapshot_t snapshot;
      CHECK_DIF_OK(dif_mbx_irq_get_state(&mbx0, &snapshot));
      CHECK(snapshot == (dif_mbx_irq_state_snapshot_t)(1 << irq),
            "Only mbx0 IRQ %d expected to fire. Actual interrupt "
            "status = %x",
            irq, snapshot);

      CHECK_DIF_OK(dif_mbx_irq_acknowledge(&mbx0, irq));
      break;
    }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 8 && 8 < TEST_MAX_IRQ_PERIPHERAL
    case kTopPeppermintPlicPeripheralMbx1: {
      dif_mbx_irq_t irq =
          (dif_mbx_irq_t)(plic_irq_id -
                          (dif_rv_plic_irq_id_t)
                              kTopPeppermintPlicIrqIdMbx1MbxReady);
      CHECK(irq == mbx_irq_expected,
            "Incorrect mbx1 IRQ triggered: exp = %d, obs = %d",
            mbx_irq_expected, irq);
      mbx_irq_serviced = irq;

      dif_mbx_irq_state_snapshot_t snapshot;
      CHECK_DIF_OK(dif_mbx_irq_get_state(&mbx1, &snapshot));
      CHECK(snapshot == (dif_mbx_irq_state_snapshot_t)(1 << irq),
            "Only mbx1 IRQ %d expected to fire. Actual interrupt "
            "status = %x",
            irq, snapshot);

      CHECK_DIF_OK(dif_mbx_irq_acknowledge(&mbx1, irq));
      break;
    }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 9 && 9 < TEST_MAX_IRQ_PERIPHERAL
    case kTopPeppermintPlicPeripheralOtbn: {
      dif_otbn_irq_t irq =
          (dif_otbn_irq_t)(plic_irq_id -
                           (dif_rv_plic_irq_id_t)
                               kTopPeppermintPlicIrqIdOtbnDone);
      CHECK(irq == otbn_irq_expected,
            "Incorrect otbn IRQ triggered: exp = %d, obs = %d",
            otbn_irq_expected, irq);
      otbn_irq_serviced = irq;

      dif_otbn_irq_state_snapshot_t snapshot;
      CHECK_DIF_OK(dif_otbn_irq_get_state(&otbn, &snapshot));
      CHECK(snapshot == (dif_otbn_irq_state_snapshot_t)(1 << irq),
            "Only otbn IRQ %d expected to fire. Actual interrupt "
            "status = %x",
            irq, snapshot);

      CHECK_DIF_OK(dif_otbn_irq_acknowledge(&otbn, irq));
      break;
    }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 10 && 10 < TEST_MAX_IRQ_PERIPHERAL
    case kTopPeppermintPlicPeripheralOtpCtrl: {
      dif_otp_ctrl_irq_t irq =
          (dif_otp_ctrl_irq_t)(plic_irq_id -
                               (dif_rv_plic_irq_id_t)
                                   kTopPeppermintPlicIrqIdOtpCtrlOtpOperationDone);
      CHECK(irq == otp_ctrl_irq_expected,
            "Incorrect otp_ctrl IRQ triggered: exp = %d, obs = %d",
            otp_ctrl_irq_expected, irq);
      otp_ctrl_irq_serviced = irq;

      dif_otp_ctrl_irq_state_snapshot_t snapshot;
      CHECK_DIF_OK(dif_otp_ctrl_irq_get_state(&otp_ctrl, &snapshot));
      CHECK(snapshot == (dif_otp_ctrl_irq_state_snapshot_t)(1 << irq),
            "Only otp_ctrl IRQ %d expected to fire. Actual interrupt "
            "status = %x",
            irq, snapshot);

      CHECK_DIF_OK(dif_otp_ctrl_irq_acknowledge(&otp_ctrl, irq));
      break;
    }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 11 && 11 < TEST_MAX_IRQ_PERIPHERAL
    case kTopPeppermintPlicPeripheralPwrmgr: {
      dif_pwrmgr_irq_t irq =
          (dif_pwrmgr_irq_t)(plic_irq_id -
                             (dif_rv_plic_irq_id_t)
                                 kTopPeppermintPlicIrqIdPwrmgrWakeup);
      CHECK(irq == pwrmgr_irq_expected,
            "Incorrect pwrmgr IRQ triggered: exp = %d, obs = %d",
            pwrmgr_irq_expected, irq);
      pwrmgr_irq_serviced = irq;

      dif_pwrmgr_irq_state_snapshot_t snapshot;
      CHECK_DIF_OK(dif_pwrmgr_irq_get_state(&pwrmgr, &snapshot));
      CHECK(snapshot == (dif_pwrmgr_irq_state_snapshot_t)(1 << irq),
            "Only pwrmgr IRQ %d expected to fire. Actual interrupt "
            "status = %x",
            irq, snapshot);

      CHECK_DIF_OK(dif_pwrmgr_irq_acknowledge(&pwrmgr, irq));
      break;
    }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 12 && 12 < TEST_MAX_IRQ_PERIPHERAL
    case kTopPeppermintPlicPeripheralRvTimer: {
      dif_rv_timer_irq_t irq =
          (dif_rv_timer_irq_t)(plic_irq_id -
                               (dif_rv_plic_irq_id_t)
                                   kTopPeppermintPlicIrqIdRvTimerTimerExpiredHart0Timer0);
      CHECK(irq == rv_timer_irq_expected,
            "Incorrect rv_timer IRQ triggered: exp = %d, obs = %d",
            rv_timer_irq_expected, irq);
      rv_timer_irq_serviced = irq;

      dif_rv_timer_irq_state_snapshot_t snapshot;
      CHECK_DIF_OK(dif_rv_timer_irq_get_state(&rv_timer, kHart, &snapshot));
      CHECK(snapshot == (dif_rv_timer_irq_state_snapshot_t)(1 << irq),
            "Only rv_timer IRQ %d expected to fire. Actual interrupt "
            "status = %x",
            irq, snapshot);

      CHECK_DIF_OK(dif_rv_timer_irq_acknowledge(&rv_timer, irq));
      break;
    }
#endif

    default:
      LOG_FATAL("ISR is not implemented!");
      test_status_set(kTestStatusFailed);
  }
  // Complete the IRQ at PLIC.
  CHECK_DIF_OK(dif_rv_plic_irq_complete(&plic, kHart, plic_irq_id));
}

/**
 * Initializes the handles to all peripherals.
 */
static void peripherals_init(void) {
  mmio_region_t base_addr;

#if TEST_MIN_IRQ_PERIPHERAL <= 0 && 0 < TEST_MAX_IRQ_PERIPHERAL
  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_ALERT_HANDLER_BASE_ADDR);
  CHECK_DIF_OK(dif_alert_handler_init(base_addr, &alert_handler));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 1 && 1 < TEST_MAX_IRQ_PERIPHERAL
  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_CSRNG_BASE_ADDR);
  CHECK_DIF_OK(dif_csrng_init(base_addr, &csrng));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 2 && 2 < TEST_MAX_IRQ_PERIPHERAL
  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_DMA_BASE_ADDR);
  CHECK_DIF_OK(dif_dma_init(base_addr, &dma));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 3 && 3 < TEST_MAX_IRQ_PERIPHERAL
  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_EDN0_BASE_ADDR);
  CHECK_DIF_OK(dif_edn_init(base_addr, &edn0));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 3 && 3 < TEST_MAX_IRQ_PERIPHERAL
  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_EDN1_BASE_ADDR);
  CHECK_DIF_OK(dif_edn_init(base_addr, &edn1));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 4 && 4 < TEST_MAX_IRQ_PERIPHERAL
  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_ENTROPY_SRC_BASE_ADDR);
  CHECK_DIF_OK(dif_entropy_src_init(base_addr, &entropy_src));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 5 && 5 < TEST_MAX_IRQ_PERIPHERAL
  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_HMAC_BASE_ADDR);
  CHECK_DIF_OK(dif_hmac_init(base_addr, &hmac));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 6 && 6 < TEST_MAX_IRQ_PERIPHERAL
  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_KEYMGR_DPE_BASE_ADDR);
  CHECK_DIF_OK(dif_keymgr_dpe_init(base_addr, &keymgr_dpe));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 7 && 7 < TEST_MAX_IRQ_PERIPHERAL
  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_KMAC_BASE_ADDR);
  CHECK_DIF_OK(dif_kmac_init(base_addr, &kmac));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 8 && 8 < TEST_MAX_IRQ_PERIPHERAL
  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_MBX0_CORE_BASE_ADDR);
  CHECK_DIF_OK(dif_mbx_init(base_addr, &mbx0));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 8 && 8 < TEST_MAX_IRQ_PERIPHERAL
  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_MBX1_CORE_BASE_ADDR);
  CHECK_DIF_OK(dif_mbx_init(base_addr, &mbx1));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 9 && 9 < TEST_MAX_IRQ_PERIPHERAL
  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_OTBN_BASE_ADDR);
  CHECK_DIF_OK(dif_otbn_init(base_addr, &otbn));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 10 && 10 < TEST_MAX_IRQ_PERIPHERAL
  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_OTP_CTRL_CORE_BASE_ADDR);
  CHECK_DIF_OK(dif_otp_ctrl_init(base_addr, &otp_ctrl));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 11 && 11 < TEST_MAX_IRQ_PERIPHERAL
  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_PWRMGR_BASE_ADDR);
  CHECK_DIF_OK(dif_pwrmgr_init(base_addr, &pwrmgr));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 12 && 12 < TEST_MAX_IRQ_PERIPHERAL
  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_RV_TIMER_BASE_ADDR);
  CHECK_DIF_OK(dif_rv_timer_init(base_addr, &rv_timer));
#endif

  base_addr = mmio_region_from_addr(TOP_PEPPERMINT_RV_PLIC_BASE_ADDR);
  CHECK_DIF_OK(dif_rv_plic_init(base_addr, &plic));
}

/**
 * Clears pending IRQs in all peripherals.
 */
static void peripheral_irqs_clear(void) {
#if TEST_MIN_IRQ_PERIPHERAL <= 0 && 0 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_alert_handler_irq_acknowledge_all(&alert_handler));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 1 && 1 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_csrng_irq_acknowledge_all(&csrng));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 2 && 2 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_dma_irq_acknowledge_all(&dma));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 3 && 3 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_edn_irq_acknowledge_all(&edn0));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 3 && 3 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_edn_irq_acknowledge_all(&edn1));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 4 && 4 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_entropy_src_irq_acknowledge_all(&entropy_src));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 5 && 5 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_hmac_irq_acknowledge_all(&hmac));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 6 && 6 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_keymgr_dpe_irq_acknowledge_all(&keymgr_dpe));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 7 && 7 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_kmac_irq_acknowledge_all(&kmac));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 8 && 8 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_mbx_irq_acknowledge_all(&mbx0));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 8 && 8 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_mbx_irq_acknowledge_all(&mbx1));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 9 && 9 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_otbn_irq_acknowledge_all(&otbn));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 10 && 10 < TEST_MAX_IRQ_PERIPHERAL
  if (kBootStage != kBootStageOwner) {
    CHECK_DIF_OK(dif_otp_ctrl_irq_acknowledge_all(&otp_ctrl));
  }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 11 && 11 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_pwrmgr_irq_acknowledge_all(&pwrmgr));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 12 && 12 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_rv_timer_irq_acknowledge_all(&rv_timer, kHart));
#endif
}

/**
 * Enables all IRQs in all peripherals.
 */
static void peripheral_irqs_enable(void) {
#if TEST_MIN_IRQ_PERIPHERAL <= 0 && 0 < TEST_MAX_IRQ_PERIPHERAL
  dif_alert_handler_irq_state_snapshot_t alert_handler_irqs =
      (dif_alert_handler_irq_state_snapshot_t)0xffffffff;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 1 && 1 < TEST_MAX_IRQ_PERIPHERAL
  dif_csrng_irq_state_snapshot_t csrng_irqs =
      (dif_csrng_irq_state_snapshot_t)0xffffffff;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 2 && 2 < TEST_MAX_IRQ_PERIPHERAL
  dif_dma_irq_state_snapshot_t dma_irqs =
      (dif_dma_irq_state_snapshot_t)0xffffffff;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 3 && 3 < TEST_MAX_IRQ_PERIPHERAL
  dif_edn_irq_state_snapshot_t edn_irqs =
      (dif_edn_irq_state_snapshot_t)0xffffffff;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 4 && 4 < TEST_MAX_IRQ_PERIPHERAL
  dif_entropy_src_irq_state_snapshot_t entropy_src_irqs =
      (dif_entropy_src_irq_state_snapshot_t)0xffffffff;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 5 && 5 < TEST_MAX_IRQ_PERIPHERAL
  dif_hmac_irq_state_snapshot_t hmac_irqs =
      (dif_hmac_irq_state_snapshot_t)0xffffffff;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 6 && 6 < TEST_MAX_IRQ_PERIPHERAL
  dif_keymgr_dpe_irq_state_snapshot_t keymgr_dpe_irqs =
      (dif_keymgr_dpe_irq_state_snapshot_t)0xffffffff;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 7 && 7 < TEST_MAX_IRQ_PERIPHERAL
  dif_kmac_irq_state_snapshot_t kmac_irqs =
      (dif_kmac_irq_state_snapshot_t)0xffffffff;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 8 && 8 < TEST_MAX_IRQ_PERIPHERAL
  dif_mbx_irq_state_snapshot_t mbx_irqs =
      (dif_mbx_irq_state_snapshot_t)0xffffffff;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 9 && 9 < TEST_MAX_IRQ_PERIPHERAL
  dif_otbn_irq_state_snapshot_t otbn_irqs =
      (dif_otbn_irq_state_snapshot_t)0xffffffff;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 10 && 10 < TEST_MAX_IRQ_PERIPHERAL
  dif_otp_ctrl_irq_state_snapshot_t otp_ctrl_irqs =
      (dif_otp_ctrl_irq_state_snapshot_t)0xffffffff;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 11 && 11 < TEST_MAX_IRQ_PERIPHERAL
  dif_pwrmgr_irq_state_snapshot_t pwrmgr_irqs =
      (dif_pwrmgr_irq_state_snapshot_t)0xffffffff;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 12 && 12 < TEST_MAX_IRQ_PERIPHERAL
  dif_rv_timer_irq_state_snapshot_t rv_timer_irqs =
      (dif_rv_timer_irq_state_snapshot_t)0xffffffff;
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 0 && 0 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_alert_handler_irq_restore_all(&alert_handler, &alert_handler_irqs));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 1 && 1 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_csrng_irq_restore_all(&csrng, &csrng_irqs));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 2 && 2 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_dma_irq_restore_all(&dma, &dma_irqs));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 3 && 3 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_edn_irq_restore_all(&edn0, &edn_irqs));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 3 && 3 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_edn_irq_restore_all(&edn1, &edn_irqs));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 4 && 4 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_entropy_src_irq_restore_all(&entropy_src, &entropy_src_irqs));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 5 && 5 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_hmac_irq_restore_all(&hmac, &hmac_irqs));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 6 && 6 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_keymgr_dpe_irq_restore_all(&keymgr_dpe, &keymgr_dpe_irqs));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 7 && 7 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_kmac_irq_restore_all(&kmac, &kmac_irqs));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 8 && 8 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_mbx_irq_restore_all(&mbx0, &mbx_irqs));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 8 && 8 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_mbx_irq_restore_all(&mbx1, &mbx_irqs));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 9 && 9 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_otbn_irq_restore_all(&otbn, &otbn_irqs));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 10 && 10 < TEST_MAX_IRQ_PERIPHERAL
  if (kBootStage != kBootStageOwner) {
    CHECK_DIF_OK(dif_otp_ctrl_irq_restore_all(&otp_ctrl, &otp_ctrl_irqs));
  }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 11 && 11 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_pwrmgr_irq_restore_all(&pwrmgr, &pwrmgr_irqs));
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 12 && 12 < TEST_MAX_IRQ_PERIPHERAL
  CHECK_DIF_OK(dif_rv_timer_irq_restore_all(&rv_timer, kHart, &rv_timer_irqs));
#endif
}

/**
 * Triggers all IRQs in all peripherals one by one.
 *
 * Walks through all instances of all peripherals and triggers an interrupt one
 * by one, by forcing with the `intr_test` CSR. On trigger, the CPU instantly
 * jumps into the ISR. The main flow of execution thus proceeds to check that
 * the correct IRQ was serviced immediately. The ISR, in turn checks if the
 * expected IRQ from the expected peripheral triggered.
 */
static void peripheral_irqs_trigger(void) {
  unsigned int status_default_mask;
  // Depending on the build configuration, this variable may show up as unused
  // in the clang linter. This statement waives that error.
  (void)status_default_mask;

#if TEST_MIN_IRQ_PERIPHERAL <= 0 && 0 < TEST_MAX_IRQ_PERIPHERAL
  peripheral_expected = kTopPeppermintPlicPeripheralAlertHandler;
  for (dif_alert_handler_irq_t irq = kDifAlertHandlerIrqClassa; irq <= kDifAlertHandlerIrqClassd;
       ++irq) {
    alert_handler_irq_expected = irq;
    LOG_INFO("Triggering alert_handler IRQ %d.", irq);
    CHECK_DIF_OK(dif_alert_handler_irq_force(&alert_handler, irq, true));

    // This avoids a race where *irq_serviced is read before
    // entering the ISR.
    IBEX_SPIN_FOR(alert_handler_irq_serviced == irq, 1);
    LOG_INFO("IRQ %d from alert_handler is serviced.", irq);
  }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 1 && 1 < TEST_MAX_IRQ_PERIPHERAL
  peripheral_expected = kTopPeppermintPlicPeripheralCsrng;
  for (dif_csrng_irq_t irq = kDifCsrngIrqCsCmdReqDone; irq <= kDifCsrngIrqCsFatalErr;
       ++irq) {
    csrng_irq_expected = irq;
    LOG_INFO("Triggering csrng IRQ %d.", irq);
    CHECK_DIF_OK(dif_csrng_irq_force(&csrng, irq, true));

    // This avoids a race where *irq_serviced is read before
    // entering the ISR.
    IBEX_SPIN_FOR(csrng_irq_serviced == irq, 1);
    LOG_INFO("IRQ %d from csrng is serviced.", irq);
  }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 2 && 2 < TEST_MAX_IRQ_PERIPHERAL
  peripheral_expected = kTopPeppermintPlicPeripheralDma;
  status_default_mask = 0x0;
  for (dif_dma_irq_t irq = kDifDmaIrqDmaDone; irq <= kDifDmaIrqDmaError;
       ++irq) {
    dma_irq_expected = irq;
    LOG_INFO("Triggering dma IRQ %d.", irq);
    CHECK_DIF_OK(dif_dma_irq_force(&dma, irq, true));

    // In this case, the interrupt has not been enabled yet because that would
    // interfere with testing other interrupts. We enable it here and let the
    // interrupt handler disable it again.
    if ((status_default_mask & 0x1)) {
      CHECK_DIF_OK(dif_dma_irq_set_enabled(&dma, irq, true));
    }
    status_default_mask >>= 1;

    // This avoids a race where *irq_serviced is read before
    // entering the ISR.
    IBEX_SPIN_FOR(dma_irq_serviced == irq, 1);
    LOG_INFO("IRQ %d from dma is serviced.", irq);
  }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 3 && 3 < TEST_MAX_IRQ_PERIPHERAL
  peripheral_expected = kTopPeppermintPlicPeripheralEdn0;
  for (dif_edn_irq_t irq = kDifEdnIrqEdnCmdReqDone; irq <= kDifEdnIrqEdnFatalErr;
       ++irq) {
    edn_irq_expected = irq;
    LOG_INFO("Triggering edn0 IRQ %d.", irq);
    CHECK_DIF_OK(dif_edn_irq_force(&edn0, irq, true));

    // This avoids a race where *irq_serviced is read before
    // entering the ISR.
    IBEX_SPIN_FOR(edn_irq_serviced == irq, 1);
    LOG_INFO("IRQ %d from edn0 is serviced.", irq);
  }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 3 && 3 < TEST_MAX_IRQ_PERIPHERAL
  peripheral_expected = kTopPeppermintPlicPeripheralEdn1;
  for (dif_edn_irq_t irq = kDifEdnIrqEdnCmdReqDone; irq <= kDifEdnIrqEdnFatalErr;
       ++irq) {
    edn_irq_expected = irq;
    LOG_INFO("Triggering edn1 IRQ %d.", irq);
    CHECK_DIF_OK(dif_edn_irq_force(&edn1, irq, true));

    // This avoids a race where *irq_serviced is read before
    // entering the ISR.
    IBEX_SPIN_FOR(edn_irq_serviced == irq, 1);
    LOG_INFO("IRQ %d from edn1 is serviced.", irq);
  }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 4 && 4 < TEST_MAX_IRQ_PERIPHERAL
  peripheral_expected = kTopPeppermintPlicPeripheralEntropySrc;
  for (dif_entropy_src_irq_t irq = kDifEntropySrcIrqEsEntropyValid; irq <= kDifEntropySrcIrqEsFatalErr;
       ++irq) {
    entropy_src_irq_expected = irq;
    LOG_INFO("Triggering entropy_src IRQ %d.", irq);
    CHECK_DIF_OK(dif_entropy_src_irq_force(&entropy_src, irq, true));

    // This avoids a race where *irq_serviced is read before
    // entering the ISR.
    IBEX_SPIN_FOR(entropy_src_irq_serviced == irq, 1);
    LOG_INFO("IRQ %d from entropy_src is serviced.", irq);
  }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 5 && 5 < TEST_MAX_IRQ_PERIPHERAL
  peripheral_expected = kTopPeppermintPlicPeripheralHmac;
  status_default_mask = 0x0;
  for (dif_hmac_irq_t irq = kDifHmacIrqHmacDone; irq <= kDifHmacIrqHmacErr;
       ++irq) {
    hmac_irq_expected = irq;
    LOG_INFO("Triggering hmac IRQ %d.", irq);
    CHECK_DIF_OK(dif_hmac_irq_force(&hmac, irq, true));

    // In this case, the interrupt has not been enabled yet because that would
    // interfere with testing other interrupts. We enable it here and let the
    // interrupt handler disable it again.
    if ((status_default_mask & 0x1)) {
      CHECK_DIF_OK(dif_hmac_irq_set_enabled(&hmac, irq, true));
    }
    status_default_mask >>= 1;

    // This avoids a race where *irq_serviced is read before
    // entering the ISR.
    IBEX_SPIN_FOR(hmac_irq_serviced == irq, 1);
    LOG_INFO("IRQ %d from hmac is serviced.", irq);
  }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 6 && 6 < TEST_MAX_IRQ_PERIPHERAL
  peripheral_expected = kTopPeppermintPlicPeripheralKeymgrDpe;
  for (dif_keymgr_dpe_irq_t irq = kDifKeymgrDpeIrqOpDone; irq <= kDifKeymgrDpeIrqOpDone;
       ++irq) {
    keymgr_dpe_irq_expected = irq;
    LOG_INFO("Triggering keymgr_dpe IRQ %d.", irq);
    CHECK_DIF_OK(dif_keymgr_dpe_irq_force(&keymgr_dpe, irq, true));

    // This avoids a race where *irq_serviced is read before
    // entering the ISR.
    IBEX_SPIN_FOR(keymgr_dpe_irq_serviced == irq, 1);
    LOG_INFO("IRQ %d from keymgr_dpe is serviced.", irq);
  }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 7 && 7 < TEST_MAX_IRQ_PERIPHERAL
  peripheral_expected = kTopPeppermintPlicPeripheralKmac;
  status_default_mask = 0x0;
  for (dif_kmac_irq_t irq = kDifKmacIrqKmacDone; irq <= kDifKmacIrqKmacErr;
       ++irq) {
    kmac_irq_expected = irq;
    LOG_INFO("Triggering kmac IRQ %d.", irq);
    CHECK_DIF_OK(dif_kmac_irq_force(&kmac, irq, true));

    // In this case, the interrupt has not been enabled yet because that would
    // interfere with testing other interrupts. We enable it here and let the
    // interrupt handler disable it again.
    if ((status_default_mask & 0x1)) {
      CHECK_DIF_OK(dif_kmac_irq_set_enabled(&kmac, irq, true));
    }
    status_default_mask >>= 1;

    // This avoids a race where *irq_serviced is read before
    // entering the ISR.
    IBEX_SPIN_FOR(kmac_irq_serviced == irq, 1);
    LOG_INFO("IRQ %d from kmac is serviced.", irq);
  }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 8 && 8 < TEST_MAX_IRQ_PERIPHERAL
  peripheral_expected = kTopPeppermintPlicPeripheralMbx0;
  for (dif_mbx_irq_t irq = kDifMbxIrqMbxReady; irq <= kDifMbxIrqMbxError;
       ++irq) {
    mbx_irq_expected = irq;
    LOG_INFO("Triggering mbx0 IRQ %d.", irq);
    CHECK_DIF_OK(dif_mbx_irq_force(&mbx0, irq, true));

    // This avoids a race where *irq_serviced is read before
    // entering the ISR.
    IBEX_SPIN_FOR(mbx_irq_serviced == irq, 1);
    LOG_INFO("IRQ %d from mbx0 is serviced.", irq);
  }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 8 && 8 < TEST_MAX_IRQ_PERIPHERAL
  peripheral_expected = kTopPeppermintPlicPeripheralMbx1;
  for (dif_mbx_irq_t irq = kDifMbxIrqMbxReady; irq <= kDifMbxIrqMbxError;
       ++irq) {
    mbx_irq_expected = irq;
    LOG_INFO("Triggering mbx1 IRQ %d.", irq);
    CHECK_DIF_OK(dif_mbx_irq_force(&mbx1, irq, true));

    // This avoids a race where *irq_serviced is read before
    // entering the ISR.
    IBEX_SPIN_FOR(mbx_irq_serviced == irq, 1);
    LOG_INFO("IRQ %d from mbx1 is serviced.", irq);
  }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 9 && 9 < TEST_MAX_IRQ_PERIPHERAL
  peripheral_expected = kTopPeppermintPlicPeripheralOtbn;
  for (dif_otbn_irq_t irq = kDifOtbnIrqDone; irq <= kDifOtbnIrqDone;
       ++irq) {
    otbn_irq_expected = irq;
    LOG_INFO("Triggering otbn IRQ %d.", irq);
    CHECK_DIF_OK(dif_otbn_irq_force(&otbn, irq, true));

    // This avoids a race where *irq_serviced is read before
    // entering the ISR.
    IBEX_SPIN_FOR(otbn_irq_serviced == irq, 1);
    LOG_INFO("IRQ %d from otbn is serviced.", irq);
  }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 10 && 10 < TEST_MAX_IRQ_PERIPHERAL
  // Skip OTP_CTRL in boot stage owner since ROM_EXT configures all accesses
  // to OTP_CTRL and AST to be illegal.
  if (kBootStage != kBootStageOwner) {
    peripheral_expected = kTopPeppermintPlicPeripheralOtpCtrl;
    for (dif_otp_ctrl_irq_t irq = kDifOtpCtrlIrqOtpOperationDone; irq <= kDifOtpCtrlIrqOtpError;
         ++irq) {
      otp_ctrl_irq_expected = irq;
      LOG_INFO("Triggering otp_ctrl IRQ %d.", irq);
      CHECK_DIF_OK(dif_otp_ctrl_irq_force(&otp_ctrl, irq, true));

      // This avoids a race where *irq_serviced is read before
      // entering the ISR.
      IBEX_SPIN_FOR(otp_ctrl_irq_serviced == irq, 1);
      LOG_INFO("IRQ %d from otp_ctrl is serviced.", irq);
    }
  }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 11 && 11 < TEST_MAX_IRQ_PERIPHERAL
  peripheral_expected = kTopPeppermintPlicPeripheralPwrmgr;
  for (dif_pwrmgr_irq_t irq = kDifPwrmgrIrqWakeup; irq <= kDifPwrmgrIrqWakeup;
       ++irq) {
    pwrmgr_irq_expected = irq;
    LOG_INFO("Triggering pwrmgr IRQ %d.", irq);
    CHECK_DIF_OK(dif_pwrmgr_irq_force(&pwrmgr, irq, true));

    // This avoids a race where *irq_serviced is read before
    // entering the ISR.
    IBEX_SPIN_FOR(pwrmgr_irq_serviced == irq, 1);
    LOG_INFO("IRQ %d from pwrmgr is serviced.", irq);
  }
#endif

#if TEST_MIN_IRQ_PERIPHERAL <= 12 && 12 < TEST_MAX_IRQ_PERIPHERAL
  peripheral_expected = kTopPeppermintPlicPeripheralRvTimer;
  for (dif_rv_timer_irq_t irq = kDifRvTimerIrqTimerExpiredHart0Timer0; irq <= kDifRvTimerIrqTimerExpiredHart0Timer0;
       ++irq) {
    rv_timer_irq_expected = irq;
    LOG_INFO("Triggering rv_timer IRQ %d.", irq);
    CHECK_DIF_OK(dif_rv_timer_irq_force(&rv_timer, irq, true));

    // This avoids a race where *irq_serviced is read before
    // entering the ISR.
    IBEX_SPIN_FOR(rv_timer_irq_serviced == irq, 1);
    LOG_INFO("IRQ %d from rv_timer is serviced.", irq);
  }
#endif
}

/**
 * Checks that the target ID corresponds to the ID of the hart on which
 * this test is executed on. This check is meant to be used in a
 * single-hart system only.
 */
static void check_hart_id(uint32_t exp_hart_id) {
  uint32_t act_hart_id;
  CSR_READ(CSR_REG_MHARTID, &act_hart_id);
  CHECK(act_hart_id == exp_hart_id, "Processor has unexpected HART ID.");
}

OTTF_DEFINE_TEST_CONFIG();

bool test_main(void) {
  irq_global_ctrl(true);
  irq_external_ctrl(true);
  peripherals_init();
  check_hart_id((uint32_t)kHart);
  rv_plic_testutils_irq_range_enable(
      &plic, kHart, kTopPeppermintPlicIrqIdNone + 1, kTopPeppermintPlicIrqIdLast);
  peripheral_irqs_clear();
  peripheral_irqs_enable();
  peripheral_irqs_trigger();
  return true;
}

// clang-format on
