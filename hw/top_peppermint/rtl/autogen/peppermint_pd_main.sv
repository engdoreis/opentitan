// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------//
// PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
//
// util/topgen.py -t hw/top_peppermint/data/top_peppermint.hjson
//                -o hw/top_peppermint/

`include "prim_assert.sv"

module peppermint_pd_main #(
  // Auto-inferred parameters
  // parameters for otp_macro
  parameter OtpMacroMemInitFile = "",
  // parameters for lc_ctrl
  parameter bit SecLcCtrlVolatileRawUnlockEn = 0,
  parameter bit LcCtrlUseDmiInterface = 1,
  parameter logic [15:0] LcCtrlSiliconCreatorId = 16'h 4003,
  parameter logic [15:0] LcCtrlProductId = 16'h 4100,
  parameter logic [7:0] LcCtrlRevisionId = 8'h 01,
  parameter logic [31:0] LcCtrlIdcodeValue = 32'h0000_0001,
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
  parameter bit SecOtbnFixMaiOpSeq = 0,
  parameter bit SecOtbnFixMacOpSeq = 0,
  parameter bit SecOtbnSkipUrndReseedAtStart = 0,
  parameter bit OtbnFeatStubMai = 0,
  // parameters for keymgr_dpe
  parameter bit KeymgrDpeKmacEnMasking = 1,
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
  parameter int SramCtrlMainNumAddrScrRounds = 2,
  parameter bit SramCtrlMainEccCorrection = 0,
  // parameters for rom_ctrl
  parameter RomCtrlBootRomInitFile = "",
  parameter bit SecRomCtrlDisableScrambling = 1'b0,
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
  parameter logic [31:0] RvCoreIbexCsrMimpId = '0,
  // parameters for rv_dm
  parameter logic [31:0] RvDmIdcodeValue = 32'h0000_0001,
  parameter bit RvDmUseDmiInterface = 1,
  parameter bit SecRvDmVolatileRawUnlockEn = 0,
  parameter logic [tlul_pkg::RsvdWidth-1:0] RvDmTlulHostUserRsvdBits = '0,
  // parameters for dma
  parameter bit DmaEnableDataIntgGen = 1'b1,
  parameter bit DmaEnableRspDataIntgCheck = 1'b1,
  parameter logic [tlul_pkg::RsvdWidth-1:0] DmaTlUserRsvd = '0,
  parameter top_racl_pkg::racl_role_t DmaSysRaclRole = '0,
  parameter int unsigned DmaOtAgentId = 0,
  // parameters for alert_handler
  parameter int AlertHandlerEscNumSeverities = 4,
  parameter int AlertHandlerEscPingCountWidth = 16
) (
  // Inter-module Signal External type
  input  pwrmgr_pkg::pwr_otp_req_t       pwrmgr_pwr_otp_req_i,
  output pwrmgr_pkg::pwr_otp_rsp_t       pwrmgr_pwr_otp_rsp_o,
  input  lc_ctrl_pkg::pwr_lc_req_t       pwrmgr_pwr_lc_req_i,
  output lc_ctrl_pkg::pwr_lc_rsp_t       pwrmgr_pwr_lc_rsp_o,
  input  logic       pwrmgr_strap_i,
  input  lc_ctrl_pkg::lc_tx_t       pwrmgr_fetch_en_i,
  output rom_ctrl_pkg::pwrmgr_data_t       pwrmgr_rom_ctrl_o,
  output prim_esc_pkg::esc_rx_t [2:0] alert_handler_esc_rx_o,
  input  prim_esc_pkg::esc_tx_t [2:0] alert_handler_esc_tx_i,
  input  edn_pkg::edn_req_t       edn0_edn_req_i,
  output edn_pkg::edn_rsp_t       edn0_edn_rsp_o,
  input  otp_ctrl_pkg::sram_otp_key_req_t       otp_ctrl_sram_otp_key_req_i,
  output otp_ctrl_pkg::sram_otp_key_rsp_t       otp_ctrl_sram_otp_key_rsp_o,
  output lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_dft_en_o,
  output lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_hw_debug_en_o,
  output lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_escalate_en_o,
  output rv_core_ibex_pkg::cpu_crash_dump_t       rv_core_ibex_crash_dump_o,
  output rv_core_ibex_pkg::cpu_pwrmgr_t       rv_core_ibex_pwrmgr_o,
  output logic       rv_dm_ndmreset_req_o,
  output tlul_pkg::tl_h2d_t       pwrmgr_tl_req_o,
  input  tlul_pkg::tl_d2h_t       pwrmgr_tl_rsp_i,
  output tlul_pkg::tl_h2d_t       rstmgr_tl_req_o,
  input  tlul_pkg::tl_d2h_t       rstmgr_tl_rsp_i,
  output tlul_pkg::tl_h2d_t       clkmgr_tl_req_o,
  input  tlul_pkg::tl_d2h_t       clkmgr_tl_rsp_i,
  output tlul_pkg::tl_h2d_t       alert_handler_tl_req_o,
  input  tlul_pkg::tl_d2h_t       alert_handler_tl_rsp_i,
  output tlul_pkg::tl_h2d_t       sram_ctrl_ret_regs_tl_req_o,
  input  tlul_pkg::tl_d2h_t       sram_ctrl_ret_regs_tl_rsp_i,
  output tlul_pkg::tl_h2d_t       sram_ctrl_ret_ram_tl_req_o,
  input  tlul_pkg::tl_d2h_t       sram_ctrl_ret_ram_tl_rsp_i,
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

  output lc_ctrl_pkg::lc_tx_t lc_ctrl_lc_nvm_debug_en_o,
  output lc_ctrl_pkg::lc_tx_t lc_ctrl_lc_cpu_en_o,
  output lc_ctrl_pkg::lc_tx_t lc_ctrl_lc_init_done_o,

  // Power gating control of the main power domain by the power controller of
  // the wider SoC.
  input logic power_main_iso_en_i,
  input logic power_main_sw_en_i,
  input logic power_main_sw_en_phy_i,

  // Incoming interrupt of group soc
  input logic [top_peppermint_pkg::NIncomingInterruptsSoc-1:0] incoming_interrupt_soc_i,
  // Interrupts from power domain Aon
  input  logic [4:0] intr_vector_pd_aon_i,

  // Alerts to power domain Aon
  input  prim_alert_pkg::alert_rx_t [38:0] alert_rx_i,
  output prim_alert_pkg::alert_tx_t [38:0] alert_tx_o,

  // Clocks from clkmgr in power domain Aon
  input logic clk_aon_i,
  input logic clk_main_i,

  // Resets from rstmgr in power domain Aon
  input logic rst_main_aon_ni,
  input logic rst_main_ni,
  input logic rst_main_shadowed_ni,
  input logic rst_main_sys_ni,

  // Manual DFT signals
  input                        scan_rst_ni, // reset used for test mode
  input                        scan_en_i,
  input prim_mubi_pkg::mubi4_t scanmode_i   // lc_ctrl_pkg::On for Scan
);

  import top_peppermint_pkg::*;
  // Compile-time random constants
  import top_peppermint_rnd_cnst_pkg::*;

  // Local Parameters
  // local parameters for lc_ctrl
  localparam int LcCtrlNumRmaAckSigs = 1;
  // local parameters for keymgr_dpe
  localparam int KeymgrDpeNumInstHwSlot = 4;
  localparam int KeymgrDpeNumBootStages = 3;
  localparam int KeymgrDpeNumRomDigestInputs = 1;
  // local parameters for entropy_src
  localparam int EntropySrcEsFifoDepth = 3;
  localparam int unsigned EntropySrcDistrFifoDepth = 3;
  // local parameters for edn0
  localparam int unsigned Edn0NumEndPoints = 8;
  // local parameters for edn1
  localparam int unsigned Edn1NumEndPoints = 1;
  // local parameters for sram_ctrl_main
  localparam int SramCtrlMainOutstanding = 2;
  // local parameters for rom_ctrl
  localparam bit RomCtrlFlopToKmac = 1'b1;
  // local parameters for rv_core_ibex
  localparam bit RvCoreIbexInstructionPipeline = 1;

  // Signals


  logic [41:0] intr_vector;
  // Interrupt source list
  logic intr_rv_timer_timer_expired_hart0_timer0;
  logic intr_otp_ctrl_otp_operation_done;
  logic intr_otp_ctrl_otp_error;
  logic intr_hmac_hmac_done;
  logic intr_hmac_fifo_empty;
  logic intr_hmac_hmac_err;
  logic intr_kmac_kmac_done;
  logic intr_kmac_fifo_empty;
  logic intr_kmac_kmac_err;
  logic intr_otbn_done;
  logic intr_keymgr_dpe_op_done;
  logic intr_csrng_cs_cmd_req_done;
  logic intr_csrng_cs_entropy_req;
  logic intr_csrng_cs_hw_inst_exc;
  logic intr_csrng_cs_fatal_err;
  logic intr_entropy_src_es_entropy_valid;
  logic intr_entropy_src_es_health_test_failed;
  logic intr_entropy_src_es_observe_fifo_ready;
  logic intr_entropy_src_es_fatal_err;
  logic intr_edn0_edn_cmd_req_done;
  logic intr_edn0_edn_fatal_err;
  logic intr_edn1_edn_cmd_req_done;
  logic intr_edn1_edn_fatal_err;
  logic intr_dma_dma_done;
  logic intr_dma_dma_chunk_done;
  logic intr_dma_dma_error;
  logic intr_mbx0_mbx_ready;
  logic intr_mbx0_mbx_abort;
  logic intr_mbx0_mbx_error;
  logic intr_mbx1_mbx_ready;
  logic intr_mbx1_mbx_abort;
  logic intr_mbx1_mbx_error;

  // Alert list


  // Define inter-module signals
  csrng_pkg::csrng_req_t [1:0] csrng_csrng_cmd_req;
  csrng_pkg::csrng_rsp_t [1:0] csrng_csrng_cmd_rsp;
  entropy_src_pkg::entropy_src_hw_if_req_t       csrng_entropy_src_hw_if_req;
  entropy_src_pkg::entropy_src_hw_if_rsp_t       csrng_entropy_src_hw_if_rsp;
  edn_pkg::edn_req_t [Edn0NumEndPoints-1:0] edn0_edn_req;
  edn_pkg::edn_rsp_t [Edn0NumEndPoints-1:0] edn0_edn_rsp;
  edn_pkg::edn_req_t [Edn1NumEndPoints-1:0] edn1_edn_req;
  edn_pkg::edn_rsp_t [Edn1NumEndPoints-1:0] edn1_edn_rsp;
  otp_ctrl_pkg::sram_otp_key_req_t [3:0] otp_ctrl_sram_otp_key_req;
  otp_ctrl_pkg::sram_otp_key_rsp_t [3:0] otp_ctrl_sram_otp_key_rsp;
  otp_ctrl_pkg::otbn_otp_key_req_t       otp_ctrl_otbn_otp_key_req;
  otp_ctrl_pkg::otbn_otp_key_rsp_t       otp_ctrl_otbn_otp_key_rsp;
  keymgr_dpe_pkg::keymgr_dpe_creator_root_key_t       otp_ctrl_keymgr_creator_root_key;
  keymgr_dpe_pkg::keymgr_dpe_creator_seed_t       otp_ctrl_keymgr_creator_seed;
  keymgr_dpe_pkg::keymgr_dpe_owner_seed_t       otp_ctrl_keymgr_owner_seed;
  otp_ctrl_macro_pkg::otp_ctrl_macro_req_t       otp_ctrl_otp_macro_req;
  otp_ctrl_macro_pkg::otp_ctrl_macro_rsp_t       otp_ctrl_otp_macro_rsp;
  rom_ctrl_pkg::keymgr_data_t [KeymgrDpeNumRomDigestInputs-1:0] keymgr_dpe_rom_digest;
  keymgr_pkg::hw_key_req_t       keymgr_dpe_aes_key;
  keymgr_pkg::hw_key_req_t       keymgr_dpe_kmac_key;
  keymgr_pkg::otbn_key_req_t       keymgr_dpe_otbn_key;
  kmac_pkg::app_req_t [KmacNumAppIntf-1:0] kmac_app_req;
  kmac_pkg::app_rsp_t [KmacNumAppIntf-1:0] kmac_app_rsp;
  logic       kmac_en_masking;
  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_nvm_rma_req;
  lc_ctrl_pkg::lc_tx_t       otbn_lc_rma_ack;
  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_clk_byp_ack;
  otp_ctrl_pkg::otp_lc_data_t       otp_ctrl_otp_lc_data;
  otp_ctrl_pkg::lc_otp_program_req_t       lc_ctrl_lc_otp_program_req;
  otp_ctrl_pkg::lc_otp_program_rsp_t       lc_ctrl_lc_otp_program_rsp;
  otp_macro_pkg::otp_test_req_t       lc_ctrl_lc_otp_vendor_test_req;
  otp_macro_pkg::otp_test_rsp_t       lc_ctrl_lc_otp_vendor_test_rsp;
  lc_ctrl_pkg::lc_keymgr_div_t       lc_ctrl_lc_keymgr_div;
  logic       lc_ctrl_strap_en_override;
  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_dft_en;
  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_hw_debug_clr;
  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_init_done;
  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_hw_debug_en;
  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_cpu_en;
  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_keymgr_en;
  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_escalate_en;
  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_check_byp_en;
  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_creator_seed_sw_rw_en;
  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_owner_seed_sw_rw_en;
  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_seed_hw_rd_en;
  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_rma_state;
  logic       rv_plic_msip;
  logic       rv_plic_irq;
  logic       rv_dm_debug_req;
  tlul_pkg::tl_h2d_t       main_tl_rv_core_ibex__corei_req;
  tlul_pkg::tl_d2h_t       main_tl_rv_core_ibex__corei_rsp;
  tlul_pkg::tl_h2d_t       main_tl_rv_core_ibex__cored_req;
  tlul_pkg::tl_d2h_t       main_tl_rv_core_ibex__cored_rsp;
  tlul_pkg::tl_h2d_t       main_tl_rv_dm__sba_req;
  tlul_pkg::tl_d2h_t       main_tl_rv_dm__sba_rsp;
  tlul_pkg::tl_h2d_t       main_tl_dma__host_req;
  tlul_pkg::tl_d2h_t       main_tl_dma__host_rsp;
  tlul_pkg::tl_h2d_t       main_tl_mbx0__sram_req;
  tlul_pkg::tl_d2h_t       main_tl_mbx0__sram_rsp;
  tlul_pkg::tl_h2d_t       main_tl_mbx1__sram_req;
  tlul_pkg::tl_d2h_t       main_tl_mbx1__sram_rsp;
  tlul_pkg::tl_h2d_t       rv_dm_regs_tl_d_req;
  tlul_pkg::tl_d2h_t       rv_dm_regs_tl_d_rsp;
  tlul_pkg::tl_h2d_t       rv_dm_mem_tl_d_req;
  tlul_pkg::tl_d2h_t       rv_dm_mem_tl_d_rsp;
  tlul_pkg::tl_h2d_t       rom_ctrl_rom_tl_req;
  tlul_pkg::tl_d2h_t       rom_ctrl_rom_tl_rsp;
  tlul_pkg::tl_h2d_t       rom_ctrl_regs_tl_req;
  tlul_pkg::tl_d2h_t       rom_ctrl_regs_tl_rsp;
  tlul_pkg::tl_h2d_t       sram_ctrl_main_regs_tl_req;
  tlul_pkg::tl_d2h_t       sram_ctrl_main_regs_tl_rsp;
  tlul_pkg::tl_h2d_t       sram_ctrl_main_ram_tl_req;
  tlul_pkg::tl_d2h_t       sram_ctrl_main_ram_tl_rsp;
  tlul_pkg::tl_h2d_t       otp_ctrl_core_tl_req;
  tlul_pkg::tl_d2h_t       otp_ctrl_core_tl_rsp;
  tlul_pkg::tl_h2d_t       otp_macro_prim_tl_req;
  tlul_pkg::tl_d2h_t       otp_macro_prim_tl_rsp;
  tlul_pkg::tl_h2d_t       lc_ctrl_regs_tl_req;
  tlul_pkg::tl_d2h_t       lc_ctrl_regs_tl_rsp;
  tlul_pkg::tl_h2d_t       rv_plic_tl_req;
  tlul_pkg::tl_d2h_t       rv_plic_tl_rsp;
  tlul_pkg::tl_h2d_t       rv_timer_tl_req;
  tlul_pkg::tl_d2h_t       rv_timer_tl_rsp;
  tlul_pkg::tl_h2d_t       aes_tl_req;
  tlul_pkg::tl_d2h_t       aes_tl_rsp;
  tlul_pkg::tl_h2d_t       hmac_tl_req;
  tlul_pkg::tl_d2h_t       hmac_tl_rsp;
  tlul_pkg::tl_h2d_t       kmac_tl_req;
  tlul_pkg::tl_d2h_t       kmac_tl_rsp;
  tlul_pkg::tl_h2d_t       otbn_tl_req;
  tlul_pkg::tl_d2h_t       otbn_tl_rsp;
  tlul_pkg::tl_h2d_t       keymgr_dpe_tl_req;
  tlul_pkg::tl_d2h_t       keymgr_dpe_tl_rsp;
  tlul_pkg::tl_h2d_t       csrng_tl_req;
  tlul_pkg::tl_d2h_t       csrng_tl_rsp;
  tlul_pkg::tl_h2d_t       entropy_src_tl_req;
  tlul_pkg::tl_d2h_t       entropy_src_tl_rsp;
  tlul_pkg::tl_h2d_t       edn0_tl_req;
  tlul_pkg::tl_d2h_t       edn0_tl_rsp;
  tlul_pkg::tl_h2d_t       edn1_tl_req;
  tlul_pkg::tl_d2h_t       edn1_tl_rsp;
  tlul_pkg::tl_h2d_t       rv_core_ibex_cfg_tl_d_req;
  tlul_pkg::tl_d2h_t       rv_core_ibex_cfg_tl_d_rsp;
  tlul_pkg::tl_h2d_t       dma_tl_d_req;
  tlul_pkg::tl_d2h_t       dma_tl_d_rsp;
  tlul_pkg::tl_h2d_t       ahb_bridge_ctn_tl_d_req;
  tlul_pkg::tl_d2h_t       ahb_bridge_ctn_tl_d_rsp;
  tlul_pkg::tl_h2d_t       mbx0_core_tl_d_req;
  tlul_pkg::tl_d2h_t       mbx0_core_tl_d_rsp;
  tlul_pkg::tl_h2d_t       mbx1_core_tl_d_req;
  tlul_pkg::tl_d2h_t       mbx1_core_tl_d_rsp;
  tlul_pkg::tl_h2d_t       socmbx_tl_ahb_bridge__socmbx_req;
  tlul_pkg::tl_d2h_t       socmbx_tl_ahb_bridge__socmbx_rsp;
  tlul_pkg::tl_h2d_t       mbx0_soc_tl_d_req;
  tlul_pkg::tl_d2h_t       mbx0_soc_tl_d_rsp;
  tlul_pkg::tl_h2d_t       mbx1_soc_tl_d_req;
  tlul_pkg::tl_d2h_t       mbx1_soc_tl_d_rsp;
  tlul_pkg::tl_h2d_t       lc_ctrl_dmi_tl_req;
  tlul_pkg::tl_d2h_t       lc_ctrl_dmi_tl_rsp;
  tlul_pkg::tl_h2d_t       rv_dm_dbg_tl_d_req;
  tlul_pkg::tl_d2h_t       rv_dm_dbg_tl_d_rsp;
  lc_ctrl_pkg::lc_tx_t       lc_ctrl_lc_nvm_debug_en;
  logic       rv_core_ibex_irq_timer;
  logic [31:0] rv_core_ibex_hart_id;
  logic [31:0] rv_core_ibex_boot_addr;
  otp_ctrl_part_pkg::otp_broadcast_t       otp_ctrl_otp_broadcast;
  prim_mubi_pkg::mubi8_t       csrng_otp_en_csrng_sw_app_read;
  otp_ctrl_pkg::otp_device_id_t       lc_ctrl_otp_device_id;
  otp_ctrl_pkg::otp_manuf_state_t       lc_ctrl_otp_manuf_state;
  keymgr_dpe_pkg::keymgr_dpe_device_id_t       keymgr_dpe_device_id;
  prim_mubi_pkg::mubi8_t       sram_ctrl_main_otp_en_sram_ifetch;
  prim_mubi_pkg::mubi8_t       rv_dm_otp_dis_rv_dm_late_debug;

  // Create mixed connections to ports
  assign edn0_edn_req[3] = edn0_edn_req_i;
  assign edn0_edn_rsp_o = edn0_edn_rsp[3];
  assign otp_ctrl_sram_otp_key_req[1] = otp_ctrl_sram_otp_key_req_i;
  assign otp_ctrl_sram_otp_key_rsp_o = otp_ctrl_sram_otp_key_rsp[1];
  assign lc_ctrl_lc_dft_en_o = lc_ctrl_lc_dft_en;
  assign lc_ctrl_lc_hw_debug_en_o = lc_ctrl_lc_hw_debug_en;
  assign lc_ctrl_lc_escalate_en_o = lc_ctrl_lc_escalate_en;

  // Dummy signal definitions for unused partial inter-module signals
  edn_pkg::edn_rsp_t unused_edn0_edn_rsp7;
  otp_ctrl_pkg::sram_otp_key_rsp_t unused_otp_ctrl_sram_otp_key_rsp3;

  // Assign unused partial inter-module signals
  assign unused_edn0_edn_rsp7 = edn0_edn_rsp[7];
  assign unused_otp_ctrl_sram_otp_key_rsp3 = otp_ctrl_sram_otp_key_rsp[3];

  // Assign undriven partial inter-module signals
  assign edn0_edn_req[7] = '0;
  assign otp_ctrl_sram_otp_key_req[3] = '0;

  // OTP HW_CFG broadcast signals; struct breakout done by hand.
  assign csrng_otp_en_csrng_sw_app_read =
      otp_ctrl_otp_broadcast.hw_cfg1_data.en_csrng_sw_app_read;
  assign sram_ctrl_main_otp_en_sram_ifetch =
      otp_ctrl_otp_broadcast.hw_cfg1_data.en_sram_ifetch;
  assign lc_ctrl_otp_device_id =
      otp_ctrl_otp_broadcast.hw_cfg0_data.device_id;
  assign lc_ctrl_otp_manuf_state =
      otp_ctrl_otp_broadcast.hw_cfg0_data.manuf_state;
  assign keymgr_dpe_device_id =
      otp_ctrl_otp_broadcast.hw_cfg0_data.device_id;

  logic unused_otp_broadcast_bits;
  assign unused_otp_broadcast_bits = ^{
    otp_ctrl_otp_broadcast.valid,
    otp_ctrl_otp_broadcast.hw_cfg0_data.hw_cfg0_digest,
    otp_ctrl_otp_broadcast.hw_cfg1_data.hw_cfg1_digest,
    otp_ctrl_otp_broadcast.hw_cfg1_data.unallocated
    // No hardware consumer for the SoC debug state: the debug policy block
    // is not instantiated in Peppermint. The OTP field has been removed.
  };

  // Ibex-specific assignments.
  assign rv_core_ibex_irq_timer = intr_rv_timer_timer_expired_hart0_timer0;
  assign rv_core_ibex_hart_id   = '0;
  assign rv_core_ibex_boot_addr = tl_main_pkg::ADDR_SPACE_ROM_CTRL__ROM;

  // Unconditionally disable the late debug feature (early debug).
  assign rv_dm_otp_dis_rv_dm_late_debug = prim_mubi_pkg::MuBi8True;

  // Life cycle function control to the Aon power domain.
  assign lc_ctrl_lc_nvm_debug_en_o = lc_ctrl_lc_nvm_debug_en;
  assign lc_ctrl_lc_cpu_en_o       = lc_ctrl_lc_cpu_en;
  assign lc_ctrl_lc_init_done_o    = lc_ctrl_lc_init_done;

  // These signals drive physical cells only.
  logic unused_power_gating_ctrl;
  assign unused_power_gating_ctrl = ^{
    power_main_iso_en_i,
    power_main_sw_en_i,
    power_main_sw_en_phy_i
  };

  // Chip IO tie-off.
  otp_macro_pkg::otp_test_vect_t cio_otp_macro_test_d2p_o;
  otp_macro_pkg::otp_test_vect_t cio_otp_macro_test_en_d2p_o;

  logic unused_cio_bits;
  assign unused_cio_bits = ^{
    cio_otp_macro_test_d2p_o,
    cio_otp_macro_test_en_d2p_o
  };


  // Instantiation of IPs
  rv_timer #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[0]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles)
  ) u_rv_timer (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .rst_ni(rst_main_ni),

    // Interrupts
    .intr_timer_expired_hart0_timer0_o(intr_rv_timer_timer_expired_hart0_timer0),

    // alert_handler[0]: fatal_fault
    .alert_tx_o(alert_tx_o[0]),
    .alert_rx_i(alert_rx_i[0]),

    // Inter-module signals
    .racl_policies_i(top_racl_pkg::RACL_POLICY_VEC_DEFAULT),
    .racl_error_o(),
    .tl_i(rv_timer_tl_req),
    .tl_o(rv_timer_tl_rsp)
  );

  otp_ctrl #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[5:1]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles),
    .RndCnstLfsrSeed(RndCnstOtpCtrlLfsrSeed),
    .RndCnstLfsrPerm(RndCnstOtpCtrlLfsrPerm),
    .RndCnstScrmblKeyInit(RndCnstOtpCtrlScrmblKeyInit),
    .RndCnstScrmblKey0(RndCnstOtpCtrlScrmblKey0),
    .RndCnstScrmblKey1(RndCnstOtpCtrlScrmblKey1),
    .RndCnstScrmblKey2(RndCnstOtpCtrlScrmblKey2),
    .RndCnstScrmblKey3(RndCnstOtpCtrlScrmblKey3),
    .RndCnstDigestConst0(RndCnstOtpCtrlDigestConst0),
    .RndCnstDigestConst1(RndCnstOtpCtrlDigestConst1),
    .RndCnstDigestIV0(RndCnstOtpCtrlDigestIV0),
    .RndCnstDigestIV1(RndCnstOtpCtrlDigestIV1),
    .RndCnstPartInvDefault(RndCnstOtpCtrlPartInvDefault)
  ) u_otp_ctrl (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .clk_edn_i(clk_main_i),
    .rst_ni(rst_main_ni),
    .rst_edn_ni(rst_main_ni),

    // Interrupts
    .intr_otp_operation_done_o(intr_otp_ctrl_otp_operation_done),
    .intr_otp_error_o         (intr_otp_ctrl_otp_error),

    // alert_handler[1]: fatal_macro_error
    // alert_handler[2]: fatal_check_error
    // alert_handler[3]: fatal_bus_integ_error
    // alert_handler[4]: fatal_prim_otp_alert
    // alert_handler[5]: recov_prim_otp_alert
    .alert_tx_o(alert_tx_o[5:1]),
    .alert_rx_i(alert_rx_i[5:1]),

    // Inter-module signals
    .edn_o(edn0_edn_req[1]),
    .edn_i(edn0_edn_rsp[1]),
    .pwr_otp_i(pwrmgr_pwr_otp_req_i),
    .pwr_otp_o(pwrmgr_pwr_otp_rsp_o),
    .lc_otp_program_i(lc_ctrl_lc_otp_program_req),
    .lc_otp_program_o(lc_ctrl_lc_otp_program_rsp),
    .otp_lc_data_o(otp_ctrl_otp_lc_data),
    .lc_escalate_en_i(lc_ctrl_lc_escalate_en),
    .lc_creator_seed_sw_rw_en_i(lc_ctrl_lc_creator_seed_sw_rw_en),
    .lc_owner_seed_sw_rw_en_i(lc_ctrl_lc_owner_seed_sw_rw_en),
    .lc_seed_hw_rd_en_i(lc_ctrl_lc_seed_hw_rd_en),
    .lc_rma_state_i(lc_ctrl_lc_rma_state),
    .lc_check_byp_en_i(lc_ctrl_lc_check_byp_en),
    .keymgr_creator_root_key_o(otp_ctrl_keymgr_creator_root_key),
    .keymgr_creator_seed_o(otp_ctrl_keymgr_creator_seed),
    .keymgr_owner_seed_o(otp_ctrl_keymgr_owner_seed),
    .sram_otp_key_i(otp_ctrl_sram_otp_key_req),
    .sram_otp_key_o(otp_ctrl_sram_otp_key_rsp),
    .otbn_otp_key_i(otp_ctrl_otbn_otp_key_req),
    .otbn_otp_key_o(otp_ctrl_otbn_otp_key_rsp),
    .otp_broadcast_o(otp_ctrl_otp_broadcast),
    .otp_macro_o(otp_ctrl_otp_macro_req),
    .otp_macro_i(otp_ctrl_otp_macro_rsp),
    .core_tl_i(otp_ctrl_core_tl_req),
    .core_tl_o(otp_ctrl_core_tl_rsp)
  );

  otp_macro #(
    .Width(otp_ctrl_macro_pkg::OtpWidth),
    .Depth(otp_ctrl_macro_pkg::OtpDepth),
    .SizeWidth(otp_ctrl_macro_pkg::OtpSizeWidth),
    .MemInitFile(OtpMacroMemInitFile),
    .VendorTestOffset(otp_ctrl_reg_pkg::VendorTestOffset),
    .VendorTestSize(otp_ctrl_reg_pkg::VendorTestSize)
  ) u_otp_macro (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .rst_ni(rst_main_ni),

    // DFT/scan connections
    .scanmode_i,
    .scan_rst_ni,
    .scan_en_i,


    // CIO outputs
    .cio_test_o   (cio_otp_macro_test_d2p_o),
    .cio_test_en_o(cio_otp_macro_test_en_d2p_o),

    // Inter-module signals
    .obs_ctrl_i(ast_pkg::AST_OBS_CTRL_DEFAULT),
    .otp_obs_o(),
    .pwr_seq_o(),
    .pwr_seq_h_i('0),
    .ext_voltage_h_io(),
    .lc_dft_en_i(lc_ctrl_lc_dft_en),
    .test_i(lc_ctrl_lc_otp_vendor_test_req),
    .test_o(lc_ctrl_lc_otp_vendor_test_rsp),
    .otp_i(otp_ctrl_otp_macro_req),
    .otp_o(otp_ctrl_otp_macro_rsp),
    .cfg_i('0),
    .cfg_rsp_o(),
    .racl_policies_i(top_racl_pkg::RACL_POLICY_VEC_DEFAULT),
    .racl_error_o(),
    .prim_tl_i(otp_macro_prim_tl_req),
    .prim_tl_o(otp_macro_prim_tl_rsp)
  );

  lc_ctrl #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[8:6]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles),
    .SecVolatileRawUnlockEn(SecLcCtrlVolatileRawUnlockEn),
    .UseDmiInterface(LcCtrlUseDmiInterface),
    .RndCnstLcKeymgrDivInvalid(RndCnstLcCtrlLcKeymgrDivInvalid),
    .RndCnstLcKeymgrDivTestUnlocked(RndCnstLcCtrlLcKeymgrDivTestUnlocked),
    .RndCnstLcKeymgrDivDev(RndCnstLcCtrlLcKeymgrDivDev),
    .RndCnstLcKeymgrDivProduction(RndCnstLcCtrlLcKeymgrDivProduction),
    .RndCnstLcKeymgrDivRma(RndCnstLcCtrlLcKeymgrDivRma),
    .RndCnstInvalidTokens(RndCnstLcCtrlInvalidTokens),
    .SiliconCreatorId(LcCtrlSiliconCreatorId),
    .ProductId(LcCtrlProductId),
    .RevisionId(LcCtrlRevisionId),
    .IdcodeValue(LcCtrlIdcodeValue),
    .NumRmaAckSigs(LcCtrlNumRmaAckSigs),
    .EscNumSeverities(AlertHandlerEscNumSeverities),
    .EscPingCountWidth(AlertHandlerEscPingCountWidth)
  ) u_lc_ctrl (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .clk_kmac_i(clk_main_i),
    .rst_ni(rst_main_ni),
    .rst_kmac_ni(rst_main_ni),

    // DFT/scan connections
    .scanmode_i,
    .scan_rst_ni,

    // alert_handler[6]: fatal_prog_error
    // alert_handler[7]: fatal_state_error
    // alert_handler[8]: fatal_bus_integ_error
    .alert_tx_o(alert_tx_o[8:6]),
    .alert_rx_i(alert_rx_i[8:6]),

    // Inter-module signals
    .jtag_i(jtag_pkg::JTAG_REQ_DEFAULT),
    .jtag_o(),
    .esc_scrap_state0_tx_i(alert_handler_esc_tx_i[1]),
    .esc_scrap_state0_rx_o(alert_handler_esc_rx_o[1]),
    .esc_scrap_state1_tx_i(alert_handler_esc_tx_i[2]),
    .esc_scrap_state1_rx_o(alert_handler_esc_rx_o[2]),
    .pwr_lc_i(pwrmgr_pwr_lc_req_i),
    .pwr_lc_o(pwrmgr_pwr_lc_rsp_o),
    .lc_otp_vendor_test_o(lc_ctrl_lc_otp_vendor_test_req),
    .lc_otp_vendor_test_i(lc_ctrl_lc_otp_vendor_test_rsp),
    .otp_lc_data_i(otp_ctrl_otp_lc_data),
    .lc_otp_program_o(lc_ctrl_lc_otp_program_req),
    .lc_otp_program_i(lc_ctrl_lc_otp_program_rsp),
    .kmac_data_o(kmac_app_req[1]),
    .kmac_data_i(kmac_app_rsp[1]),
    .lc_init_done_o(lc_ctrl_lc_init_done),
    .lc_raw_test_rma_o(),
    .lc_dft_en_o(lc_ctrl_lc_dft_en),
    .lc_nvm_debug_en_o(lc_ctrl_lc_nvm_debug_en),
    .lc_hw_debug_clr_o(lc_ctrl_lc_hw_debug_clr),
    .lc_hw_debug_en_o(lc_ctrl_lc_hw_debug_en),
    .lc_cpu_en_o(lc_ctrl_lc_cpu_en),
    .lc_keymgr_en_o(lc_ctrl_lc_keymgr_en),
    .lc_escalate_en_o(lc_ctrl_lc_escalate_en),
    .lc_clk_byp_req_o(lc_ctrl_lc_clk_byp_ack),
    .lc_clk_byp_ack_i(lc_ctrl_lc_clk_byp_ack),
    .lc_nvm_rma_req_o(lc_ctrl_lc_nvm_rma_req),
    .lc_nvm_rma_ack_i(otbn_lc_rma_ack),
    .lc_nvm_rma_seed_o(),
    .lc_check_byp_en_o(lc_ctrl_lc_check_byp_en),
    .lc_creator_seed_sw_rw_en_o(lc_ctrl_lc_creator_seed_sw_rw_en),
    .lc_owner_seed_sw_rw_en_o(lc_ctrl_lc_owner_seed_sw_rw_en),
    .lc_iso_part_sw_rd_en_o(),
    .lc_iso_part_sw_wr_en_o(),
    .lc_seed_hw_rd_en_o(lc_ctrl_lc_seed_hw_rd_en),
    .lc_rma_state_o(lc_ctrl_lc_rma_state),
    .lc_keymgr_div_o(lc_ctrl_lc_keymgr_div),
    .otp_device_id_i(lc_ctrl_otp_device_id),
    .otp_manuf_state_i(lc_ctrl_otp_manuf_state),
    .hw_rev_o(),
    .strap_en_override_o(lc_ctrl_strap_en_override),
    .regs_tl_i(lc_ctrl_regs_tl_req),
    .regs_tl_o(lc_ctrl_regs_tl_rsp),
    .dmi_tl_i(lc_ctrl_dmi_tl_req),
    .dmi_tl_o(lc_ctrl_dmi_tl_rsp)
  );

  aes #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[10:9]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles),
    .AES192Enable(1'b1),
    .AESGCMEnable(AesAESGCMEnable),
    .SecMasking(SecAesMasking),
    .SecSBoxImpl(SecAesSBoxImpl),
    .SecStartTriggerDelay(SecAesStartTriggerDelay),
    .SecAllowForcingMasks(SecAesAllowForcingMasks),
    .SecSkipPRNGReseeding(SecAesSkipPRNGReseeding),
    .RndCnstClearingLfsrSeed(RndCnstAesClearingLfsrSeed),
    .RndCnstClearingLfsrPerm(RndCnstAesClearingLfsrPerm),
    .RndCnstClearingSharePerm(RndCnstAesClearingSharePerm),
    .RndCnstMaskingLfsrSeed(RndCnstAesMaskingLfsrSeed),
    .RndCnstMaskingLfsrPerm(RndCnstAesMaskingLfsrPerm)
  ) u_aes (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .clk_edn_i(clk_main_i),
    .rst_shadowed_ni(rst_main_shadowed_ni),
    .rst_ni(rst_main_ni),
    .rst_edn_ni(rst_main_ni),

    // alert_handler[9]: recov_ctrl_update_err
    // alert_handler[10]: fatal_fault
    .alert_tx_o(alert_tx_o[10:9]),
    .alert_rx_i(alert_rx_i[10:9]),

    // Inter-module signals
    .idle_o(),
    .output_valid_o(),
    .input_ready_o(),
    .lc_escalate_en_i(lc_ctrl_lc_escalate_en),
    .edn_o(edn0_edn_req[4]),
    .edn_i(edn0_edn_rsp[4]),
    .keymgr_key_i(keymgr_dpe_aes_key),
    .tl_i(aes_tl_req),
    .tl_o(aes_tl_rsp)
  );

  hmac #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[11]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles)
  ) u_hmac (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .rst_ni(rst_main_ni),

    // Interrupts
    .intr_hmac_done_o (intr_hmac_hmac_done),
    .intr_fifo_empty_o(intr_hmac_fifo_empty),
    .intr_hmac_err_o  (intr_hmac_hmac_err),

    // alert_handler[11]: fatal_fault
    .alert_tx_o(alert_tx_o[11]),
    .alert_rx_i(alert_rx_i[11]),

    // Inter-module signals
    .idle_o(),
    .keymgr_key_i(keymgr_pkg::HW_KEY_REQ_DEFAULT),
    .tl_i(hmac_tl_req),
    .tl_o(hmac_tl_rsp)
  );

  kmac #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[13:12]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles),
    .EnMasking(KmacEnMasking),
    .SwKeyMasked(KmacSwKeyMasked),
    .SecCmdDelay(SecKmacCmdDelay),
    .SecIdleAcceptSwMsg(SecKmacIdleAcceptSwMsg),
    .NumAppIntf(KmacNumAppIntf),
    .AppCfg(KmacAppCfg),
    .RndCnstLfsrSeed(RndCnstKmacLfsrSeed),
    .RndCnstLfsrPerm(RndCnstKmacLfsrPerm),
    .RndCnstBufferLfsrSeed(RndCnstKmacBufferLfsrSeed),
    .RndCnstMsgPerm(RndCnstKmacMsgPerm)
  ) u_kmac (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .clk_edn_i(clk_main_i),
    .rst_shadowed_ni(rst_main_shadowed_ni),
    .rst_ni(rst_main_ni),
    .rst_edn_ni(rst_main_ni),

    // Interrupts
    .intr_kmac_done_o (intr_kmac_kmac_done),
    .intr_fifo_empty_o(intr_kmac_fifo_empty),
    .intr_kmac_err_o  (intr_kmac_kmac_err),

    // alert_handler[12]: recov_operation_err
    // alert_handler[13]: fatal_fault_err
    .alert_tx_o(alert_tx_o[13:12]),
    .alert_rx_i(alert_rx_i[13:12]),

    // Inter-module signals
    .keymgr_key_i(keymgr_dpe_kmac_key),
    .app_i(kmac_app_req),
    .app_o(kmac_app_rsp),
    .entropy_o(edn0_edn_req[2]),
    .entropy_i(edn0_edn_rsp[2]),
    .idle_o(),
    .en_masking_o(kmac_en_masking),
    .lc_escalate_en_i(lc_ctrl_lc_escalate_en),
    .tl_i(kmac_tl_req),
    .tl_o(kmac_tl_rsp)
  );

  otbn #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[15:14]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles),
    .Stub(OtbnStub),
    .RegFile(OtbnRegFile),
    .RndCnstUrndPrngSeed(RndCnstOtbnUrndPrngSeed),
    .SecFixMaiOpSeq(SecOtbnFixMaiOpSeq),
    .SecFixMacOpSeq(SecOtbnFixMacOpSeq),
    .SecSkipUrndReseedAtStart(SecOtbnSkipUrndReseedAtStart),
    .FeatStubMai(OtbnFeatStubMai),
    .RndCnstBnMacUrndPerm(RndCnstOtbnBnMacUrndPerm),
    .RndCnstOtbnKey(RndCnstOtbnOtbnKey),
    .RndCnstOtbnNonce(RndCnstOtbnOtbnNonce)
  ) u_otbn (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .clk_edn_i(clk_main_i),
    .clk_otp_i(clk_main_i),
    .rst_ni(rst_main_ni),
    .rst_edn_ni(rst_main_ni),
    .rst_otp_ni(rst_main_ni),

    // Interrupts
    .intr_done_o(intr_otbn_done),

    // alert_handler[14]: fatal
    // alert_handler[15]: recov
    .alert_tx_o(alert_tx_o[15:14]),
    .alert_rx_i(alert_rx_i[15:14]),

    // Inter-module signals
    .otbn_otp_key_o(otp_ctrl_otbn_otp_key_req),
    .otbn_otp_key_i(otp_ctrl_otbn_otp_key_rsp),
    .edn_rnd_o(edn1_edn_req[0]),
    .edn_rnd_i(edn1_edn_rsp[0]),
    .edn_urnd_o(edn0_edn_req[5]),
    .edn_urnd_i(edn0_edn_rsp[5]),
    .idle_o(),
    .ram_cfg_imem_i(prim_ram_1p_pkg::RAM_1P_CFG_REQ_DEFAULT),
    .ram_cfg_imem_o(),
    .ram_cfg_dmem_i(prim_ram_1p_pkg::RAM_1P_CFG_REQ_DEFAULT),
    .ram_cfg_dmem_o(),
    .lc_escalate_en_i(lc_ctrl_lc_escalate_en),
    .lc_rma_req_i(lc_ctrl_lc_nvm_rma_req),
    .lc_rma_ack_o(otbn_lc_rma_ack),
    .keymgr_key_i(keymgr_dpe_otbn_key),
    .kmac_data_o(),
    .kmac_data_i(kmac_pkg::APP_RSP_DEFAULT),
    .tl_i(otbn_tl_req),
    .tl_o(otbn_tl_rsp)
  );

  keymgr_dpe #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[17:16]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles),
    .KmacEnMasking(KeymgrDpeKmacEnMasking),
    .RndCnstLfsrSeed(RndCnstKeymgrDpeLfsrSeed),
    .RndCnstLfsrPerm(RndCnstKeymgrDpeLfsrPerm),
    .RndCnstRandPerm(RndCnstKeymgrDpeRandPerm),
    .RndCnstRevisionSeed(RndCnstKeymgrDpeRevisionSeed),
    .RndCnstSoftOutputSeed(RndCnstKeymgrDpeSoftOutputSeed),
    .RndCnstHardOutputSeed(RndCnstKeymgrDpeHardOutputSeed),
    .RndCnstAesSeed(RndCnstKeymgrDpeAesSeed),
    .RndCnstKmacSeed(RndCnstKeymgrDpeKmacSeed),
    .RndCnstOtbnSeed(RndCnstKeymgrDpeOtbnSeed),
    .RndCnstNoneSeed(RndCnstKeymgrDpeNoneSeed),
    .NumInstHwSlot(KeymgrDpeNumInstHwSlot),
    .NumBootStages(KeymgrDpeNumBootStages),
    .NumRomDigestInputs(KeymgrDpeNumRomDigestInputs)
  ) u_keymgr_dpe (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .clk_edn_i(clk_main_i),
    .rst_shadowed_ni(rst_main_shadowed_ni),
    .rst_ni(rst_main_ni),
    .rst_edn_ni(rst_main_ni),

    // Interrupts
    .intr_op_done_o(intr_keymgr_dpe_op_done),

    // alert_handler[16]: recov_operation_err
    // alert_handler[17]: fatal_fault_err
    .alert_tx_o(alert_tx_o[17:16]),
    .alert_rx_i(alert_rx_i[17:16]),

    // Inter-module signals
    .edn_o(edn0_edn_req[0]),
    .edn_i(edn0_edn_rsp[0]),
    .aes_key_o(keymgr_dpe_aes_key),
    .kmac_key_o(keymgr_dpe_kmac_key),
    .hmac_key_o(),
    .otbn_key_o(keymgr_dpe_otbn_key),
    .kmac_data_o(kmac_app_req[0]),
    .kmac_data_i(kmac_app_rsp[0]),
    .creator_root_key_i(otp_ctrl_keymgr_creator_root_key),
    .creator_seed_i(otp_ctrl_keymgr_creator_seed),
    .owner_seed_i(otp_ctrl_keymgr_owner_seed),
    .device_id_i(keymgr_dpe_device_id),
    .lc_keymgr_en_i(lc_ctrl_lc_keymgr_en),
    .lc_keymgr_div_i(lc_ctrl_lc_keymgr_div),
    .rom_digest_i(keymgr_dpe_rom_digest),
    .kmac_en_masking_i(kmac_en_masking),
    .tl_i(keymgr_dpe_tl_req),
    .tl_o(keymgr_dpe_tl_rsp)
  );

  csrng #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[19:18]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles),
    .RndCnstCsKeymgrDivNonProduction(RndCnstCsrngCsKeymgrDivNonProduction),
    .RndCnstCsKeymgrDivProduction(RndCnstCsrngCsKeymgrDivProduction),
    .SBoxImpl(CsrngSBoxImpl)
  ) u_csrng (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .rst_ni(rst_main_ni),

    // Interrupts
    .intr_cs_cmd_req_done_o(intr_csrng_cs_cmd_req_done),
    .intr_cs_entropy_req_o (intr_csrng_cs_entropy_req),
    .intr_cs_hw_inst_exc_o (intr_csrng_cs_hw_inst_exc),
    .intr_cs_fatal_err_o   (intr_csrng_cs_fatal_err),

    // alert_handler[18]: recov_alert
    // alert_handler[19]: fatal_alert
    .alert_tx_o(alert_tx_o[19:18]),
    .alert_rx_i(alert_rx_i[19:18]),

    // Inter-module signals
    .csrng_cmd_i(csrng_csrng_cmd_req),
    .csrng_cmd_o(csrng_csrng_cmd_rsp),
    .entropy_src_hw_if_o(csrng_entropy_src_hw_if_req),
    .entropy_src_hw_if_i(csrng_entropy_src_hw_if_rsp),
    .otp_en_csrng_sw_app_read_i(csrng_otp_en_csrng_sw_app_read),
    .lc_hw_debug_en_i(lc_ctrl_lc_hw_debug_en),
    .tl_i(csrng_tl_req),
    .tl_o(csrng_tl_rsp)
  );

  entropy_src #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[21:20]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles),
    .RngBusWidth(EntropySrcRngBusWidth),
    .RngBusBitSelWidth(EntropySrcRngBusBitSelWidth),
    .HealthTestWindowWidth(EntropySrcHealthTestWindowWidth),
    .EsFifoDepth(EntropySrcEsFifoDepth),
    .DistrFifoDepth(EntropySrcDistrFifoDepth),
    .Stub(EntropySrcStub)
  ) u_entropy_src (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .rst_ni(rst_main_ni),

    // Interrupts
    .intr_es_entropy_valid_o     (intr_entropy_src_es_entropy_valid),
    .intr_es_health_test_failed_o(intr_entropy_src_es_health_test_failed),
    .intr_es_observe_fifo_ready_o(intr_entropy_src_es_observe_fifo_ready),
    .intr_es_fatal_err_o         (intr_entropy_src_es_fatal_err),

    // alert_handler[20]: recov_alert
    // alert_handler[21]: fatal_alert
    .alert_tx_o(alert_tx_o[21:20]),
    .alert_rx_i(alert_rx_i[21:20]),

    // Inter-module signals
    .entropy_src_hw_if_i(csrng_entropy_src_hw_if_req),
    .entropy_src_hw_if_o(csrng_entropy_src_hw_if_rsp),
    .entropy_src_rng_enable_o(es_rng_enable_o),
    .entropy_src_rng_valid_i(es_rng_valid_i),
    .entropy_src_rng_bits_i(es_rng_bit_i),
    .entropy_src_xht_valid_o(),
    .entropy_src_xht_bits_o(),
    .entropy_src_xht_bit_sel_o(),
    .entropy_src_xht_health_test_window_o(),
    .entropy_src_xht_meta_o(),
    .entropy_src_xht_meta_i(entropy_src_pkg::ENTROPY_SRC_XHT_META_RSP_DEFAULT),
    .otp_en_entropy_src_fw_read_i(prim_mubi_pkg::MuBi8True),
    .otp_en_entropy_src_fw_over_i(prim_mubi_pkg::MuBi8True),
    .rng_fips_o(es_rng_fips_o),
    .tl_i(entropy_src_tl_req),
    .tl_o(entropy_src_tl_rsp)
  );

  edn #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[23:22]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles),
    .NumEndPoints(Edn0NumEndPoints)
  ) u_edn0 (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .rst_ni(rst_main_ni),

    // Interrupts
    .intr_edn_cmd_req_done_o(intr_edn0_edn_cmd_req_done),
    .intr_edn_fatal_err_o   (intr_edn0_edn_fatal_err),

    // alert_handler[22]: recov_alert
    // alert_handler[23]: fatal_alert
    .alert_tx_o(alert_tx_o[23:22]),
    .alert_rx_i(alert_rx_i[23:22]),

    // Inter-module signals
    .csrng_cmd_o(csrng_csrng_cmd_req[0]),
    .csrng_cmd_i(csrng_csrng_cmd_rsp[0]),
    .edn_i(edn0_edn_req),
    .edn_o(edn0_edn_rsp),
    .tl_i(edn0_tl_req),
    .tl_o(edn0_tl_rsp)
  );

  edn #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[25:24]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles),
    .NumEndPoints(Edn1NumEndPoints)
  ) u_edn1 (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .rst_ni(rst_main_ni),

    // Interrupts
    .intr_edn_cmd_req_done_o(intr_edn1_edn_cmd_req_done),
    .intr_edn_fatal_err_o   (intr_edn1_edn_fatal_err),

    // alert_handler[24]: recov_alert
    // alert_handler[25]: fatal_alert
    .alert_tx_o(alert_tx_o[25:24]),
    .alert_rx_i(alert_rx_i[25:24]),

    // Inter-module signals
    .csrng_cmd_o(csrng_csrng_cmd_req[1]),
    .csrng_cmd_i(csrng_csrng_cmd_rsp[1]),
    .edn_i(edn1_edn_req),
    .edn_o(edn1_edn_rsp),
    .tl_i(edn1_tl_req),
    .tl_o(edn1_tl_rsp)
  );

  sram_ctrl #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[26]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles),
    .RndCnstSramKey(RndCnstSramCtrlMainSramKey),
    .RndCnstSramNonce(RndCnstSramCtrlMainSramNonce),
    .RndCnstLfsrSeed(RndCnstSramCtrlMainLfsrSeed),
    .RndCnstLfsrPerm(RndCnstSramCtrlMainLfsrPerm),
    .MemSizeRam(196608),
    .InstSize(SramCtrlMainInstSize),
    .NumRamInst(SramCtrlMainNumRamInst),
    .InstrExec(SramCtrlMainInstrExec),
    .NumPrinceRoundsHalf(SramCtrlMainNumPrinceRoundsHalf),
    .NumAddrScrRounds(SramCtrlMainNumAddrScrRounds),
    .Outstanding(SramCtrlMainOutstanding),
    .EccCorrection(SramCtrlMainEccCorrection)
  ) u_sram_ctrl_main (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .clk_otp_i(clk_main_i),
    .rst_ni(rst_main_ni),
    .rst_otp_ni(rst_main_ni),

    // alert_handler[26]: fatal_error
    .alert_tx_o(alert_tx_o[26]),
    .alert_rx_i(alert_rx_i[26]),

    // RACL policies
    .racl_policy_sel_ranges_ram_i('{top_racl_pkg::RACL_RANGE_T_DEFAULT}),

    // Inter-module signals
    .sram_otp_key_o(otp_ctrl_sram_otp_key_req[0]),
    .sram_otp_key_i(otp_ctrl_sram_otp_key_rsp[0]),
    .ram_cfg_i('{default: prim_ram_1p_pkg::RAM_1P_CFG_REQ_DEFAULT}),
    .ram_cfg_o(),
    .lc_escalate_en_i(lc_ctrl_lc_escalate_en),
    .lc_hw_debug_en_i(lc_ctrl_lc_hw_debug_en),
    .otp_en_sram_ifetch_i(sram_ctrl_main_otp_en_sram_ifetch),
    .racl_policies_i(top_racl_pkg::RACL_POLICY_VEC_DEFAULT),
    .racl_error_o(),
    .sram_rerror_o(),
    .regs_tl_i(sram_ctrl_main_regs_tl_req),
    .regs_tl_o(sram_ctrl_main_regs_tl_rsp),
    .ram_tl_i(sram_ctrl_main_ram_tl_req),
    .ram_tl_o(sram_ctrl_main_ram_tl_rsp)
  );

  rom_ctrl #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[27]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles),
    .BootRomInitFile(RomCtrlBootRomInitFile),
    .FlopToKmac(RomCtrlFlopToKmac),
    .RndCnstScrNonce(RndCnstRomCtrlScrNonce),
    .RndCnstScrKey(RndCnstRomCtrlScrKey),
    .SecDisableScrambling(SecRomCtrlDisableScrambling),
    .MemSizeRom(131072)
  ) u_rom_ctrl (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .rst_ni(rst_main_ni),

    // alert_handler[27]: fatal
    .alert_tx_o(alert_tx_o[27]),
    .alert_rx_i(alert_rx_i[27]),

    // Inter-module signals
    .rom_cfg_i(prim_rom_pkg::ROM_CFG_REQ_DEFAULT),
    .rom_cfg_o(),
    .pwrmgr_data_o(pwrmgr_rom_ctrl_o),
    .keymgr_data_o(keymgr_dpe_rom_digest),
    .kmac_data_o(kmac_app_req[2]),
    .kmac_data_i(kmac_app_rsp[2]),
    .regs_tl_i(rom_ctrl_regs_tl_req),
    .regs_tl_o(rom_ctrl_regs_tl_rsp),
    .rom_tl_i(rom_ctrl_rom_tl_req),
    .rom_tl_o(rom_ctrl_rom_tl_rsp)
  );

  rv_core_ibex #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[31:28]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles),
    .RndCnstLfsrSeed(RndCnstRvCoreIbexLfsrSeed),
    .RndCnstLfsrPerm(RndCnstRvCoreIbexLfsrPerm),
    .RndCnstIbexKey(RndCnstRvCoreIbexIbexKey),
    .RndCnstIbexNonce(RndCnstRvCoreIbexIbexNonce),
    .NEscalationSeverities(AlertHandlerEscNumSeverities),
    .WidthPingCounter(AlertHandlerEscPingCountWidth),
    .PMPEnable(RvCoreIbexPMPEnable),
    .PMPGranularity(RvCoreIbexPMPGranularity),
    .PMPNumRegions(RvCoreIbexPMPNumRegions),
    .MHPMCounterNum(RvCoreIbexMHPMCounterNum),
    .MHPMCounterWidth(RvCoreIbexMHPMCounterWidth),
    .PMPRstCfg(RvCoreIbexPMPRstCfg),
    .PMPRstAddr(RvCoreIbexPMPRstAddr),
    .PMPRstMsecCfg(RvCoreIbexPMPRstMsecCfg),
    .RV32E(RvCoreIbexRV32E),
    .RV32M(RvCoreIbexRV32M),
    .RV32B(RvCoreIbexRV32B),
    .RV32ZC(RvCoreIbexRV32ZC),
    .RegFile(RvCoreIbexRegFile),
    .BranchTargetALU(RvCoreIbexBranchTargetALU),
    .WritebackStage(RvCoreIbexWritebackStage),
    .ICache(RvCoreIbexICache),
    .ICacheECC(RvCoreIbexICacheECC),
    .ICacheScramble(RvCoreIbexICacheScramble),
    .ICacheNWays(RvCoreIbexICacheNWays),
    .BranchPredictor(RvCoreIbexBranchPredictor),
    .DbgTriggerEn(RvCoreIbexDbgTriggerEn),
    .DbgHwBreakNum(RvCoreIbexDbgHwBreakNum),
    .SecureIbex(RvCoreIbexSecureIbex),
    .DmBaseAddr(RvCoreIbexDmBaseAddr),
    .DmAddrMask(RvCoreIbexDmAddrMask),
    .DmHaltAddr(RvCoreIbexDmHaltAddr),
    .DmExceptionAddr(RvCoreIbexDmExceptionAddr),
    .PipeLine(RvCoreIbexPipeLine),
    .TlulHostUserRsvdBits(RvCoreIbexTlulHostUserRsvdBits),
    .CsrMvendorId(RvCoreIbexCsrMvendorId),
    .CsrMimpId(RvCoreIbexCsrMimpId),
    .InstructionPipeline(RvCoreIbexInstructionPipeline)
  ) u_rv_core_ibex (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .clk_edn_i(clk_main_i),
    .clk_esc_i(clk_aon_i),
    .clk_otp_i(clk_main_i),
    .rst_ni(rst_main_ni),
    .rst_edn_ni(rst_main_ni),
    .rst_esc_ni(rst_main_aon_ni),
    .rst_otp_ni(rst_main_ni),

    // DFT/scan connections
    .scanmode_i,
    .scan_rst_ni,

    // alert_handler[28]: fatal_sw_err
    // alert_handler[29]: recov_sw_err
    // alert_handler[30]: fatal_hw_err
    // alert_handler[31]: recov_hw_err
    .alert_tx_o(alert_tx_o[31:28]),
    .alert_rx_i(alert_rx_i[31:28]),

    // Inter-module signals
    .rst_cpu_n_o(),
    .ram_cfg_icache_tag_i('{default: prim_ram_1p_pkg::RAM_1P_CFG_REQ_DEFAULT}),
    .ram_cfg_icache_tag_o(),
    .ram_cfg_icache_data_i('{default: prim_ram_1p_pkg::RAM_1P_CFG_REQ_DEFAULT}),
    .ram_cfg_icache_data_o(),
    .hart_id_i(rv_core_ibex_hart_id),
    .boot_addr_i(rv_core_ibex_boot_addr),
    .irq_software_i(rv_plic_msip),
    .irq_timer_i(rv_core_ibex_irq_timer),
    .irq_external_i(rv_plic_irq),
    .esc_tx_i(alert_handler_esc_tx_i[0]),
    .esc_rx_o(alert_handler_esc_rx_o[0]),
    .debug_req_i(rv_dm_debug_req),
    .crash_dump_o(rv_core_ibex_crash_dump_o),
    .lc_cpu_en_i(lc_ctrl_lc_cpu_en),
    .pwrmgr_cpu_en_i(pwrmgr_fetch_en_i),
    .pwrmgr_o(rv_core_ibex_pwrmgr_o),
    .nmi_wdog_i('0),
    .edn_o(edn0_edn_req[6]),
    .edn_i(edn0_edn_rsp[6]),
    .icache_otp_key_o(otp_ctrl_sram_otp_key_req[2]),
    .icache_otp_key_i(otp_ctrl_sram_otp_key_rsp[2]),
    .fpga_info_i('0),
    .corei_tl_h_o(main_tl_rv_core_ibex__corei_req),
    .corei_tl_h_i(main_tl_rv_core_ibex__corei_rsp),
    .cored_tl_h_o(main_tl_rv_core_ibex__cored_req),
    .cored_tl_h_i(main_tl_rv_core_ibex__cored_rsp),
    .cfg_tl_d_i(rv_core_ibex_cfg_tl_d_req),
    .cfg_tl_d_o(rv_core_ibex_cfg_tl_d_rsp)
  );

  rv_dm #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[32]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles),
    .IdcodeValue(RvDmIdcodeValue),
    .UseDmiInterface(RvDmUseDmiInterface),
    .SecVolatileRawUnlockEn(SecRvDmVolatileRawUnlockEn),
    .TlulHostUserRsvdBits(RvDmTlulHostUserRsvdBits)
  ) u_rv_dm (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .clk_lc_i(clk_main_i),
    .rst_ni(rst_main_sys_ni),
    .rst_lc_ni(rst_main_ni),

    // DFT/scan connections
    .scanmode_i,
    .scan_rst_ni,

    // alert_handler[32]: fatal_fault
    .alert_tx_o(alert_tx_o[32]),
    .alert_rx_i(alert_rx_i[32]),

    // Inter-module signals
    .next_dm_addr_i('0),
    .jtag_i(jtag_pkg::JTAG_REQ_DEFAULT),
    .jtag_o(),
    .lc_init_done_i(lc_ctrl_lc_init_done),
    .lc_hw_debug_clr_i(lc_ctrl_lc_hw_debug_clr),
    .lc_hw_debug_en_i(lc_ctrl_lc_hw_debug_en),
    .lc_dft_en_i(lc_ctrl_lc_dft_en),
    .pinmux_hw_debug_en_i(lc_ctrl_pkg::Off),
    .otp_dis_rv_dm_late_debug_i(rv_dm_otp_dis_rv_dm_late_debug),
    .unavailable_i(1'b0),
    .ndmreset_req_o(rv_dm_ndmreset_req_o),
    .dmactive_o(),
    .debug_req_o(rv_dm_debug_req),
    .lc_escalate_en_i(lc_ctrl_lc_escalate_en),
    .lc_check_byp_en_i(lc_ctrl_lc_check_byp_en),
    .strap_en_i(pwrmgr_strap_i),
    .strap_en_override_i(lc_ctrl_strap_en_override),
    .racl_policies_i(top_racl_pkg::RACL_POLICY_VEC_DEFAULT),
    .racl_error_o(),
    .sba_tl_h_o(main_tl_rv_dm__sba_req),
    .sba_tl_h_i(main_tl_rv_dm__sba_rsp),
    .regs_tl_d_i(rv_dm_regs_tl_d_req),
    .regs_tl_d_o(rv_dm_regs_tl_d_rsp),
    .mem_tl_d_i(rv_dm_mem_tl_d_req),
    .mem_tl_d_o(rv_dm_mem_tl_d_rsp),
    .dbg_tl_d_i(rv_dm_dbg_tl_d_req),
    .dbg_tl_d_o(rv_dm_dbg_tl_d_rsp)
  );

  dma #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[33]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles),
    .EnableDataIntgGen(DmaEnableDataIntgGen),
    .EnableRspDataIntgCheck(DmaEnableRspDataIntgCheck),
    .TlUserRsvd(DmaTlUserRsvd),
    .SysRaclRole(DmaSysRaclRole),
    .OtAgentId(DmaOtAgentId)
  ) u_dma (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .rst_ni(rst_main_ni),

    // DFT/scan connections
    .scanmode_i,

    // Interrupts
    .intr_dma_done_o      (intr_dma_dma_done),
    .intr_dma_chunk_done_o(intr_dma_dma_chunk_done),
    .intr_dma_error_o     (intr_dma_dma_error),

    // alert_handler[33]: fatal_fault
    .alert_tx_o(alert_tx_o[33]),
    .alert_rx_i(alert_rx_i[33]),

    // Inter-module signals
    .lsio_trigger_i(dma_pkg::LSIO_TRIGGER_DEFAULT),
    .sys_o(),
    .sys_i(dma_pkg::SYS_RSP_DEFAULT),
    .ctn_tl_h2d_o(),
    .ctn_tl_d2h_i(tlul_pkg::TL_D2H_DEFAULT),
    .racl_policies_i(top_racl_pkg::RACL_POLICY_VEC_DEFAULT),
    .racl_error_o(),
    .host_tl_h_o(main_tl_dma__host_req),
    .host_tl_h_i(main_tl_dma__host_rsp),
    .tl_d_i(dma_tl_d_req),
    .tl_d_o(dma_tl_d_rsp)
  );

  mbx #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[35:34]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles)
  ) u_mbx0 (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .rst_ni(rst_main_ni),

    // Interrupts
    .intr_mbx_ready_o(intr_mbx0_mbx_ready),
    .intr_mbx_abort_o(intr_mbx0_mbx_abort),
    .intr_mbx_error_o(intr_mbx0_mbx_error),

    // alert_handler[34]: fatal_fault
    // alert_handler[35]: recov_fault
    .alert_tx_o(alert_tx_o[35:34]),
    .alert_rx_i(alert_rx_i[35:34]),

    // Inter-module signals
    .doe_intr_support_o(mbx0_doe_intr_support_o),
    .doe_intr_en_o(mbx0_doe_intr_en_o),
    .doe_intr_o(mbx0_doe_intr_o),
    .doe_async_msg_support_o(mbx0_doe_async_msg_support_o),
    .racl_policies_i(top_racl_pkg::RACL_POLICY_VEC_DEFAULT),
    .racl_error_o(),
    .sram_tl_h_o(main_tl_mbx0__sram_req),
    .sram_tl_h_i(main_tl_mbx0__sram_rsp),
    .core_tl_d_i(mbx0_core_tl_d_req),
    .core_tl_d_o(mbx0_core_tl_d_rsp),
    .soc_tl_d_i(mbx0_soc_tl_d_req),
    .soc_tl_d_o(mbx0_soc_tl_d_rsp)
  );

  mbx #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[37:36]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles)
  ) u_mbx1 (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .rst_ni(rst_main_ni),

    // Interrupts
    .intr_mbx_ready_o(intr_mbx1_mbx_ready),
    .intr_mbx_abort_o(intr_mbx1_mbx_abort),
    .intr_mbx_error_o(intr_mbx1_mbx_error),

    // alert_handler[36]: fatal_fault
    // alert_handler[37]: recov_fault
    .alert_tx_o(alert_tx_o[37:36]),
    .alert_rx_i(alert_rx_i[37:36]),

    // Inter-module signals
    .doe_intr_support_o(mbx1_doe_intr_support_o),
    .doe_intr_en_o(mbx1_doe_intr_en_o),
    .doe_intr_o(mbx1_doe_intr_o),
    .doe_async_msg_support_o(mbx1_doe_async_msg_support_o),
    .racl_policies_i(top_racl_pkg::RACL_POLICY_VEC_DEFAULT),
    .racl_error_o(),
    .sram_tl_h_o(main_tl_mbx1__sram_req),
    .sram_tl_h_i(main_tl_mbx1__sram_rsp),
    .core_tl_d_i(mbx1_core_tl_d_req),
    .core_tl_d_o(mbx1_core_tl_d_rsp),
    .soc_tl_d_i(mbx1_soc_tl_d_req),
    .soc_tl_d_o(mbx1_soc_tl_d_rsp)
  );

  rv_plic #(
    .AlertAsyncOn(alert_handler_reg_pkg::AsyncOn[44]),
    .AlertSkewCycles(top_pkg::AlertSkewCycles)
  ) u_rv_plic (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .rst_ni(rst_main_ni),

    // alert_handler[44]: fatal_fault
    .alert_tx_o(alert_tx_o[38]),
    .alert_rx_i(alert_rx_i[38]),

    // Inter-module signals
    .irq_o(rv_plic_irq),
    .irq_id_o(),
    .msip_o(rv_plic_msip),
    .tl_i(rv_plic_tl_req),
    .tl_o(rv_plic_tl_rsp),


    // Interrupt source vector
    .intr_src_i(intr_vector)
  );

  ahb_bridge u_ahb_bridge (
    // Clock and reset connections
    .clk_i(clk_main_i),
    .rst_ni(rst_main_ni),


    // Inter-module signals
    .ahb_sub_m2s_i(soc_mbx_ahb_req_i),
    .ahb_sub_s2m_o(soc_mbx_ahb_rsp_o),
    .ahb_mgr_m2s_o(soc_mgr_ahb_req_o),
    .ahb_mgr_s2m_i(soc_mgr_ahb_rsp_i),
    .socmbx_tl_h_o(socmbx_tl_ahb_bridge__socmbx_req),
    .socmbx_tl_h_i(socmbx_tl_ahb_bridge__socmbx_rsp),
    .ctn_tl_d_i(ahb_bridge_ctn_tl_d_req),
    .ctn_tl_d_o(ahb_bridge_ctn_tl_d_rsp)
  );


  // Interrupt assignments
  assign intr_vector = {
    incoming_interrupt_soc_i,                                 // IDs [38 +: 4]
    intr_vector_pd_aon_i[4],                                  // ID 37 (alert_handler_classd)
    intr_vector_pd_aon_i[3],                                  // ID 36 (alert_handler_classc)
    intr_vector_pd_aon_i[2],                                  // ID 35 (alert_handler_classb)
    intr_vector_pd_aon_i[1],                                  // ID 34 (alert_handler_classa)
    intr_vector_pd_aon_i[0],                                  // ID 33 (pwrmgr_wakeup)
    intr_mbx1_mbx_error,                                      // ID 32
    intr_mbx1_mbx_abort,                                      // ID 31
    intr_mbx1_mbx_ready,                                      // ID 30
    intr_mbx0_mbx_error,                                      // ID 29
    intr_mbx0_mbx_abort,                                      // ID 28
    intr_mbx0_mbx_ready,                                      // ID 27
    intr_dma_dma_error,                                       // ID 26
    intr_dma_dma_chunk_done,                                  // ID 25
    intr_dma_dma_done,                                        // ID 24
    intr_edn1_edn_fatal_err,                                  // ID 23
    intr_edn1_edn_cmd_req_done,                               // ID 22
    intr_edn0_edn_fatal_err,                                  // ID 21
    intr_edn0_edn_cmd_req_done,                               // ID 20
    intr_entropy_src_es_fatal_err,                            // ID 19
    intr_entropy_src_es_observe_fifo_ready,                   // ID 18
    intr_entropy_src_es_health_test_failed,                   // ID 17
    intr_entropy_src_es_entropy_valid,                        // ID 16
    intr_csrng_cs_fatal_err,                                  // ID 15
    intr_csrng_cs_hw_inst_exc,                                // ID 14
    intr_csrng_cs_entropy_req,                                // ID 13
    intr_csrng_cs_cmd_req_done,                               // ID 12
    intr_keymgr_dpe_op_done,                                  // ID 11
    intr_otbn_done,                                           // ID 10
    intr_kmac_kmac_err,                                       // ID 9
    intr_kmac_fifo_empty,                                     // ID 8
    intr_kmac_kmac_done,                                      // ID 7
    intr_hmac_hmac_err,                                       // ID 6
    intr_hmac_fifo_empty,                                     // ID 5
    intr_hmac_hmac_done,                                      // ID 4
    intr_otp_ctrl_otp_error,                                  // ID 3
    intr_otp_ctrl_otp_operation_done,                         // ID 2
    intr_rv_timer_timer_expired_hart0_timer0,                 // ID 1
    1'b0 // ID 0 is a special case and tied to zero.
  };

  // Instantiation of TL-UL crossbars
  xbar_main u_xbar_main (
    .clk_main_i(clk_main_i),
    .clk_aon_i(clk_aon_i),
    .rst_main_ni(rst_main_ni),
    .rst_aon_ni(rst_main_aon_ni),

    // port: tl_rv_core_ibex__corei
    .tl_rv_core_ibex__corei_i(main_tl_rv_core_ibex__corei_req),
    .tl_rv_core_ibex__corei_o(main_tl_rv_core_ibex__corei_rsp),

    // port: tl_rv_core_ibex__cored
    .tl_rv_core_ibex__cored_i(main_tl_rv_core_ibex__cored_req),
    .tl_rv_core_ibex__cored_o(main_tl_rv_core_ibex__cored_rsp),

    // port: tl_rv_dm__sba
    .tl_rv_dm__sba_i(main_tl_rv_dm__sba_req),
    .tl_rv_dm__sba_o(main_tl_rv_dm__sba_rsp),

    // port: tl_dma__host
    .tl_dma__host_i(main_tl_dma__host_req),
    .tl_dma__host_o(main_tl_dma__host_rsp),

    // port: tl_mbx0__sram
    .tl_mbx0__sram_i(main_tl_mbx0__sram_req),
    .tl_mbx0__sram_o(main_tl_mbx0__sram_rsp),

    // port: tl_mbx1__sram
    .tl_mbx1__sram_i(main_tl_mbx1__sram_req),
    .tl_mbx1__sram_o(main_tl_mbx1__sram_rsp),

    // port: tl_rv_dm__regs
    .tl_rv_dm__regs_o(rv_dm_regs_tl_d_req),
    .tl_rv_dm__regs_i(rv_dm_regs_tl_d_rsp),

    // port: tl_rv_dm__mem
    .tl_rv_dm__mem_o(rv_dm_mem_tl_d_req),
    .tl_rv_dm__mem_i(rv_dm_mem_tl_d_rsp),

    // port: tl_rom_ctrl__rom
    .tl_rom_ctrl__rom_o(rom_ctrl_rom_tl_req),
    .tl_rom_ctrl__rom_i(rom_ctrl_rom_tl_rsp),

    // port: tl_rom_ctrl__regs
    .tl_rom_ctrl__regs_o(rom_ctrl_regs_tl_req),
    .tl_rom_ctrl__regs_i(rom_ctrl_regs_tl_rsp),

    // port: tl_sram_ctrl_main__regs
    .tl_sram_ctrl_main__regs_o(sram_ctrl_main_regs_tl_req),
    .tl_sram_ctrl_main__regs_i(sram_ctrl_main_regs_tl_rsp),

    // port: tl_sram_ctrl_main__ram
    .tl_sram_ctrl_main__ram_o(sram_ctrl_main_ram_tl_req),
    .tl_sram_ctrl_main__ram_i(sram_ctrl_main_ram_tl_rsp),

    // port: tl_otp_ctrl__core
    .tl_otp_ctrl__core_o(otp_ctrl_core_tl_req),
    .tl_otp_ctrl__core_i(otp_ctrl_core_tl_rsp),

    // port: tl_otp_macro__prim
    .tl_otp_macro__prim_o(otp_macro_prim_tl_req),
    .tl_otp_macro__prim_i(otp_macro_prim_tl_rsp),

    // port: tl_lc_ctrl__regs
    .tl_lc_ctrl__regs_o(lc_ctrl_regs_tl_req),
    .tl_lc_ctrl__regs_i(lc_ctrl_regs_tl_rsp),

    // port: tl_rv_plic
    .tl_rv_plic_o(rv_plic_tl_req),
    .tl_rv_plic_i(rv_plic_tl_rsp),

    // port: tl_rv_timer
    .tl_rv_timer_o(rv_timer_tl_req),
    .tl_rv_timer_i(rv_timer_tl_rsp),

    // port: tl_aes
    .tl_aes_o(aes_tl_req),
    .tl_aes_i(aes_tl_rsp),

    // port: tl_hmac
    .tl_hmac_o(hmac_tl_req),
    .tl_hmac_i(hmac_tl_rsp),

    // port: tl_kmac
    .tl_kmac_o(kmac_tl_req),
    .tl_kmac_i(kmac_tl_rsp),

    // port: tl_otbn
    .tl_otbn_o(otbn_tl_req),
    .tl_otbn_i(otbn_tl_rsp),

    // port: tl_keymgr_dpe
    .tl_keymgr_dpe_o(keymgr_dpe_tl_req),
    .tl_keymgr_dpe_i(keymgr_dpe_tl_rsp),

    // port: tl_csrng
    .tl_csrng_o(csrng_tl_req),
    .tl_csrng_i(csrng_tl_rsp),

    // port: tl_entropy_src
    .tl_entropy_src_o(entropy_src_tl_req),
    .tl_entropy_src_i(entropy_src_tl_rsp),

    // port: tl_edn0
    .tl_edn0_o(edn0_tl_req),
    .tl_edn0_i(edn0_tl_rsp),

    // port: tl_edn1
    .tl_edn1_o(edn1_tl_req),
    .tl_edn1_i(edn1_tl_rsp),

    // port: tl_rv_core_ibex__cfg
    .tl_rv_core_ibex__cfg_o(rv_core_ibex_cfg_tl_d_req),
    .tl_rv_core_ibex__cfg_i(rv_core_ibex_cfg_tl_d_rsp),

    // port: tl_dma
    .tl_dma_o(dma_tl_d_req),
    .tl_dma_i(dma_tl_d_rsp),

    // port: tl_ahb_bridge__ctn
    .tl_ahb_bridge__ctn_o(ahb_bridge_ctn_tl_d_req),
    .tl_ahb_bridge__ctn_i(ahb_bridge_ctn_tl_d_rsp),

    // port: tl_mbx0__core
    .tl_mbx0__core_o(mbx0_core_tl_d_req),
    .tl_mbx0__core_i(mbx0_core_tl_d_rsp),

    // port: tl_mbx1__core
    .tl_mbx1__core_o(mbx1_core_tl_d_req),
    .tl_mbx1__core_i(mbx1_core_tl_d_rsp),

    // port: tl_pwrmgr
    .tl_pwrmgr_o(pwrmgr_tl_req_o),
    .tl_pwrmgr_i(pwrmgr_tl_rsp_i),

    // port: tl_rstmgr
    .tl_rstmgr_o(rstmgr_tl_req_o),
    .tl_rstmgr_i(rstmgr_tl_rsp_i),

    // port: tl_clkmgr
    .tl_clkmgr_o(clkmgr_tl_req_o),
    .tl_clkmgr_i(clkmgr_tl_rsp_i),

    // port: tl_alert_handler
    .tl_alert_handler_o(alert_handler_tl_req_o),
    .tl_alert_handler_i(alert_handler_tl_rsp_i),

    // port: tl_sram_ctrl_ret__regs
    .tl_sram_ctrl_ret__regs_o(sram_ctrl_ret_regs_tl_req_o),
    .tl_sram_ctrl_ret__regs_i(sram_ctrl_ret_regs_tl_rsp_i),

    // port: tl_sram_ctrl_ret__ram
    .tl_sram_ctrl_ret__ram_o(sram_ctrl_ret_ram_tl_req_o),
    .tl_sram_ctrl_ret__ram_i(sram_ctrl_ret_ram_tl_rsp_i),

    .scanmode_i
  );

  xbar_socmbx u_xbar_socmbx (
    .clk_main_i(clk_main_i),
    .rst_main_ni(rst_main_ni),

    // port: tl_ahb_bridge__socmbx
    .tl_ahb_bridge__socmbx_i(socmbx_tl_ahb_bridge__socmbx_req),
    .tl_ahb_bridge__socmbx_o(socmbx_tl_ahb_bridge__socmbx_rsp),

    // port: tl_mbx0__soc
    .tl_mbx0__soc_o(mbx0_soc_tl_d_req),
    .tl_mbx0__soc_i(mbx0_soc_tl_d_rsp),

    // port: tl_mbx1__soc
    .tl_mbx1__soc_o(mbx1_soc_tl_d_req),
    .tl_mbx1__soc_i(mbx1_soc_tl_d_rsp),

    .scanmode_i
  );

  xbar_socdbg u_xbar_socdbg (
    .clk_main_i(clk_main_i),
    .rst_main_ni(rst_main_ni),

    // port: tl_ext_socdbg_host
    .tl_ext_socdbg_host_i(soc_dbg_tl_req_i),
    .tl_ext_socdbg_host_o(soc_dbg_tl_rsp_o),

    // port: tl_lc_ctrl__dmi
    .tl_lc_ctrl__dmi_o(lc_ctrl_dmi_tl_req),
    .tl_lc_ctrl__dmi_i(lc_ctrl_dmi_tl_rsp),

    // port: tl_rv_dm__dbg
    .tl_rv_dm__dbg_o(rv_dm_dbg_tl_d_req),
    .tl_rv_dm__dbg_i(rv_dm_dbg_tl_d_rsp),

    .scanmode_i
  );



endmodule
