// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------//
// PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
//
// util/topgen.py -t hw/top_peppermint/data/top_peppermint.hjson
//                -o hw/top_peppermint/

package top_peppermint_pkg;
  /**
   * Peripheral base address for pwrmgr in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_PWRMGR_BASE_ADDR = 32'h40400000;

  /**
   * Peripheral size in bytes for pwrmgr in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_PWRMGR_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for rstmgr in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_RSTMGR_BASE_ADDR = 32'h40410000;

  /**
   * Peripheral size in bytes for rstmgr in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_RSTMGR_SIZE_BYTES = 32'h40;

  /**
   * Peripheral base address for clkmgr in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_CLKMGR_BASE_ADDR = 32'h40420000;

  /**
   * Peripheral size in bytes for clkmgr in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_CLKMGR_SIZE_BYTES = 32'h40;

  /**
   * Peripheral base address for alert_handler in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_ALERT_HANDLER_BASE_ADDR = 32'h40450000;

  /**
   * Peripheral size in bytes for alert_handler in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_ALERT_HANDLER_SIZE_BYTES = 32'h800;

  /**
   * Peripheral base address for regs device on sram_ctrl_ret in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_SRAM_CTRL_RET_REGS_BASE_ADDR = 32'h40460000;

  /**
   * Peripheral size in bytes for regs device on sram_ctrl_ret in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_SRAM_CTRL_RET_REGS_SIZE_BYTES = 32'h40;

  /**
   * Peripheral base address for core device on otp_ctrl in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_OTP_CTRL_CORE_BASE_ADDR = 32'h30130000;

  /**
   * Peripheral size in bytes for core device on otp_ctrl in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_OTP_CTRL_CORE_SIZE_BYTES = 32'h4000;

  /**
   * Peripheral base address for prim device on otp_macro in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_OTP_MACRO_PRIM_BASE_ADDR = 32'h30140000;

  /**
   * Peripheral size in bytes for prim device on otp_macro in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_OTP_MACRO_PRIM_SIZE_BYTES = 32'h20;

  /**
   * Peripheral base address for regs device on lc_ctrl in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_LC_CTRL_REGS_BASE_ADDR = 32'h30150000;

  /**
   * Peripheral size in bytes for regs device on lc_ctrl in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_LC_CTRL_REGS_SIZE_BYTES = 32'h100;

  /**
   * Peripheral base address for regs device on rv_dm in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_RV_DM_REGS_BASE_ADDR = 32'h21200000;

  /**
   * Peripheral size in bytes for regs device on rv_dm in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_RV_DM_REGS_SIZE_BYTES = 32'h10;

  /**
   * Peripheral base address for mem device on rv_dm in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_RV_DM_MEM_BASE_ADDR = 32'h50000;

  /**
   * Peripheral size in bytes for mem device on rv_dm in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_RV_DM_MEM_SIZE_BYTES = 32'h1000;

  /**
   * Peripheral base address for rv_plic in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_RV_PLIC_BASE_ADDR = 32'h28000000;

  /**
   * Peripheral size in bytes for rv_plic in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_RV_PLIC_SIZE_BYTES = 32'h8000000;

  /**
   * Peripheral base address for rv_timer in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_RV_TIMER_BASE_ADDR = 32'h21190000;

  /**
   * Peripheral size in bytes for rv_timer in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_RV_TIMER_SIZE_BYTES = 32'h200;

  /**
   * Peripheral base address for aes in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_AES_BASE_ADDR = 32'h21100000;

  /**
   * Peripheral size in bytes for aes in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_AES_SIZE_BYTES = 32'h100;

  /**
   * Peripheral base address for hmac in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_HMAC_BASE_ADDR = 32'h21110000;

  /**
   * Peripheral size in bytes for hmac in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_HMAC_SIZE_BYTES = 32'h2000;

  /**
   * Peripheral base address for kmac in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_KMAC_BASE_ADDR = 32'h21120000;

  /**
   * Peripheral size in bytes for kmac in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_KMAC_SIZE_BYTES = 32'h1000;

  /**
   * Peripheral base address for otbn in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_OTBN_BASE_ADDR = 32'h21130000;

  /**
   * Peripheral size in bytes for otbn in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_OTBN_SIZE_BYTES = 32'h10000;

  /**
   * Peripheral base address for keymgr_dpe in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_KEYMGR_DPE_BASE_ADDR = 32'h21140000;

  /**
   * Peripheral size in bytes for keymgr_dpe in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_KEYMGR_DPE_SIZE_BYTES = 32'h100;

  /**
   * Peripheral base address for csrng in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_CSRNG_BASE_ADDR = 32'h21150000;

  /**
   * Peripheral size in bytes for csrng in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_CSRNG_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for entropy_src in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_ENTROPY_SRC_BASE_ADDR = 32'h21160000;

  /**
   * Peripheral size in bytes for entropy_src in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_ENTROPY_SRC_SIZE_BYTES = 32'h100;

  /**
   * Peripheral base address for edn0 in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_EDN0_BASE_ADDR = 32'h21170000;

  /**
   * Peripheral size in bytes for edn0 in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_EDN0_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for edn1 in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_EDN1_BASE_ADDR = 32'h21180000;

  /**
   * Peripheral size in bytes for edn1 in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_EDN1_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for regs device on sram_ctrl_main in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_SRAM_CTRL_MAIN_REGS_BASE_ADDR = 32'h211C0000;

  /**
   * Peripheral size in bytes for regs device on sram_ctrl_main in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_SRAM_CTRL_MAIN_REGS_SIZE_BYTES = 32'h40;

  /**
   * Peripheral base address for regs device on rom_ctrl in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_ROM_CTRL_REGS_BASE_ADDR = 32'h211E0000;

  /**
   * Peripheral size in bytes for regs device on rom_ctrl in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_ROM_CTRL_REGS_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for dma in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_DMA_BASE_ADDR = 32'h22010000;

  /**
   * Peripheral size in bytes for dma in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_DMA_SIZE_BYTES = 32'h200;

  /**
   * Peripheral base address for core device on mbx0 in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_MBX0_CORE_BASE_ADDR = 32'h22000000;

  /**
   * Peripheral size in bytes for core device on mbx0 in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_MBX0_CORE_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for core device on mbx1 in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_MBX1_CORE_BASE_ADDR = 32'h22000100;

  /**
   * Peripheral size in bytes for core device on mbx1 in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_MBX1_CORE_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for cfg device on rv_core_ibex in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_RV_CORE_IBEX_CFG_BASE_ADDR = 32'h211F0000;

  /**
   * Peripheral size in bytes for cfg device on rv_core_ibex in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_RV_CORE_IBEX_CFG_SIZE_BYTES = 32'h800;

  /**
   * Memory base address for ram memory on sram_ctrl_ret in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_SRAM_CTRL_RET_RAM_BASE_ADDR = 32'h40470000;

  /**
   * Memory size for ram memory on sram_ctrl_ret in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_SRAM_CTRL_RET_RAM_SIZE_BYTES = 32'h2000;

  /**
   * Memory base address for ram memory on sram_ctrl_main in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_SRAM_CTRL_MAIN_RAM_BASE_ADDR = 32'h10000000;

  /**
   * Memory size for ram memory on sram_ctrl_main in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_SRAM_CTRL_MAIN_RAM_SIZE_BYTES = 32'h30000;

  /**
   * Memory base address for rom memory on rom_ctrl in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_ROM_CTRL_ROM_BASE_ADDR = 32'h20000;

  /**
   * Memory size for rom memory on rom_ctrl in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_ROM_CTRL_ROM_SIZE_BYTES = 32'h20000;

  /**
   * Memory base address for ctn memory on ahb_bridge in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_AHB_BRIDGE_CTN_BASE_ADDR = 32'h80000000;

  /**
   * Memory size for ctn memory on ahb_bridge in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_AHB_BRIDGE_CTN_SIZE_BYTES = 32'h10000000;


  // Enumeration of alert modules
  typedef enum int unsigned {
    TopPeppermintAlertPeripheralPwrmgr = 0,
    TopPeppermintAlertPeripheralRstmgr = 1,
    TopPeppermintAlertPeripheralClkmgr = 2,
    TopPeppermintAlertPeripheralSramCtrlRet = 3,
    TopPeppermintAlertPeripheralOtpCtrl = 4,
    TopPeppermintAlertPeripheralLcCtrl = 5,
    TopPeppermintAlertPeripheralRvDm = 6,
    TopPeppermintAlertPeripheralRvPlic = 7,
    TopPeppermintAlertPeripheralRvTimer = 8,
    TopPeppermintAlertPeripheralAes = 9,
    TopPeppermintAlertPeripheralHmac = 10,
    TopPeppermintAlertPeripheralKmac = 11,
    TopPeppermintAlertPeripheralOtbn = 12,
    TopPeppermintAlertPeripheralKeymgrDpe = 13,
    TopPeppermintAlertPeripheralCsrng = 14,
    TopPeppermintAlertPeripheralEntropySrc = 15,
    TopPeppermintAlertPeripheralEdn0 = 16,
    TopPeppermintAlertPeripheralEdn1 = 17,
    TopPeppermintAlertPeripheralSramCtrlMain = 18,
    TopPeppermintAlertPeripheralRomCtrl = 19,
    TopPeppermintAlertPeripheralDma = 20,
    TopPeppermintAlertPeripheralMbx0 = 21,
    TopPeppermintAlertPeripheralMbx1 = 22,
    TopPeppermintAlertPeripheralRvCoreIbex = 23,
    TopPeppermintAlertPeripheralCount
  } alert_peripheral_e;

  // Enumeration of alerts
  typedef enum int unsigned {
    TopPeppermintAlertIdPwrmgrFatalFault = 0,
    TopPeppermintAlertIdRstmgrFatalFault = 1,
    TopPeppermintAlertIdRstmgrFatalCnstyFault = 2,
    TopPeppermintAlertIdClkmgrRecovFault = 3,
    TopPeppermintAlertIdClkmgrFatalFault = 4,
    TopPeppermintAlertIdSramCtrlRetFatalError = 5,
    TopPeppermintAlertIdOtpCtrlFatalMacroError = 6,
    TopPeppermintAlertIdOtpCtrlFatalCheckError = 7,
    TopPeppermintAlertIdOtpCtrlFatalBusIntegError = 8,
    TopPeppermintAlertIdOtpCtrlFatalPrimOtpAlert = 9,
    TopPeppermintAlertIdOtpCtrlRecovPrimOtpAlert = 10,
    TopPeppermintAlertIdLcCtrlFatalProgError = 11,
    TopPeppermintAlertIdLcCtrlFatalStateError = 12,
    TopPeppermintAlertIdLcCtrlFatalBusIntegError = 13,
    TopPeppermintAlertIdRvDmFatalFault = 14,
    TopPeppermintAlertIdRvPlicFatalFault = 15,
    TopPeppermintAlertIdRvTimerFatalFault = 16,
    TopPeppermintAlertIdAesRecovCtrlUpdateErr = 17,
    TopPeppermintAlertIdAesFatalFault = 18,
    TopPeppermintAlertIdHmacFatalFault = 19,
    TopPeppermintAlertIdKmacRecovOperationErr = 20,
    TopPeppermintAlertIdKmacFatalFaultErr = 21,
    TopPeppermintAlertIdOtbnFatal = 22,
    TopPeppermintAlertIdOtbnRecov = 23,
    TopPeppermintAlertIdKeymgrDpeRecovOperationErr = 24,
    TopPeppermintAlertIdKeymgrDpeFatalFaultErr = 25,
    TopPeppermintAlertIdCsrngRecovAlert = 26,
    TopPeppermintAlertIdCsrngFatalAlert = 27,
    TopPeppermintAlertIdEntropySrcRecovAlert = 28,
    TopPeppermintAlertIdEntropySrcFatalAlert = 29,
    TopPeppermintAlertIdEdn0RecovAlert = 30,
    TopPeppermintAlertIdEdn0FatalAlert = 31,
    TopPeppermintAlertIdEdn1RecovAlert = 32,
    TopPeppermintAlertIdEdn1FatalAlert = 33,
    TopPeppermintAlertIdSramCtrlMainFatalError = 34,
    TopPeppermintAlertIdRomCtrlFatal = 35,
    TopPeppermintAlertIdDmaFatalFault = 36,
    TopPeppermintAlertIdMbx0FatalFault = 37,
    TopPeppermintAlertIdMbx0RecovFault = 38,
    TopPeppermintAlertIdMbx1FatalFault = 39,
    TopPeppermintAlertIdMbx1RecovFault = 40,
    TopPeppermintAlertIdRvCoreIbexFatalSwErr = 41,
    TopPeppermintAlertIdRvCoreIbexRecovSwErr = 42,
    TopPeppermintAlertIdRvCoreIbexFatalHwErr = 43,
    TopPeppermintAlertIdRvCoreIbexRecovHwErr = 44,
    TopPeppermintAlertIdCount
  } alert_id_e;

  // Enumeration of soc incoming alerts
  typedef enum int unsigned {
    TopPeppermintIncomingAlertSocIdSocRecovAlert0 = 0,
    TopPeppermintIncomingAlertSocIdSocRecovAlert1 = 1,
    TopPeppermintIncomingAlertSocIdSocRecovAlert2 = 2,
    TopPeppermintIncomingAlertSocIdSocRecovAlert3 = 3,
    TopPeppermintIncomingAlertSocIdSocRecovAlert4 = 4,
    TopPeppermintIncomingAlertSocIdSocRecovAlert5 = 5,
    TopPeppermintIncomingAlertSocIdSocRecovAlert6 = 6,
    TopPeppermintIncomingAlertSocIdSocRecovAlert7 = 7,
    TopPeppermintIncomingAlertSocIdSocRecovAlert8 = 8,
    TopPeppermintIncomingAlertSocIdSocRecovAlert9 = 9,
    TopPeppermintIncomingAlertSocIdSocRecovAlert10 = 10,
    TopPeppermintIncomingAlertSocIdSocRecovAlert11 = 11,
    TopPeppermintIncomingAlertSocIdSocRecovAlert12 = 12,
    TopPeppermintIncomingAlertSocIdSocRecovAlert13 = 13,
    TopPeppermintIncomingAlertSocIdSocRecovAlert14 = 14,
    TopPeppermintIncomingAlertSocIdSocRecovAlert15 = 15,
    TopPeppermintIncomingAlertSocIdSocRecovAlert16 = 16,
    TopPeppermintIncomingAlertSocIdSocRecovAlert17 = 17,
    TopPeppermintIncomingAlertSocIdSocRecovAlert18 = 18,
    TopPeppermintIncomingAlertSocIdSocRecovAlert19 = 19,
    TopPeppermintIncomingAlertSocIdSocRecovAlert20 = 20,
    TopPeppermintIncomingAlertSocIdSocRecovAlert21 = 21,
    TopPeppermintIncomingAlertSocIdSocRecovAlert22 = 22,
    TopPeppermintIncomingAlertSocIdSocRecovAlert23 = 23,
    TopPeppermintIncomingAlertSocIdSocRecovAlert24 = 24,
    TopPeppermintIncomingAlertSocIdSocRecovAlert25 = 25,
    TopPeppermintIncomingAlertSocIdSocRecovAlert26 = 26,
    TopPeppermintIncomingAlertSocIdSocRecovAlert27 = 27,
    TopPeppermintIncomingAlertSocIdSocRecovAlert28 = 28,
    TopPeppermintIncomingAlertSocIdSocRecovAlert29 = 29,
    TopPeppermintIncomingAlertSocIdSocRecovAlert30 = 30,
    TopPeppermintIncomingAlertSocIdSocRecovAlert31 = 31,
    TopPeppermintIncomingAlertSocIdSocFatalAlert0 = 32,
    TopPeppermintIncomingAlertSocIdSocFatalAlert1 = 33,
    TopPeppermintIncomingAlertSocIdSocFatalAlert2 = 34,
    TopPeppermintIncomingAlertSocIdSocFatalAlert3 = 35,
    TopPeppermintIncomingAlertSocIdSocFatalAlert4 = 36,
    TopPeppermintIncomingAlertSocIdSocFatalAlert5 = 37,
    TopPeppermintIncomingAlertSocIdSocFatalAlert6 = 38,
    TopPeppermintIncomingAlertSocIdSocFatalAlert7 = 39,
    TopPeppermintIncomingAlertSocIdCount
  } incoming_alert_soc_id_e;

  // Number of soc incoming alerts
  parameter int unsigned NIncomingAlertsSoc = 40;

  // Number of LPGs for incoming alert group soc
  parameter int unsigned NIncomingLpgsSoc = 8;

  // Enumeration of interrupts
  typedef enum int unsigned {
    TopPeppermintPlicIrqIdNone = 0,
    TopPeppermintPlicIrqIdPwrmgrWakeup = 1,
    TopPeppermintPlicIrqIdAlertHandlerClassa = 2,
    TopPeppermintPlicIrqIdAlertHandlerClassb = 3,
    TopPeppermintPlicIrqIdAlertHandlerClassc = 4,
    TopPeppermintPlicIrqIdAlertHandlerClassd = 5,
    TopPeppermintPlicIrqIdOtpCtrlOtpOperationDone = 6,
    TopPeppermintPlicIrqIdOtpCtrlOtpError = 7,
    TopPeppermintPlicIrqIdRvTimerTimerExpiredHart0Timer0 = 8,
    TopPeppermintPlicIrqIdHmacHmacDone = 9,
    TopPeppermintPlicIrqIdHmacFifoEmpty = 10,
    TopPeppermintPlicIrqIdHmacHmacErr = 11,
    TopPeppermintPlicIrqIdKmacKmacDone = 12,
    TopPeppermintPlicIrqIdKmacFifoEmpty = 13,
    TopPeppermintPlicIrqIdKmacKmacErr = 14,
    TopPeppermintPlicIrqIdOtbnDone = 15,
    TopPeppermintPlicIrqIdKeymgrDpeOpDone = 16,
    TopPeppermintPlicIrqIdCsrngCsCmdReqDone = 17,
    TopPeppermintPlicIrqIdCsrngCsEntropyReq = 18,
    TopPeppermintPlicIrqIdCsrngCsHwInstExc = 19,
    TopPeppermintPlicIrqIdCsrngCsFatalErr = 20,
    TopPeppermintPlicIrqIdEntropySrcEsEntropyValid = 21,
    TopPeppermintPlicIrqIdEntropySrcEsHealthTestFailed = 22,
    TopPeppermintPlicIrqIdEntropySrcEsObserveFifoReady = 23,
    TopPeppermintPlicIrqIdEntropySrcEsFatalErr = 24,
    TopPeppermintPlicIrqIdEdn0EdnCmdReqDone = 25,
    TopPeppermintPlicIrqIdEdn0EdnFatalErr = 26,
    TopPeppermintPlicIrqIdEdn1EdnCmdReqDone = 27,
    TopPeppermintPlicIrqIdEdn1EdnFatalErr = 28,
    TopPeppermintPlicIrqIdDmaDmaDone = 29,
    TopPeppermintPlicIrqIdDmaDmaChunkDone = 30,
    TopPeppermintPlicIrqIdDmaDmaError = 31,
    TopPeppermintPlicIrqIdMbx0MbxReady = 32,
    TopPeppermintPlicIrqIdMbx0MbxAbort = 33,
    TopPeppermintPlicIrqIdMbx0MbxError = 34,
    TopPeppermintPlicIrqIdMbx1MbxReady = 35,
    TopPeppermintPlicIrqIdMbx1MbxAbort = 36,
    TopPeppermintPlicIrqIdMbx1MbxError = 37,
    TopPeppermintPlicIrqIdSocIrq0 = 38,
    TopPeppermintPlicIrqIdSocIrq1 = 39,
    TopPeppermintPlicIrqIdSocIrq2 = 40,
    TopPeppermintPlicIrqIdSocIrq3 = 41,
    TopPeppermintPlicIrqIdCount
  } interrupt_rv_plic_id_e;


  // Number of soc incoming interrupts
  parameter int unsigned NIncomingInterruptsSoc = 4;

  // Enumeration of interrupts for incoming group soc
  typedef enum int unsigned {
    TopPeppermintIncomingIrqSocIdSocIrq0 = 0,
    TopPeppermintIncomingIrqSocIdSocIrq1 = 1,
    TopPeppermintIncomingIrqSocIdSocIrq2 = 2,
    TopPeppermintIncomingIrqSocIdSocIrq3 = 3,
    TopPeppermintIncomingIrqSocIdCount
  } incoming_interrupt_soc_id_e;

  // List of peripheral instantiated in this chip.
  typedef enum {
    PeripheralAes,
    PeripheralAlertHandler,
    PeripheralClkmgr,
    PeripheralCsrng,
    PeripheralDma,
    PeripheralEdn0,
    PeripheralEdn1,
    PeripheralEntropySrc,
    PeripheralHmac,
    PeripheralKeymgrDpe,
    PeripheralKmac,
    PeripheralLcCtrl,
    PeripheralMbx0,
    PeripheralMbx1,
    PeripheralOtbn,
    PeripheralOtpCtrl,
    PeripheralOtpMacro,
    PeripheralPwrmgr,
    PeripheralRomCtrl,
    PeripheralRstmgr,
    PeripheralRvCoreIbex,
    PeripheralRvDm,
    PeripheralRvPlic,
    PeripheralRvTimer,
    PeripheralSramCtrlMain,
    PeripheralSramCtrlRet,
    PeripheralCount
  } peripheral_e;

  // MMIO Region
  //
  parameter int unsigned TOP_PEPPERMINT_MMIO_BASE_ADDR = 32'h21100000;
  parameter int unsigned TOP_PEPPERMINT_MMIO_SIZE_BYTES = 32'h1F372000;

  // TODO: Enumeration for PLIC Interrupt source peripheral.

// MACROs for AST analog simulation support
`ifdef ANALOGSIM
  `define INOUT_AI input ast_pkg::awire_t
  `define INOUT_AO output ast_pkg::awire_t
`else
  `define INOUT_AI inout
  `define INOUT_AO inout
`endif

endpackage
