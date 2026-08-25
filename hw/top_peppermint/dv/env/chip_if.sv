// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Peppermint top-level DV interface
//
// This interface mirrors the top_peppermint port list. It is instantiated at testbench level and
// connected port by port in tb.sv, so it carries no hierarchical references of its own. The sibling
// projects bind theirs into the DUT, which does not have that property. Any signal that has to be
// observed inside the DUT is sampled in tb.sv through the chip_hier_macros.svh paths and driven
// onto a net declared here, keeping every DUT path in that one header for gate-level retargeting.
interface chip_if;

  import uvm_pkg::*;
  import dv_utils_pkg::*;
  import chip_common_pkg::*;

  import top_peppermint_pkg::NIncomingAlertsSoc;
  import top_peppermint_pkg::NIncomingLpgsSoc;
  import top_peppermint_pkg::NIncomingInterruptsSoc;

  // Clocks and resets
  wire  por_n;            // POR = AON reset source, driven via por_n_if; feeds the DUT rst_aon_ni
  logic rst_main_no;      // DUT output (rstmgr/pwrmgr)
  logic rst_soc_cpu_no;   // DUT output, unaffected by the main domain powering off

  // POR drive helper
  pins_if #(1) por_n_if (.pins(por_n));

  // Manual DFT hooks. These exist on the top_peppermint boundary but no AST drives them in this
  // integration, so functional tests hold scan inactive. Scan insertion and ATPG are backend work;
  // only the DFT_EN functional gating is verified here.
  logic                  scan_rst_n = 1'b1;
  logic                  scan_en    = 1'b0;
  prim_mubi_pkg::mubi4_t scanmode   = prim_mubi_pkg::MuBi4False;

  // SoC power handshake (AON domain)
  //
  // power_main_req is the Peppermint request for main-domain power, decoded by pwrmgr from
  // main_pd_n. The three "ok" signals are the SoC answer, feeding pwrmgr's power source inputs:
  // power_main_ok maps onto main_pok, clk_aon_ok onto slow_clk_val and clk_main_ok onto
  // core_clk_val. wakeup_main is the SoC wake request into pwrmgr wakeup source 0.
  logic power_main_req;   // DUT output
  logic power_main_ok;    // DUT input
  logic clk_aon_ok;       // DUT input
  logic clk_main_ok;      // DUT input
  wire wakeup_main;       // DUT input

  // Wakeup main drive helper
  pins_if #(1) wakeup_main_if (.pins(wakeup_main));

  // Placeholder SoC power model: an ideal supply that always answers, since both TB clocks run
  // unconditionally and power is never really removed.
  //
  // Mind the polarity, and expect it to change. power_main_req is decoded in peppermint_pd_aon as
  // !main_pd_n, so today it asserts when pwrmgr wants the main domain powered DOWN, not up. The
  // intent recorded in peppermint-embargoed#37 is the opposite, a request asserted when power is
  // wanted on, and the decode is a confirmed missing inverter whose fix belongs in the topgen
  // template. Until it lands the supply has to report power good while the request is deasserted,
  // otherwise pwrmgr waits in SlowPwrStateMainPowerOn for main_pok forever and the main domain
  // never leaves reset. Once the inverter is in, this line becomes a straight pass-through.
  // TODO: drop the inversion when the RTL fix lands (peppermint-embargoed#37). Nothing else has to
  //   change: MainRstReleasedAfterPor_A in sva/chip_pwr_handshake_sva_if.sv fires if this is left
  //   behind.
  //
  // Not tied to 1 despite modelling an ideal supply: the pwrmgr slow FSM leaves
  // SlowPwrStateMainPowerOff only once main_pok drops, so a supply that is always good would hang
  // low-power entry.
  // TODO: replace with the power-handshake agent, which owns the timing, the negative cases and the
  //   ordering coverage. The ordering itself is checked by bound SVA, not here.
  assign power_main_ok = ~power_main_req;
  assign clk_aon_ok    = 1'b1;
  assign clk_main_ok   = 1'b1;

  // Tie-off as these signals do not drive any RTL.
  logic power_main_iso_en    = 1'b0;  // DUT input
  logic power_main_sw_en     = 1'b1;  // DUT input
  logic power_main_sw_en_phy = 1'b1;  // DUT input

  // AHB egress: Peppermint is the manager, the SoC is the subordinate. Held at the idle default
  // until the AHB subordinate agent and its memory models take the response side over. hreadyout
  // must stay asserted in the default, otherwise the bridge stalls on the first access.
  ahb_pkg::ahb_m2s_t soc_mgr_ahb_req;                                 // DUT output
  ahb_pkg::ahb_s2m_t soc_mgr_ahb_rsp = ahb_pkg::AHB_S2M_DEFAULT;      // DUT input

  // AHB ingress: the SoC is the manager driving the mailboxes, Peppermint is the subordinate. Held
  // idle until the reused AHB manager agent drives it.
  ahb_pkg::ahb_m2s_t soc_mbx_ahb_req = ahb_pkg::AHB_M2S_DEFAULT;      // DUT input
  ahb_pkg::ahb_s2m_t soc_mbx_ahb_rsp;                                 // DUT output

  // SoC-facing debug window, covering lc_ctrl.dmi and rv_dm.dbg. Still raw TL-UL on the boundary;
  // the DMI-over-JTAG TAP lives in the wider SoC.
  tlul_pkg::tl_h2d_t soc_dbg_tl_req = tlul_pkg::TL_H2D_DEFAULT;       // DUT input
  tlul_pkg::tl_d2h_t soc_dbg_tl_rsp;                                  // DUT output

  // Mailbox interrupts to the SoC, DOE convention. All DUT outputs.
  logic mbx0_doe_intr;
  logic mbx0_doe_intr_en;
  logic mbx0_doe_intr_support;
  logic mbx0_doe_async_msg_support;
  logic mbx1_doe_intr;
  logic mbx1_doe_intr_en;
  logic mbx1_doe_intr_support;
  logic mbx1_doe_async_msg_support;

  // External RNG for entropy_src. The noise source wires straight to entropy_src through these
  // ports, so the existing entropy_src RNG agent applies unchanged. The bus width comes from
  // chip_common_pkg, which tb.sv checks against the DUT parameter.
  //
  // TODO (peppermint-embargoed#43): change this when the entropy_src agent lands.
  // Tied off until that agent lands, so entropy_src sees a permanently silent noise source. Nothing
  // in boot consumes entropy, so this costs nothing today, but anything needing EDN or CSRNG output
  // blocks until the agent supplies samples. The agent should be configured to supply a 400 kbps
  // rate at minimum, carried as chip_common_pkg::EsRngBitRateKbps.
  logic                     es_rng_enable;    // DUT output
  logic                     es_rng_fips;      // DUT output
  logic                     es_rng_valid = 1'b0;
  logic [EsRngBusWidth-1:0] es_rng_bit   = '0;

  // Alerts arriving from the wider SoC, plus the sender-side low power group indications. Held at
  // the inactive default until an alert_esc agent per channel drives them.
  prim_alert_pkg::alert_tx_t [NIncomingAlertsSoc-1:0] incoming_alert_soc_tx =
      {NIncomingAlertsSoc{prim_alert_pkg::ALERT_TX_DEFAULT}};
  prim_alert_pkg::alert_rx_t [NIncomingAlertsSoc-1:0] incoming_alert_soc_rx;
  prim_mubi_pkg::mubi4_t [NIncomingLpgsSoc-1:0] incoming_lpg_cg_en_soc =
      {NIncomingLpgsSoc{prim_mubi_pkg::MuBi4False}};
  prim_mubi_pkg::mubi4_t [NIncomingLpgsSoc-1:0] incoming_lpg_rst_en_soc =
      {NIncomingLpgsSoc{prim_mubi_pkg::MuBi4False}};

  // Interrupts arriving from the wider SoC
  // TODO: nothing drives these yet. They reach the PLIC from outside Peppermint, so they need a
  //   driver before any SoC interrupt path is covered (peppermint-embargoed#44).
  logic [NIncomingInterruptsSoc-1:0] incoming_interrupt_soc = '0;

  // Life-cycle function control and debug policy exported to the SoC. All DUT outputs.
  //
  // Mandatory security testpoints: in every production life-cycle state these must be de-asserted
  // and each must gate both its internal consumer and the SoC-facing port. Verified by connectivity
  // plus negative tests, not by assuming the scoreboard covers it.
  lc_ctrl_pkg::lc_tx_t soc_lc_dft_en;
  lc_ctrl_pkg::lc_tx_t soc_lc_nvm_debug_en;
  lc_ctrl_pkg::lc_tx_t soc_lc_hw_debug_en;
  lc_ctrl_pkg::lc_tx_t soc_lc_cpu_en;

  // Boot address handed to the SoC CPU once Peppermint releases it. DUT output,
  // driven by the rstmgr SOC_CPU_BOOT_ADDR register.
  logic [31:0] soc_cpu_boot_addr;

  // pwrmgr fetch enable, sampled inside the DUT by tb.sv. The SW test status interface uses it to
  // decide that the CPU has started fetching.
  logic pwrmgr_cpu_fetch_en;

  // Set by the test: stubbed-CPU vs SW-driven (Ibex runs the C test)
  bit stub_cpu = 1'b0;

endinterface: chip_if
