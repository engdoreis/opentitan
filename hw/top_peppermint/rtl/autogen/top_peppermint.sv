// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------//
// PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
//
// util/topgen.py -t hw/top_peppermint/data/top_peppermint.hjson
//                -o hw/top_peppermint/


// This wrapper hosts all power domain wrappers and the connections between them for peppermint.
module top_peppermint #(
  // Manually defined parameters
  parameter int unsigned SocCpuBootAddrWidth = 32,

  // Auto-inferred parameters
  // parameters for rstmgr
  parameter bit SecRstmgrCheck = 0,
  parameter int SecRstmgrMaxSyncDelay = 2,
  // parameters for alert_handler
  parameter int AlertHandlerEscNumSeverities = 4,
  parameter int AlertHandlerEscPingCountWidth = 16,
  // parameters for sram_ctrl_ret
  parameter int SramCtrlRetInstSize = 8192,
  parameter int SramCtrlRetNumRamInst = 1,
  parameter bit SramCtrlRetInstrExec = 0,
  parameter int SramCtrlRetNumPrinceRoundsHalf = 3,
  parameter bit SramCtrlRetEccCorrection = 0,
  // parameters for otp_macro
  parameter OtpMacroMemInitFile = "",
  // parameters for lc_ctrl
  parameter bit SecLcCtrlVolatileRawUnlockEn = 0,
  parameter bit LcCtrlUseDmiInterface = 1,
  parameter logic [15:0] LcCtrlSiliconCreatorId = 16'h 4003,
  parameter logic [15:0] LcCtrlProductId = 16'h 4100,
  parameter logic [7:0] LcCtrlRevisionId = 8'h 01,
  parameter logic [31:0] LcCtrlIdcodeValue = 32'h0000_0001,
  // parameters for rv_dm
  parameter logic [31:0] RvDmIdcodeValue = 32'h0000_0001,
  parameter bit RvDmUseDmiInterface = 1,
  parameter bit SecRvDmVolatileRawUnlockEn = 0,
  parameter logic [tlul_pkg::RsvdWidth-1:0] RvDmTlulHostUserRsvdBits = '0,
  // parameters for aes
  parameter bit AesAESGCMEnable = 1,
  parameter bit SecAesMasking = 1,
  parameter aes_pkg::sbox_impl_e SecAesSBoxImpl = aes_pkg::SBoxImplDom,
  parameter int unsigned SecAesStartTriggerDelay = 0,
  parameter bit SecAesAllowForcingMasks = 1'b0,
  parameter bit SecAesSkipPRNGReseeding = 1'b0,
  // parameters for kmac
  parameter bit KmacEnMasking = 1,
  parameter bit KmacSwKeyMasked = 0,
  parameter int SecKmacCmdDelay = 0,
  parameter bit SecKmacIdleAcceptSwMsg = 0,
  parameter int KmacNumAppIntf = 3,
  parameter kmac_pkg::app_config_t KmacAppCfg[KmacNumAppIntf] =
      '{kmac_pkg::AppCfgKeyMgr,
        kmac_pkg::AppCfgLcCtrl,
        kmac_pkg::AppCfgRomCtrl},
  // parameters for otbn
  parameter bit OtbnStub = 0,
  parameter otbn_pkg::regfile_e OtbnRegFile = otbn_pkg::RegFileFF,
  parameter bit SecOtbnMuteUrnd = 0,
  parameter bit SecOtbnFixMaiOpSeq = 0,
  parameter bit SecOtbnSkipUrndReseedAtStart = 0,
  parameter bit OtbnFeatStubMai = 0,
  // parameters for keymgr_dpe
  parameter bit KeymgrDpeKmacEnMasking = 1,
  parameter int KeymgrDpeNumRomDigestInputs = 1,
  // parameters for csrng
  parameter aes_pkg::sbox_impl_e CsrngSBoxImpl = aes_pkg::SBoxImplCanright,
  // parameters for entropy_src
  parameter int EntropySrcRngBusWidth = 4,
  parameter int EntropySrcRngBusBitSelWidth = 2,
  parameter int EntropySrcHealthTestWindowWidth = 18,
  parameter bit EntropySrcStub = 0,
  // parameters for sram_ctrl_main
  parameter int SramCtrlMainInstSize = 196608,
  parameter int SramCtrlMainNumRamInst = 1,
  parameter bit SramCtrlMainInstrExec = 1,
  parameter int SramCtrlMainNumPrinceRoundsHalf = 2,
  parameter bit SramCtrlMainEccCorrection = 0,
  // parameters for rom_ctrl
  parameter RomCtrlBootRomInitFile = "",
  parameter bit SecRomCtrlDisableScrambling = 1'b0,
  // parameters for dma
  parameter bit DmaEnableDataIntgGen = 1'b1,
  parameter bit DmaEnableRspDataIntgCheck = 1'b1,
  parameter logic [tlul_pkg::RsvdWidth-1:0] DmaTlUserRsvd = '0,
  parameter top_racl_pkg::racl_role_t DmaSysRaclRole = '0,
  parameter int unsigned DmaOtAgentId = 0,
  // parameters for rv_core_ibex
  parameter bit RvCoreIbexPMPEnable = 1,
  parameter int unsigned RvCoreIbexPMPGranularity = 0,
  parameter int unsigned RvCoreIbexPMPNumRegions = 16,
  parameter int unsigned RvCoreIbexMHPMCounterNum = 10,
  parameter int unsigned RvCoreIbexMHPMCounterWidth = 32,
  parameter ibex_pkg::pmp_cfg_t RvCoreIbexPMPRstCfg[16] = ibex_pmp_reset_pkg::PmpCfgRst,
  parameter logic [33:0] RvCoreIbexPMPRstAddr[16] = ibex_pmp_reset_pkg::PmpAddrRst,
  parameter ibex_pkg::pmp_mseccfg_t RvCoreIbexPMPRstMsecCfg = ibex_pmp_reset_pkg::PmpMseccfgRst,
  parameter bit RvCoreIbexRV32E = 0,
  parameter ibex_pkg::rv32m_e RvCoreIbexRV32M = ibex_pkg::RV32MSingleCycle,
  parameter ibex_pkg::rv32b_e RvCoreIbexRV32B = ibex_pkg::RV32BOTEarlGrey,
  parameter ibex_pkg::rv32zc_e RvCoreIbexRV32ZC = ibex_pkg::RV32ZcaZcbZcmp,
  parameter ibex_pkg::regfile_e RvCoreIbexRegFile = ibex_pkg::RegFileFF,
  parameter bit RvCoreIbexBranchTargetALU = 1,
  parameter bit RvCoreIbexWritebackStage = 1,
  parameter bit RvCoreIbexICache = 1,
  parameter bit RvCoreIbexICacheECC = 1,
  parameter bit RvCoreIbexICacheScramble = 1,
  parameter int unsigned RvCoreIbexICacheNWays = 2,
  parameter bit RvCoreIbexBranchPredictor = 0,
  parameter bit RvCoreIbexDbgTriggerEn = 1,
  parameter int RvCoreIbexDbgHwBreakNum = 4,
  parameter bit RvCoreIbexSecureIbex = 1,
  parameter int unsigned RvCoreIbexDmBaseAddr = tl_main_pkg::ADDR_SPACE_RV_DM__MEM,
  parameter int unsigned RvCoreIbexDmAddrMask = tl_main_pkg::ADDR_MASK_RV_DM__MEM,
  parameter int unsigned RvCoreIbexDmHaltAddr =
      tl_main_pkg::ADDR_SPACE_RV_DM__MEM + dm::HaltAddress[31:0],
  parameter int unsigned RvCoreIbexDmExceptionAddr =
      tl_main_pkg::ADDR_SPACE_RV_DM__MEM + dm::ExceptionAddress[31:0],
  parameter bit RvCoreIbexPipeLine = 1,
  parameter logic [tlul_pkg::RsvdWidth-1:0] RvCoreIbexTlulHostUserRsvdBits = '0,
  parameter logic [31:0] RvCoreIbexCsrMvendorId = '0,
  parameter logic [31:0] RvCoreIbexCsrMimpId = '0
) (
  // Externally supplied base clocks
  input clk_aon_i,
  input clk_main_i,

  // Manual DFT signals
  input                        scan_rst_ni, // reset used for test mode
  input                        scan_en_i,
  input prim_mubi_pkg::mubi4_t scanmode_i,  // lc_ctrl_pkg::On for Scan

  // Incoming alerts for group soc
  input  prim_alert_pkg::alert_tx_t [top_peppermint_pkg::NIncomingAlertsSoc-1:0] incoming_alert_soc_tx_i,
  output prim_alert_pkg::alert_rx_t [top_peppermint_pkg::NIncomingAlertsSoc-1:0] incoming_alert_soc_rx_o,
  input  prim_mubi_pkg::mubi4_t     [top_peppermint_pkg::NIncomingLpgsSoc-1:0]   incoming_lpg_cg_en_soc_i,
  input  prim_mubi_pkg::mubi4_t     [top_peppermint_pkg::NIncomingLpgsSoc-1:0]   incoming_lpg_rst_en_soc_i,


  // Incoming interrupt for group soc
  input logic [top_peppermint_pkg::NIncomingInterruptsSoc-1:0] incoming_interrupt_soc_i,

  // Inter-module Signal External type
  input  logic       wakeup_main_i,
  output logic       es_rng_enable_o,
  input  logic       es_rng_valid_i,
  input  logic [EntropySrcRngBusWidth-1:0] es_rng_bit_i,
  output logic       es_rng_fips_o,
  output logic       mbx0_doe_intr_o,
  output logic       mbx0_doe_intr_en_o,
  output logic       mbx0_doe_intr_support_o,
  output logic       mbx0_doe_async_msg_support_o,
  output logic       mbx1_doe_intr_o,
  output logic       mbx1_doe_intr_en_o,
  output logic       mbx1_doe_intr_support_o,
  output logic       mbx1_doe_async_msg_support_o,
  output ahb_pkg::ahb_m2s_t       soc_mgr_ahb_req_o,
  input  ahb_pkg::ahb_s2m_t       soc_mgr_ahb_rsp_i,
  input  ahb_pkg::ahb_m2s_t       soc_mbx_ahb_req_i,
  output ahb_pkg::ahb_s2m_t       soc_mbx_ahb_rsp_o,
  input  tlul_pkg::tl_h2d_t       soc_dbg_tl_req_i,
  output tlul_pkg::tl_d2h_t       soc_dbg_tl_rsp_o,

  // Power-on reset from the SoC
  input logic rst_aon_ni,

  // Power handshake with the SoC
  output logic power_main_req_o,
  input  logic power_main_ok_i,
  input  logic clk_aon_ok_i,
  input  logic clk_main_ok_i,

  // Power gating control of the main power domain by the power controller of
  // the wider SoC.
  input logic power_main_iso_en_i,
  input logic power_main_sw_en_i,
  input logic power_main_sw_en_phy_i,

  // Reset of the SoC CPU
  output logic rst_soc_cpu_no,

  // Boot address of the SoC CPU
  output logic [SocCpuBootAddrWidth-1:0] soc_cpu_boot_addr_o,

  // Life cycle function control to the wider SoC
  output lc_ctrl_pkg::lc_tx_t soc_lc_dft_en_o,
  output lc_ctrl_pkg::lc_tx_t soc_lc_nvm_debug_en_o,
  output lc_ctrl_pkg::lc_tx_t soc_lc_hw_debug_en_o,
  output lc_ctrl_pkg::lc_tx_t soc_lc_cpu_en_o,

  // Main power domain reset
  output logic rst_main_no
);

  import top_peppermint_pkg::*;
  import prim_pad_wrapper_pkg::*;

  // Inter-Power Domain signals
  logic [4:0] intr_vector_pd_aon;
  prim_alert_pkg::alert_tx_t [38:0] alert_tx_pd_main;
  prim_alert_pkg::alert_rx_t [38:0] alert_rx_pd_main;
  logic       clk_aon;
  logic       clk_main;
  logic       rst_main_aon_n;
  logic       rst_main_n;
  logic       rst_main_shadowed_n;
  logic       rst_main_sys_n;
  pwrmgr_pkg::pwr_otp_req_t       pwrmgr_pwr_otp_req;
  pwrmgr_pkg::pwr_otp_rsp_t       pwrmgr_pwr_otp_rsp;
  lc_ctrl_pkg::pwr_lc_req_t       pwrmgr_pwr_lc_req;
  lc_ctrl_pkg::pwr_lc_rsp_t       pwrmgr_pwr_lc_rsp;
  logic       pwrmgr_strap;
  lc_ctrl_pkg::lc_tx_t       pwrmgr_fetch_en;
  rom_ctrl_pkg::pwrmgr_data_t       pwrmgr_rom_ctrl;
  prim_esc_pkg::esc_rx_t [2:0] alert_handler_esc_rx;
  prim_esc_pkg::esc_tx_t [2:0] alert_handler_esc_tx;
  edn_pkg::edn_req_t       edn0_edn_req;
  edn_pkg::edn_rsp_t       edn0_edn_rsp;
  otp_ctrl_pkg::sram_otp_key_req_t       otp_ctrl_sram_otp_key_req;
  otp_ctrl_pkg::sram_otp_key_rsp_t       otp_ctrl_sram_otp_key_rsp;
  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_dft_en;
  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_hw_debug_en;
  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_escalate_en;
  rv_core_ibex_pkg::cpu_crash_dump_t       rv_core_ibex_crash_dump;
  rv_core_ibex_pkg::cpu_pwrmgr_t       rv_core_ibex_pwrmgr;
  logic       rv_dm_ndmreset_req;
  tlul_pkg::tl_h2d_t       pwrmgr_tl_req;
  tlul_pkg::tl_d2h_t       pwrmgr_tl_rsp;
  tlul_pkg::tl_h2d_t       rstmgr_tl_req;
  tlul_pkg::tl_d2h_t       rstmgr_tl_rsp;
  tlul_pkg::tl_h2d_t       clkmgr_tl_req;
  tlul_pkg::tl_d2h_t       clkmgr_tl_rsp;
  tlul_pkg::tl_h2d_t       alert_handler_tl_req;
  tlul_pkg::tl_d2h_t       alert_handler_tl_rsp;
  tlul_pkg::tl_h2d_t       sram_ctrl_ret_regs_tl_req;
  tlul_pkg::tl_d2h_t       sram_ctrl_ret_regs_tl_rsp;
  tlul_pkg::tl_h2d_t       sram_ctrl_ret_ram_tl_req;
  tlul_pkg::tl_d2h_t       sram_ctrl_ret_ram_tl_rsp;

  lc_ctrl_pkg::lc_tx_t lc_ctrl_lc_nvm_debug_en;
  lc_ctrl_pkg::lc_tx_t lc_ctrl_lc_cpu_en;

  assign rst_main_no = rst_main_n;

  ///////////////////////////
  // Top-level Main Domain //
  ///////////////////////////
  peppermint_pd_main #(
  // Auto-inferred parameters
  .OtpMacroMemInitFile(OtpMacroMemInitFile),
  .SecLcCtrlVolatileRawUnlockEn(SecLcCtrlVolatileRawUnlockEn),
  .LcCtrlUseDmiInterface(LcCtrlUseDmiInterface),
  .LcCtrlSiliconCreatorId(LcCtrlSiliconCreatorId),
  .LcCtrlProductId(LcCtrlProductId),
  .LcCtrlRevisionId(LcCtrlRevisionId),
  .LcCtrlIdcodeValue(LcCtrlIdcodeValue),
  .RvDmIdcodeValue(RvDmIdcodeValue),
  .RvDmUseDmiInterface(RvDmUseDmiInterface),
  .SecRvDmVolatileRawUnlockEn(SecRvDmVolatileRawUnlockEn),
  .RvDmTlulHostUserRsvdBits(RvDmTlulHostUserRsvdBits),
  .AesAESGCMEnable(AesAESGCMEnable),
  .SecAesMasking(SecAesMasking),
  .SecAesSBoxImpl(SecAesSBoxImpl),
  .SecAesStartTriggerDelay(SecAesStartTriggerDelay),
  .SecAesAllowForcingMasks(SecAesAllowForcingMasks),
  .SecAesSkipPRNGReseeding(SecAesSkipPRNGReseeding),
  .KmacEnMasking(KmacEnMasking),
  .KmacSwKeyMasked(KmacSwKeyMasked),
  .SecKmacCmdDelay(SecKmacCmdDelay),
  .SecKmacIdleAcceptSwMsg(SecKmacIdleAcceptSwMsg),
  .KmacNumAppIntf(KmacNumAppIntf),
  .KmacAppCfg(KmacAppCfg),
  .OtbnStub(OtbnStub),
  .OtbnRegFile(OtbnRegFile),
  .SecOtbnMuteUrnd(SecOtbnMuteUrnd),
  .SecOtbnFixMaiOpSeq(SecOtbnFixMaiOpSeq),
  .SecOtbnSkipUrndReseedAtStart(SecOtbnSkipUrndReseedAtStart),
  .OtbnFeatStubMai(OtbnFeatStubMai),
  .KeymgrDpeKmacEnMasking(KeymgrDpeKmacEnMasking),
  .KeymgrDpeNumRomDigestInputs(KeymgrDpeNumRomDigestInputs),
  .CsrngSBoxImpl(CsrngSBoxImpl),
  .EntropySrcRngBusWidth(EntropySrcRngBusWidth),
  .EntropySrcRngBusBitSelWidth(EntropySrcRngBusBitSelWidth),
  .EntropySrcHealthTestWindowWidth(EntropySrcHealthTestWindowWidth),
  .EntropySrcStub(EntropySrcStub),
  .SramCtrlMainInstSize(SramCtrlMainInstSize),
  .SramCtrlMainNumRamInst(SramCtrlMainNumRamInst),
  .SramCtrlMainInstrExec(SramCtrlMainInstrExec),
  .SramCtrlMainNumPrinceRoundsHalf(SramCtrlMainNumPrinceRoundsHalf),
  .SramCtrlMainEccCorrection(SramCtrlMainEccCorrection),
  .RomCtrlBootRomInitFile(RomCtrlBootRomInitFile),
  .SecRomCtrlDisableScrambling(SecRomCtrlDisableScrambling),
  .DmaEnableDataIntgGen(DmaEnableDataIntgGen),
  .DmaEnableRspDataIntgCheck(DmaEnableRspDataIntgCheck),
  .DmaTlUserRsvd(DmaTlUserRsvd),
  .DmaSysRaclRole(DmaSysRaclRole),
  .DmaOtAgentId(DmaOtAgentId),
  .RvCoreIbexPMPEnable(RvCoreIbexPMPEnable),
  .RvCoreIbexPMPGranularity(RvCoreIbexPMPGranularity),
  .RvCoreIbexPMPNumRegions(RvCoreIbexPMPNumRegions),
  .RvCoreIbexMHPMCounterNum(RvCoreIbexMHPMCounterNum),
  .RvCoreIbexMHPMCounterWidth(RvCoreIbexMHPMCounterWidth),
  .RvCoreIbexPMPRstCfg(RvCoreIbexPMPRstCfg),
  .RvCoreIbexPMPRstAddr(RvCoreIbexPMPRstAddr),
  .RvCoreIbexPMPRstMsecCfg(RvCoreIbexPMPRstMsecCfg),
  .RvCoreIbexRV32E(RvCoreIbexRV32E),
  .RvCoreIbexRV32M(RvCoreIbexRV32M),
  .RvCoreIbexRV32B(RvCoreIbexRV32B),
  .RvCoreIbexRV32ZC(RvCoreIbexRV32ZC),
  .RvCoreIbexRegFile(RvCoreIbexRegFile),
  .RvCoreIbexBranchTargetALU(RvCoreIbexBranchTargetALU),
  .RvCoreIbexWritebackStage(RvCoreIbexWritebackStage),
  .RvCoreIbexICache(RvCoreIbexICache),
  .RvCoreIbexICacheECC(RvCoreIbexICacheECC),
  .RvCoreIbexICacheScramble(RvCoreIbexICacheScramble),
  .RvCoreIbexICacheNWays(RvCoreIbexICacheNWays),
  .RvCoreIbexBranchPredictor(RvCoreIbexBranchPredictor),
  .RvCoreIbexDbgTriggerEn(RvCoreIbexDbgTriggerEn),
  .RvCoreIbexDbgHwBreakNum(RvCoreIbexDbgHwBreakNum),
  .RvCoreIbexSecureIbex(RvCoreIbexSecureIbex),
  .RvCoreIbexDmBaseAddr(RvCoreIbexDmBaseAddr),
  .RvCoreIbexDmAddrMask(RvCoreIbexDmAddrMask),
  .RvCoreIbexDmHaltAddr(RvCoreIbexDmHaltAddr),
  .RvCoreIbexDmExceptionAddr(RvCoreIbexDmExceptionAddr),
  .RvCoreIbexPipeLine(RvCoreIbexPipeLine),
  .RvCoreIbexTlulHostUserRsvdBits(RvCoreIbexTlulHostUserRsvdBits),
  .RvCoreIbexCsrMvendorId(RvCoreIbexCsrMvendorId),
  .RvCoreIbexCsrMimpId(RvCoreIbexCsrMimpId),
  .AlertHandlerEscNumSeverities(AlertHandlerEscNumSeverities),
  .AlertHandlerEscPingCountWidth(AlertHandlerEscPingCountWidth)
  ) peppermint_pd_main (
    .lc_ctrl_lc_nvm_debug_en_o(lc_ctrl_lc_nvm_debug_en),
    .lc_ctrl_lc_cpu_en_o      (lc_ctrl_lc_cpu_en      ),
    .power_main_iso_en_i,
    .power_main_sw_en_i,
    .power_main_sw_en_phy_i,
    // Clocks and clock gating control from clkmgr
    .clk_aon_i(clk_aon),
    .clk_main_i(clk_main),

    // Resets and reset assert info from rstmgr
    .rst_main_aon_ni(rst_main_aon_n),
    .rst_main_ni(rst_main_n),
    .rst_main_shadowed_ni(rst_main_shadowed_n),
    .rst_main_sys_ni(rst_main_sys_n),

    // Manual DFT signals
    .scan_rst_ni,
    .scan_en_i,
    .scanmode_i,

    // Special inter-power domain signals (interrupts, alerts)
    .intr_vector_pd_aon_i(intr_vector_pd_aon),

    .alert_tx_o(alert_tx_pd_main),
    .alert_rx_i(alert_rx_pd_main),
    // Incoming interrupt for group soc
    .incoming_interrupt_soc_i(incoming_interrupt_soc_i),

    // Ports to and from other power domains (auto-generated)
    .pwrmgr_pwr_otp_req_i       (pwrmgr_pwr_otp_req       ),
    .pwrmgr_pwr_otp_rsp_o       (pwrmgr_pwr_otp_rsp       ),
    .pwrmgr_pwr_lc_req_i        (pwrmgr_pwr_lc_req        ),
    .pwrmgr_pwr_lc_rsp_o        (pwrmgr_pwr_lc_rsp        ),
    .pwrmgr_strap_i             (pwrmgr_strap             ),
    .pwrmgr_fetch_en_i          (pwrmgr_fetch_en          ),
    .pwrmgr_rom_ctrl_o          (pwrmgr_rom_ctrl          ),
    .alert_handler_esc_rx_o     (alert_handler_esc_rx     ),
    .alert_handler_esc_tx_i     (alert_handler_esc_tx     ),
    .edn0_edn_req_i             (edn0_edn_req             ),
    .edn0_edn_rsp_o             (edn0_edn_rsp             ),
    .otp_ctrl_sram_otp_key_req_i(otp_ctrl_sram_otp_key_req),
    .otp_ctrl_sram_otp_key_rsp_o(otp_ctrl_sram_otp_key_rsp),
    .lc_ctrl_lc_dft_en_o        (lc_ctrl_lc_dft_en        ),
    .lc_ctrl_lc_hw_debug_en_o   (lc_ctrl_lc_hw_debug_en   ),
    .lc_ctrl_lc_escalate_en_o   (lc_ctrl_lc_escalate_en   ),
    .rv_core_ibex_crash_dump_o  (rv_core_ibex_crash_dump  ),
    .rv_core_ibex_pwrmgr_o      (rv_core_ibex_pwrmgr      ),
    .rv_dm_ndmreset_req_o       (rv_dm_ndmreset_req       ),
    .pwrmgr_tl_req_o            (pwrmgr_tl_req            ),
    .pwrmgr_tl_rsp_i            (pwrmgr_tl_rsp            ),
    .rstmgr_tl_req_o            (rstmgr_tl_req            ),
    .rstmgr_tl_rsp_i            (rstmgr_tl_rsp            ),
    .clkmgr_tl_req_o            (clkmgr_tl_req            ),
    .clkmgr_tl_rsp_i            (clkmgr_tl_rsp            ),
    .alert_handler_tl_req_o     (alert_handler_tl_req     ),
    .alert_handler_tl_rsp_i     (alert_handler_tl_rsp     ),
    .sram_ctrl_ret_regs_tl_req_o(sram_ctrl_ret_regs_tl_req),
    .sram_ctrl_ret_regs_tl_rsp_i(sram_ctrl_ret_regs_tl_rsp),
    .sram_ctrl_ret_ram_tl_req_o (sram_ctrl_ret_ram_tl_req ),
    .sram_ctrl_ret_ram_tl_rsp_i (sram_ctrl_ret_ram_tl_rsp ),

    // Regular ports (auto-generated)
    .es_rng_enable_o,
    .es_rng_valid_i,
    .es_rng_bit_i,
    .es_rng_fips_o,
    .mbx0_doe_intr_o,
    .mbx0_doe_intr_en_o,
    .mbx0_doe_intr_support_o,
    .mbx0_doe_async_msg_support_o,
    .mbx1_doe_intr_o,
    .mbx1_doe_intr_en_o,
    .mbx1_doe_intr_support_o,
    .mbx1_doe_async_msg_support_o,
    .soc_mgr_ahb_req_o,
    .soc_mgr_ahb_rsp_i,
    .soc_mbx_ahb_req_i,
    .soc_mbx_ahb_rsp_o,
    .soc_dbg_tl_req_i,
    .soc_dbg_tl_rsp_o
  );


  ////////////////////////////////
  // Top-level Always-On domain //
  ////////////////////////////////
  peppermint_pd_aon #(
    .SocCpuBootAddrWidth(SocCpuBootAddrWidth),

  // Auto-inferred parameters
  .SecRstmgrCheck(SecRstmgrCheck),
  .SecRstmgrMaxSyncDelay(SecRstmgrMaxSyncDelay),
  .AlertHandlerEscNumSeverities(AlertHandlerEscNumSeverities),
  .AlertHandlerEscPingCountWidth(AlertHandlerEscPingCountWidth),
  .SramCtrlRetInstSize(SramCtrlRetInstSize),
  .SramCtrlRetNumRamInst(SramCtrlRetNumRamInst),
  .SramCtrlRetInstrExec(SramCtrlRetInstrExec),
  .SramCtrlRetNumPrinceRoundsHalf(SramCtrlRetNumPrinceRoundsHalf),
  .SramCtrlRetEccCorrection(SramCtrlRetEccCorrection)
  ) peppermint_pd_aon (
    .rst_aon_ni,
    .power_main_req_o,
    .power_main_ok_i,
    .clk_aon_ok_i,
    .clk_main_ok_i,
    .rst_soc_cpu_no,
    .soc_cpu_boot_addr_o,
    .soc_lc_dft_en_o,
    .soc_lc_nvm_debug_en_o,
    .soc_lc_hw_debug_en_o,
    .soc_lc_cpu_en_o,
    .lc_ctrl_lc_nvm_debug_en_i(lc_ctrl_lc_nvm_debug_en),
    .lc_ctrl_lc_cpu_en_i      (lc_ctrl_lc_cpu_en      ),
    // All externally supplied clocks
    .clk_aon_i(clk_aon_i),
    .clk_main_i(clk_main_i),
    // Clocks to the other power domains
    .clk_aon_o(clk_aon),
    .clk_main_o(clk_main),

    // Resets to the other power domains
    .rst_main_aon_no(rst_main_aon_n),
    .rst_main_no(rst_main_n),
    .rst_main_shadowed_no(rst_main_shadowed_n),
    .rst_main_sys_no(rst_main_sys_n),
    // Manual DFT signals
    .scan_rst_ni,
    .scan_en_i,
    .scanmode_i,

    // Special inter-power domain signals (interrupts, alerts)
    .intr_vector_o(intr_vector_pd_aon),

    .alert_tx_pd_main_i(alert_tx_pd_main),
    .alert_rx_pd_main_o(alert_rx_pd_main),
    // Incoming alerts for group soc
    .incoming_alert_soc_tx_i(incoming_alert_soc_tx_i),
    .incoming_alert_soc_rx_o(incoming_alert_soc_rx_o),
    .incoming_lpg_cg_en_soc_i(incoming_lpg_cg_en_soc_i),
    .incoming_lpg_rst_en_soc_i(incoming_lpg_rst_en_soc_i),

    // Ports to and from other power domains (auto-generated)
    .pwrmgr_pwr_otp_req_o       (pwrmgr_pwr_otp_req       ),
    .pwrmgr_pwr_otp_rsp_i       (pwrmgr_pwr_otp_rsp       ),
    .pwrmgr_pwr_lc_req_o        (pwrmgr_pwr_lc_req        ),
    .pwrmgr_pwr_lc_rsp_i        (pwrmgr_pwr_lc_rsp        ),
    .pwrmgr_strap_o             (pwrmgr_strap             ),
    .pwrmgr_fetch_en_o          (pwrmgr_fetch_en          ),
    .pwrmgr_rom_ctrl_i          (pwrmgr_rom_ctrl          ),
    .alert_handler_esc_rx_i     (alert_handler_esc_rx     ),
    .alert_handler_esc_tx_o     (alert_handler_esc_tx     ),
    .edn0_edn_req_o             (edn0_edn_req             ),
    .edn0_edn_rsp_i             (edn0_edn_rsp             ),
    .otp_ctrl_sram_otp_key_req_o(otp_ctrl_sram_otp_key_req),
    .otp_ctrl_sram_otp_key_rsp_i(otp_ctrl_sram_otp_key_rsp),
    .lc_ctrl_lc_dft_en_i        (lc_ctrl_lc_dft_en        ),
    .lc_ctrl_lc_hw_debug_en_i   (lc_ctrl_lc_hw_debug_en   ),
    .lc_ctrl_lc_escalate_en_i   (lc_ctrl_lc_escalate_en   ),
    .rv_core_ibex_crash_dump_i  (rv_core_ibex_crash_dump  ),
    .rv_core_ibex_pwrmgr_i      (rv_core_ibex_pwrmgr      ),
    .rv_dm_ndmreset_req_i       (rv_dm_ndmreset_req       ),
    .pwrmgr_tl_req_i            (pwrmgr_tl_req            ),
    .pwrmgr_tl_rsp_o            (pwrmgr_tl_rsp            ),
    .rstmgr_tl_req_i            (rstmgr_tl_req            ),
    .rstmgr_tl_rsp_o            (rstmgr_tl_rsp            ),
    .clkmgr_tl_req_i            (clkmgr_tl_req            ),
    .clkmgr_tl_rsp_o            (clkmgr_tl_rsp            ),
    .alert_handler_tl_req_i     (alert_handler_tl_req     ),
    .alert_handler_tl_rsp_o     (alert_handler_tl_rsp     ),
    .sram_ctrl_ret_regs_tl_req_i(sram_ctrl_ret_regs_tl_req),
    .sram_ctrl_ret_regs_tl_rsp_o(sram_ctrl_ret_regs_tl_rsp),
    .sram_ctrl_ret_ram_tl_req_i (sram_ctrl_ret_ram_tl_req ),
    .sram_ctrl_ret_ram_tl_rsp_o (sram_ctrl_ret_ram_tl_rsp ),

    // Regular ports (auto-generated)
    .wakeup_main_i
  );

endmodule
