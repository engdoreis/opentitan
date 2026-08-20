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
   * Peripheral base address for rv_timer_aon in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_RV_TIMER_AON_BASE_ADDR = 32'h40430000;

  /**
   * Peripheral size in bytes for rv_timer_aon in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_RV_TIMER_AON_SIZE_BYTES = 32'h200;

  /**
   * Peripheral base address for regs device on sram_ctrl_ret_aon in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_SRAM_CTRL_RET_AON_REGS_BASE_ADDR = 32'h40460000;

  /**
   * Peripheral size in bytes for regs device on sram_ctrl_ret_aon in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_SRAM_CTRL_RET_AON_REGS_SIZE_BYTES = 32'h40;

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
   * Memory base address for ram memory on sram_ctrl_ret_aon in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_SRAM_CTRL_RET_AON_RAM_BASE_ADDR = 32'h40470000;

  /**
   * Memory size for ram memory on sram_ctrl_ret_aon in top peppermint.
   */
  parameter int unsigned TOP_PEPPERMINT_SRAM_CTRL_RET_AON_RAM_SIZE_BYTES = 32'h2000;

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
    TopPeppermintAlertPeripheralRvTimerAon = 3,
    TopPeppermintAlertPeripheralSramCtrlRetAon = 4,
    TopPeppermintAlertPeripheralOtpCtrl = 5,
    TopPeppermintAlertPeripheralLcCtrl = 6,
    TopPeppermintAlertPeripheralRvDm = 7,
    TopPeppermintAlertPeripheralRvPlic = 8,
    TopPeppermintAlertPeripheralRvTimer = 9,
    TopPeppermintAlertPeripheralAes = 10,
    TopPeppermintAlertPeripheralHmac = 11,
    TopPeppermintAlertPeripheralKmac = 12,
    TopPeppermintAlertPeripheralOtbn = 13,
    TopPeppermintAlertPeripheralKeymgrDpe = 14,
    TopPeppermintAlertPeripheralCsrng = 15,
    TopPeppermintAlertPeripheralEntropySrc = 16,
    TopPeppermintAlertPeripheralEdn0 = 17,
    TopPeppermintAlertPeripheralEdn1 = 18,
    TopPeppermintAlertPeripheralSramCtrlMain = 19,
    TopPeppermintAlertPeripheralRomCtrl = 20,
    TopPeppermintAlertPeripheralDma = 21,
    TopPeppermintAlertPeripheralMbx0 = 22,
    TopPeppermintAlertPeripheralMbx1 = 23,
    TopPeppermintAlertPeripheralRvCoreIbex = 24,
    TopPeppermintAlertPeripheralCount
  } alert_peripheral_e;

  // Enumeration of alerts
  typedef enum int unsigned {
    TopPeppermintAlertIdPwrmgrFatalFault = 0,
    TopPeppermintAlertIdRstmgrFatalFault = 1,
    TopPeppermintAlertIdRstmgrFatalCnstyFault = 2,
    TopPeppermintAlertIdClkmgrRecovFault = 3,
    TopPeppermintAlertIdClkmgrFatalFault = 4,
    TopPeppermintAlertIdRvTimerAonFatalFault = 5,
    TopPeppermintAlertIdSramCtrlRetAonFatalError = 6,
    TopPeppermintAlertIdOtpCtrlFatalMacroError = 7,
    TopPeppermintAlertIdOtpCtrlFatalCheckError = 8,
    TopPeppermintAlertIdOtpCtrlFatalBusIntegError = 9,
    TopPeppermintAlertIdOtpCtrlFatalPrimOtpAlert = 10,
    TopPeppermintAlertIdOtpCtrlRecovPrimOtpAlert = 11,
    TopPeppermintAlertIdLcCtrlFatalProgError = 12,
    TopPeppermintAlertIdLcCtrlFatalStateError = 13,
    TopPeppermintAlertIdLcCtrlFatalBusIntegError = 14,
    TopPeppermintAlertIdRvDmFatalFault = 15,
    TopPeppermintAlertIdRvPlicFatalFault = 16,
    TopPeppermintAlertIdRvTimerFatalFault = 17,
    TopPeppermintAlertIdAesRecovCtrlUpdateErr = 18,
    TopPeppermintAlertIdAesFatalFault = 19,
    TopPeppermintAlertIdHmacFatalFault = 20,
    TopPeppermintAlertIdKmacRecovOperationErr = 21,
    TopPeppermintAlertIdKmacFatalFaultErr = 22,
    TopPeppermintAlertIdOtbnFatal = 23,
    TopPeppermintAlertIdOtbnRecov = 24,
    TopPeppermintAlertIdKeymgrDpeRecovOperationErr = 25,
    TopPeppermintAlertIdKeymgrDpeFatalFaultErr = 26,
    TopPeppermintAlertIdCsrngRecovAlert = 27,
    TopPeppermintAlertIdCsrngFatalAlert = 28,
    TopPeppermintAlertIdEntropySrcRecovAlert = 29,
    TopPeppermintAlertIdEntropySrcFatalAlert = 30,
    TopPeppermintAlertIdEdn0RecovAlert = 31,
    TopPeppermintAlertIdEdn0FatalAlert = 32,
    TopPeppermintAlertIdEdn1RecovAlert = 33,
    TopPeppermintAlertIdEdn1FatalAlert = 34,
    TopPeppermintAlertIdSramCtrlMainFatalError = 35,
    TopPeppermintAlertIdRomCtrlFatal = 36,
    TopPeppermintAlertIdDmaFatalFault = 37,
    TopPeppermintAlertIdMbx0FatalFault = 38,
    TopPeppermintAlertIdMbx0RecovFault = 39,
    TopPeppermintAlertIdMbx1FatalFault = 40,
    TopPeppermintAlertIdMbx1RecovFault = 41,
    TopPeppermintAlertIdRvCoreIbexFatalSwErr = 42,
    TopPeppermintAlertIdRvCoreIbexRecovSwErr = 43,
    TopPeppermintAlertIdRvCoreIbexFatalHwErr = 44,
    TopPeppermintAlertIdRvCoreIbexRecovHwErr = 45,
    TopPeppermintAlertIdCount
  } alert_id_e;

  // Enumeration of soc incoming alerts
  typedef enum int unsigned {
    TopPeppermintIncomingAlertSocIdSocFatalAlert0 = 0,
    TopPeppermintIncomingAlertSocIdSocFatalAlert1 = 1,
    TopPeppermintIncomingAlertSocIdSocFatalAlert2 = 2,
    TopPeppermintIncomingAlertSocIdSocFatalAlert3 = 3,
    TopPeppermintIncomingAlertSocIdCount
  } incoming_alert_soc_id_e;

  // Number of soc incoming alerts
  parameter int unsigned NIncomingAlertsSoc = 4;

  // Number of LPGs for incoming alert group soc
  parameter int unsigned NIncomingLpgsSoc = 1;

  // Enumeration of interrupts
  typedef enum int unsigned {
    TopPeppermintPlicIrqIdNone = 0,
    TopPeppermintPlicIrqIdPwrmgrWakeup = 1,
    TopPeppermintPlicIrqIdAlertHandlerClassa = 2,
    TopPeppermintPlicIrqIdAlertHandlerClassb = 3,
    TopPeppermintPlicIrqIdAlertHandlerClassc = 4,
    TopPeppermintPlicIrqIdAlertHandlerClassd = 5,
    TopPeppermintPlicIrqIdRvTimerAonTimerExpiredHart0Timer0 = 6,
    TopPeppermintPlicIrqIdOtpCtrlOtpOperationDone = 7,
    TopPeppermintPlicIrqIdOtpCtrlOtpError = 8,
    TopPeppermintPlicIrqIdRvTimerTimerExpiredHart0Timer0 = 9,
    TopPeppermintPlicIrqIdHmacHmacDone = 10,
    TopPeppermintPlicIrqIdHmacFifoEmpty = 11,
    TopPeppermintPlicIrqIdHmacHmacErr = 12,
    TopPeppermintPlicIrqIdKmacKmacDone = 13,
    TopPeppermintPlicIrqIdKmacFifoEmpty = 14,
    TopPeppermintPlicIrqIdKmacKmacErr = 15,
    TopPeppermintPlicIrqIdOtbnDone = 16,
    TopPeppermintPlicIrqIdKeymgrDpeOpDone = 17,
    TopPeppermintPlicIrqIdCsrngCsCmdReqDone = 18,
    TopPeppermintPlicIrqIdCsrngCsEntropyReq = 19,
    TopPeppermintPlicIrqIdCsrngCsHwInstExc = 20,
    TopPeppermintPlicIrqIdCsrngCsFatalErr = 21,
    TopPeppermintPlicIrqIdEntropySrcEsEntropyValid = 22,
    TopPeppermintPlicIrqIdEntropySrcEsHealthTestFailed = 23,
    TopPeppermintPlicIrqIdEntropySrcEsObserveFifoReady = 24,
    TopPeppermintPlicIrqIdEntropySrcEsFatalErr = 25,
    TopPeppermintPlicIrqIdEdn0EdnCmdReqDone = 26,
    TopPeppermintPlicIrqIdEdn0EdnFatalErr = 27,
    TopPeppermintPlicIrqIdEdn1EdnCmdReqDone = 28,
    TopPeppermintPlicIrqIdEdn1EdnFatalErr = 29,
    TopPeppermintPlicIrqIdDmaDmaDone = 30,
    TopPeppermintPlicIrqIdDmaDmaChunkDone = 31,
    TopPeppermintPlicIrqIdDmaDmaError = 32,
    TopPeppermintPlicIrqIdMbx0MbxReady = 33,
    TopPeppermintPlicIrqIdMbx0MbxAbort = 34,
    TopPeppermintPlicIrqIdMbx0MbxError = 35,
    TopPeppermintPlicIrqIdMbx1MbxReady = 36,
    TopPeppermintPlicIrqIdMbx1MbxAbort = 37,
    TopPeppermintPlicIrqIdMbx1MbxError = 38,
    TopPeppermintPlicIrqIdSocIrq0 = 39,
    TopPeppermintPlicIrqIdSocIrq1 = 40,
    TopPeppermintPlicIrqIdSocIrq2 = 41,
    TopPeppermintPlicIrqIdSocIrq3 = 42,
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
    PeripheralRvTimerAon,
    PeripheralSramCtrlMain,
    PeripheralSramCtrlRetAon,
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
