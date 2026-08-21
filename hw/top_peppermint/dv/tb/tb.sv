// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Peppermint top-level testbench
module tb;
  import uvm_pkg::*;
  import dv_utils_pkg::*;
  import chip_common_pkg::*;
  import chip_env_pkg::*;
  import chip_test_pkg::*;
  import mem_bkdr_util_pkg::*;
  import rom_ctrl_bkdr_util_pkg::*;
  import sram_ctrl_bkdr_util_pkg::*;

  `include "uvm_macros.svh"
  `include "dv_macros.svh"
  `include "chip_hier_macros.svh"

  wire clk_main;
  wire clk_aon;

  // Clocks:
  //    - clk_aon is a plain SoC-driven input running at 32.768 kHz.
  //    - clk_main starts at 25 MHz after reset and is programmed to 400 MHz by Peppermint firmware
  //      via the PLL register-map mirror model, so clk_main is TB-generated through clk_rst_if and
  //      its frequency is SWITCHED at runtime by the "PLL model".
  // Resets:
  //    - There is one externally-driven reset: the AON POR. The base vseq drives it via
  //      chip_if.por_n_if; it feeds the DUT rst_aon_ni and is the origin for both domains
  //      (rst_main_n is a descendant of the POR, no separate RDC). So both clk_rst_if are
  //      CLOCK-ONLY and only OBSERVE chip_if.por_n - neither drives it (see set_active), which
  //      would double-drive the net.
  //    - rst_main_no and rst_soc_cpu_no are DUT OUTPUTS (rstmgr/pwrmgr), observed via chip_if and
  //      never driven here: rst_main_no sequences off the power handshake; rst_soc_cpu_no does not
  //      drop when the main domain powers off.
  clk_rst_if clk_rst_main_if (.clk(clk_main), .rst_n(chip_if.por_n));
  clk_rst_if clk_rst_aon_if  (.clk(clk_aon),  .rst_n(chip_if.por_n));

  // Top-level DV interface
  chip_if chip_if ();

  //////////
  //  DUT //
  //////////
  // The DUT sits inside a generate block named "dut", which is ugly and deliberate. topgen bakes
  // the hierarchy tb.dut.top_peppermint.* into the register model backdoor roots, into
  // autogen/tb__xbar_connect.sv and into autogen/xbar_tgl_excl.cfg.
  // The block supplies the DUT scope without restating all 40 ports in a wrapper.
  // TODO: drop this once Peppermint has a chip-level wrapper, which satisfies the same contract
  //   naturally and is where the SoC-side glue belongs (peppermint-embargoed#38).
  //
  // The label cannot take the gen_ prefix the style guide asks for, so the rule is waived for this
  // file in lint/chip_sim.vbw.
  if (1) begin : dut
`ifdef DISABLE_ROM_INTEGRITY_CHECK
    top_peppermint #(
      // To be used carefully, and never for synthesis. It disables ROM scrambling and with it the
      // very slow integrity check, which full-chip simulations otherwise pay for on every reset.
      // TODO: replace this when issue opentitan#30389 solves it
      .SecRomCtrlDisableScrambling(1'b1)
    ) top_peppermint (
`else
    top_peppermint top_peppermint (
`endif
      // Externally supplied base clocks
      .clk_aon_i  (clk_aon            ),
      .clk_main_i (clk_main           ),

      // Power-on reset from the SoC
      .rst_aon_ni (chip_if.por_n      ),

      // Manual DFT signals, held inactive for functional tests
      .scan_rst_ni (chip_if.scan_rst_n),
      .scan_en_i   (chip_if.scan_en   ),
      .scanmode_i  (chip_if.scanmode  ),

      // Incoming alerts for group SoC
      .incoming_alert_soc_tx_i   (chip_if.incoming_alert_soc_tx  ),
      .incoming_alert_soc_rx_o   (chip_if.incoming_alert_soc_rx  ),
      .incoming_lpg_cg_en_soc_i  (chip_if.incoming_lpg_cg_en_soc ),
      .incoming_lpg_rst_en_soc_i (chip_if.incoming_lpg_rst_en_soc),

      // Incoming interrupts for group SoC
      .incoming_interrupt_soc_i  (chip_if.incoming_interrupt_soc ),

      // Power handshake with the SoC
      .power_main_req_o (chip_if.power_main_req),
      .power_main_ok_i  (chip_if.power_main_ok ),
      .clk_aon_ok_i     (chip_if.clk_aon_ok    ),
      .clk_main_ok_i    (chip_if.clk_main_ok   ),
      .wakeup_main_i    (chip_if.wakeup_main   ),

      // Power gating control of the main power domain by the power controller of
      // the wider SoC.
      .power_main_iso_en_i    (chip_if.power_main_iso_en   ),
      .power_main_sw_en_i     (chip_if.power_main_sw_en    ),
      .power_main_sw_en_phy_i (chip_if.power_main_sw_en_phy),

      // Noise source feeding entropy_src
      .es_rng_enable_o (chip_if.es_rng_enable),
      .es_rng_valid_i  (chip_if.es_rng_valid ),
      .es_rng_bit_i    (chip_if.es_rng_bit   ),
      .es_rng_fips_o   (chip_if.es_rng_fips  ),

      // Mailbox interrupts to the SoC
      .mbx0_doe_intr_o              (chip_if.mbx0_doe_intr             ),
      .mbx0_doe_intr_en_o           (chip_if.mbx0_doe_intr_en          ),
      .mbx0_doe_intr_support_o      (chip_if.mbx0_doe_intr_support     ),
      .mbx0_doe_async_msg_support_o (chip_if.mbx0_doe_async_msg_support),
      .mbx1_doe_intr_o              (chip_if.mbx1_doe_intr             ),
      .mbx1_doe_intr_en_o           (chip_if.mbx1_doe_intr_en          ),
      .mbx1_doe_intr_support_o      (chip_if.mbx1_doe_intr_support     ),
      .mbx1_doe_async_msg_support_o (chip_if.mbx1_doe_async_msg_support),

      // SoC bus boundary: AHB egress (Peppermint as manager), AHB ingress into the mailboxes
      // (Peppermint as subordinate) and the SoC-facing debug window
      .soc_mgr_ahb_req_o (chip_if.soc_mgr_ahb_req),
      .soc_mgr_ahb_rsp_i (chip_if.soc_mgr_ahb_rsp),
      .soc_mbx_ahb_req_i (chip_if.soc_mbx_ahb_req),
      .soc_mbx_ahb_rsp_o (chip_if.soc_mbx_ahb_rsp),
      .soc_dbg_tl_req_i  (chip_if.soc_dbg_tl_req ),
      .soc_dbg_tl_rsp_o  (chip_if.soc_dbg_tl_rsp ),

      // Resets and boot address out to the SoC
      .rst_main_no         (chip_if.rst_main_no      ),
      .rst_soc_cpu_no      (chip_if.rst_soc_cpu_no   ),
      .soc_cpu_boot_addr_o (chip_if.soc_cpu_boot_addr),

      // Life cycle function control to the wider SoC
      .soc_lc_dft_en_o       (chip_if.soc_lc_dft_en      ),
      .soc_lc_nvm_debug_en_o (chip_if.soc_lc_nvm_debug_en),
      .soc_lc_hw_debug_en_o  (chip_if.soc_lc_hw_debug_en ),
      .soc_lc_cpu_en_o       (chip_if.soc_lc_cpu_en      )
    );
  end : dut

  // Checks on static values to make before anything starts
  initial begin
    // chip_common_pkg carries its own copy of the noise-source bus width, so a topgen change to
    // EntropySrcRngBusWidth would truncate the stimulus with nothing to report it. The sibling tops
    // do not check: they size the bus from ast_pkg::EntropyStreams and assume it matches the top
    // parameter. Their chip_if is bound inside the DUT, and ours is a standalone interface
    // connected by name, so a mismatch here is silent.
    // TODO (peppermint-embargoed#43): extend this when the entropy_src RNG agent is connected. The
    //   agent carries a configured width of its own, so three things will have to agree: compare
    //   it against chip_common_pkg::EsRngBusWidth and the DUT parameter, or collapse all three
    //   onto one source and delete the check. The agent also needs a clk_rst_if of its own at
    //   chip_common_pkg::EsRngSampleRateKhz, since pacing it from clk_main would change the noise
    //   source bit rate when firmware programs the PLL.
    if (EsRngBusWidth != $bits(`TOP_HIER.es_rng_bit_i)) begin
      $fatal(1, "chip_common_pkg::EsRngBusWidth is %0d but top_peppermint drives %0d rng bits",
             EsRngBusWidth, $bits(`TOP_HIER.es_rng_bit_i));
    end

    // Check to guarantee a whole AON cycle
    //
    // chip_base_vseq::apply_reset holds POR for this many clk_aon posedges. The first posedge can
    // land arbitrarily soon after POR is asserted, so a value of 1 allows a pulse of almost no
    // width, that's why 2 is the minimum.
    if (NumAonClksPorAssert < 2) begin
      $fatal(1, "chip_common_pkg::NumAonClksPorAssert is %0d, it must be at least 2",
             NumAonClksPorAssert);
    end
  end

  // Sampled inside the DUT and published on chip_if, so that nothing but this file and
  // chip_hier_macros.svh knows the DUT hierarchy.
  // lc_tx_test_true_strict is X-safe. An lc_tx_t that is X during reset makes == return X, which
  // would assign X here and propagate it to the SW test status interface.
  assign chip_if.pwrmgr_cpu_fetch_en =
      lc_ctrl_pkg::lc_tx_test_true_strict(`PWRMGR_HIER.fetch_en_o);

  ///////////////////////
  //  Alert channels   //
  ///////////////////////

  // One interface per alert the top exposes, matching chip_env_cfg::list_of_alerts entry for entry.
  // The environment builds an alert_esc_agent per name, so every one of these needs a handle in the
  // config DB even where the agent only monitors. The sender side is wired by the topgen-emitted
  // file included at the bottom of this testbench, which reaches into each IP's alert_tx_o.
  alert_esc_if alert_if[NUM_ALERTS](.clk  (`ALERT_HANDLER_HIER.clk_i),
                                    .rst_n(`ALERT_HANDLER_HIER.rst_ni));

  for (genvar i = 0; i < NUM_ALERTS; i++) begin : gen_connect_alert_rx
    assign alert_if[i].alert_rx = `ALERT_HANDLER_HIER.alert_rx_o[i];
  end : gen_connect_alert_rx

  for (genvar i = 0; i < NUM_ALERTS; i++) begin : gen_alert_vif
    initial begin
      uvm_config_db#(virtual alert_esc_if)::set(
          null, $sformatf("*.env.m_alert_agent_%0s", LIST_OF_ALERTS[i]), "vif", alert_if[i]);
    end
  end : gen_alert_vif

  // TODO: drive the SoC side of the AHB boundary from the reused manager agent and the subordinate
  //   agent being built, and hook alert_esc agents onto chip_if.incoming_alert_soc_* for the alerts
  //   arriving from the wider SoC, which are separate from the internal channels wired below.

  /////////////////////////////
  //  Memory backdoor access //
  /////////////////////////////

  // One instance per chip_mem_e entry, handed to the environment through the config DB. These carry
  // the OTP fuse image and the ROM image into the design before reset is released, and the ROM one
  // also knows the scrambling key and nonce so that a random image can be given a digest that
  // rom_ctrl accepts. Every path comes from chip_hier_macros.svh, and mem_bkdr_util takes the path
  // as a string, so a gate-level build retargets these by redefining DUT_HIER alone.
  //
  // The paths below assume the generic prim memory primitives, which is what this environment
  // builds against. The sibling tops guard the equivalent block on prim_pkg::PrimTechName, but
  // nothing in the Peppermint tree pulls in the virtual prim_pkg core, since there is no AST here.
  // Add that guard along with the first technology-specific build, which is when the memory
  // hierarchy stops matching these paths.
  // The typed locals below are what select the derived class. m_mem_bkdr_util has the base class as
  // its element type, so constructing straight into an element would build a plain mem_bkdr_util
  // without rom_encrypt_write32_integ or update_rom_digest. OTP assigns directly because it really
  // is a base mem_bkdr_util.
  // TODO: use rom_ctrl_bkdr_util::type_id::create instead of new()
  initial begin
    mem_bkdr_util       m_mem_bkdr_util[chip_mem_e];
    rom_ctrl_bkdr_util  rom;
    sram_ctrl_bkdr_util ram_main, ram_ret;
    `uvm_info("tb.sv", "Creating mem_bkdr_util instance for ROM", UVM_MEDIUM)
    rom = new(
        .name                 ("mem_bkdr_util[Rom]"                                     ),
        .path                 (`DV_STRINGIFY(`ROM_MEM_HIER)                             ),
        .depth                ($size(`ROM_MEM_HIER)                                     ),
        .n_bits               ($bits(`ROM_MEM_HIER)                                     ),
`ifdef DISABLE_ROM_INTEGRITY_CHECK
        .err_detection_scheme (mem_bkdr_util_pkg::ErrDetectionNone                      ),
`else
        .err_detection_scheme (mem_bkdr_util_pkg::EccInv_39_32                          ),
`endif
        .key                  (top_peppermint_rnd_cnst_pkg::RndCnstRomCtrlScrKey        ),
        .nonce                (top_peppermint_rnd_cnst_pkg::RndCnstRomCtrlScrNonce      ),
        .system_base_addr     (top_peppermint_pkg::TOP_PEPPERMINT_ROM_CTRL_ROM_BASE_ADDR));
    m_mem_bkdr_util[Rom] = rom;
    `MEM_BKDR_UTIL_FILE_OP(m_mem_bkdr_util[Rom], `ROM_MEM_HIER)

    `uvm_info("tb.sv", "Creating mem_bkdr_util instance for OTP", UVM_MEDIUM)
    m_mem_bkdr_util[Otp] = new(
        .name                 ("mem_bkdr_util[Otp]"                 ),
        .path                 (`DV_STRINGIFY(`OTP_MEM_HIER)         ),
        .depth                ($size(`OTP_MEM_HIER)                 ),
        .n_bits               ($bits(`OTP_MEM_HIER)                 ),
        .err_detection_scheme (mem_bkdr_util_pkg::EccHamming_22_16  ));
    `MEM_BKDR_UTIL_FILE_OP(m_mem_bkdr_util[Otp], `OTP_MEM_HIER)

    `uvm_info("tb.sv", "Creating mem_bkdr_util instance for main SRAM", UVM_MEDIUM)
    ram_main = new(
        .name                 ("mem_bkdr_util[RamMain0]"                                      ),
        .path                 (`DV_STRINGIFY(`RAM_MAIN_MEM_HIER)                              ),
        .depth                ($size(`RAM_MAIN_MEM_HIER)                                      ),
        .n_bits               ($bits(`RAM_MAIN_MEM_HIER)                                      ),
        .err_detection_scheme (mem_bkdr_util_pkg::EccInv_39_32                                ),
        .system_base_addr     (top_peppermint_pkg::TOP_PEPPERMINT_SRAM_CTRL_MAIN_RAM_BASE_ADDR));
    m_mem_bkdr_util[RamMain0] = ram_main;
    `MEM_BKDR_UTIL_FILE_OP(m_mem_bkdr_util[RamMain0], `RAM_MAIN_MEM_HIER)

    `uvm_info("tb.sv", "Creating mem_bkdr_util instance for retention SRAM", UVM_MEDIUM)
    ram_ret = new(
        .name                 ("mem_bkdr_util[RamRet0]"                                          ),
        .path                 (`DV_STRINGIFY(`RAM_RET_MEM_HIER)                                  ),
        .depth                ($size(`RAM_RET_MEM_HIER)                                          ),
        .n_bits               ($bits(`RAM_RET_MEM_HIER)                                          ),
        .err_detection_scheme (mem_bkdr_util_pkg::EccInv_39_32                                   ),
        .system_base_addr     (top_peppermint_pkg::TOP_PEPPERMINT_SRAM_CTRL_RET_AON_RAM_BASE_ADDR));
    m_mem_bkdr_util[RamRet0] = ram_ret;
    `MEM_BKDR_UTIL_FILE_OP(m_mem_bkdr_util[RamRet0], `RAM_RET_MEM_HIER)

    // Publish only what was constructed above
    foreach (m_mem_bkdr_util[mem]) begin
      uvm_config_db#(mem_bkdr_util)::set(
          null, "*.env", m_mem_bkdr_util[mem].get_name(), m_mem_bkdr_util[mem]);
    end
  end

  ///////////////////////
  //  SW test hookups  //
  ///////////////////////

  `define SIM_SRAM_IF u_sim_sram.u_sim_sram_if

  // Simulation SRAM, spliced into the rv_core_ibex TL window. It is silenced when the CPU is
  // stubbed, since no C test runs in that mode and the window is driven by the TL agent instead.
  bit  en_sim_sram  = 1'b1;
  wire sel_sim_sram = !chip_if.stub_cpu & en_sim_sram;

  sim_sram u_sim_sram (
    .clk_i    (sel_sim_sram ? `CPU_HIER.clk_i : 1'b0              ),
    .rst_ni   (`CPU_HIER.rst_ni                                   ),
    .tl_in_i  (tlul_pkg::tl_h2d_t'(`CPU_HIER.u_tlul_req_buf.out_o)),
    .tl_in_o  (                                                   ),
    .tl_out_o (                                                   ),
    .tl_out_i (                                                   )
  );

  // Bind the SW test status interface directly to the sim SRAM interface
  bind `SIM_SRAM_IF sw_test_status_if u_sw_test_status_if (
    .addr     (tl_h2d.a_address              ),
    .data     (tl_h2d.a_data[15:0]           ),
    .fetch_en (tb.chip_if.pwrmgr_cpu_fetch_en),
    .clk_i    (clk_i                         ),
    .rst_ni   (rst_ni                        ),
    .wr_valid (wr_valid                      )
  );

  // Bind the SW logger interface directly to the sim SRAM interface
  bind `SIM_SRAM_IF sw_logger_if u_sw_logger_if (
    .addr     (tl_h2d.a_address),
    .data     (tl_h2d.a_data   ),
    .clk_i    (clk_i           ),
    .rst_ni   (rst_ni          ),
    .wr_valid (wr_valid        )
  );

  ////////////////////////////////////
  //  CPU data bus tap for the RAL  //
  ////////////////////////////////////

  // The chip RAL is reached over the Ibex data bus, so the environment's TL agent hangs off it.
  // In SW-driven tests the agent is passive and only monitors what Ibex issues; in stubbed-CPU
  // tests the core is silenced and the agent drives the bus itself. Either way the agent needs
  // this virtual interface, which is why it is supplied unconditionally below.
  // TODO: a gate-level build cannot tap `CPU_HIER.clk_i; take the clock off a netlist flop, the
  //   way the sibling tops do, once a Peppermint netlist exists.
  wire cpu_clk   = `CPU_HIER.clk_i;
  wire cpu_rst_n = `CPU_HIER.rst_ni;

  tl_if cpu_d_tl_if (.clk(cpu_clk), .rst_n(cpu_rst_n));

  // Read the plus args knobs, then tie cpu_d_tl_if onto the CPU data bus and re-tie it if a
  // sequence flips stub_cpu later.
  initial begin
    // Composition knobs first, since the sim SRAM hookup and the env both read them
    void'($value$plusargs("stub_cpu=%0b", chip_if.stub_cpu));
    void'($value$plusargs("en_sim_sram=%0b", en_sim_sram));

    // Manage the sim SRAM interception point for SW-driven tests
    if (!chip_if.stub_cpu && en_sim_sram) begin
      `SIM_SRAM_IF.start_addr = SW_DV_START_ADDR;
      force `CPU_HIER.u_tlul_rsp_buf.in_i = u_sim_sram.tl_in_o;
    end

    // Manage the CPU stubbing
    forever begin
      if (chip_if.stub_cpu) begin
        release cpu_d_tl_if.h2d;

        // Silence the core clock so that no CPU transaction escapes, and hold the address
        // translation modules in reset: they contain arbiters that are unhappy with X, which a
        // csr_rw can produce if it happens to hit the right register. The clock cannot be killed
        // any further up, because the DV hijack point sits in front of a FIFO and buffered
        // transactions would be lost.
        force `CPU_CORE_HIER.clk_i          = 1'b0;
        force `CPU_HIER.u_ibus_trans.rst_ni = 1'b0;
        force `CPU_HIER.u_dbus_trans.rst_ni = 1'b0;
        force `CPU_TL_ADAPT_D_HIER.tl_out   = cpu_d_tl_if.h2d;
        force cpu_d_tl_if.d2h               = `CPU_TL_ADAPT_D_HIER.tl_i;

        // TL command integrity generation sits in the design data path, and the TL driver already
        // supplies correct integrity. Force it to a random value instead, so the test proves the
        // design regenerates it.
        fork
          forever begin : stub_cpu_cmd_intg_thread
            @(cpu_d_tl_if.h2d.a_valid);
            if (cpu_d_tl_if.h2d.a_valid) begin
              force `CPU_TL_ADAPT_D_HIER.tl_out.a_user.cmd_intg = $urandom;
            end else begin
              release `CPU_TL_ADAPT_D_HIER.tl_out.a_user.cmd_intg;
            end
          end
        join_none
      end else begin
        release `CPU_CORE_HIER.clk_i;
        release `CPU_HIER.u_ibus_trans.rst_ni;
        release `CPU_HIER.u_dbus_trans.rst_ni;
        release `CPU_TL_ADAPT_D_HIER.tl_out;

        // Tap downstream of the sim SRAM interception point. Accesses to the sim SRAM must not
        // show up on cpu_d_tl_if, since the scoreboard does not recognise those addresses.
        force cpu_d_tl_if.h2d = `CPU_HIER.cored_tl_h_o;
        force cpu_d_tl_if.d2h = `CPU_HIER.cored_tl_h_i;
      end
      @chip_if.stub_cpu;
      // Killing the thread does not undo the force it may have left behind, and the field has to be
      // released before the branches above release or re-force the struct holding it.
      disable stub_cpu_cmd_intg_thread;
      release `CPU_TL_ADAPT_D_HIER.tl_out.a_user.cmd_intg;
    end
  end

  // Hand the virtual interfaces to the environment, start the clocks, and run the test
  initial begin
    // Supply the virtual interfaces to the environment via the config DB
    uvm_config_db#(virtual clk_rst_if)::set(null, "*.env", "clk_rst_vif", clk_rst_main_if);
    uvm_config_db#(virtual clk_rst_if)::set(null, "*.env", "clk_rst_aon_vif", clk_rst_aon_if);
    uvm_config_db#(virtual chip_if)::set(null, "*.env", "chip_vif", chip_if);
    uvm_config_db#(virtual tl_if)::set(null, "*.env.m_tl_agent_chip_reg_block*", "vif",
                                       cpu_d_tl_if);
    uvm_config_db#(virtual sw_logger_if)::set(null, "*.env", "sw_logger_vif",
                                              `SIM_SRAM_IF.u_sw_logger_if);
    uvm_config_db#(virtual sw_test_status_if)::set(null, "*.env", "sw_test_status_vif",
                                                   `SIM_SRAM_IF.u_sw_test_status_if);

    // Start the clock generators. The only reset is the AON POR (chip_if.por_n_if, driven by the
    // base vseq), so both interfaces are clock-only - neither drives rst_n, which would
    // double-drive the POR net.
    clk_rst_main_if.set_freq_mhz(ClkMainResetFreqMhz);
    clk_rst_main_if.set_active(.drive_clk_val(1'b1), .drive_rst_n_val(1'b0));
    clk_rst_aon_if.set_freq_khz(ClkAonFreqKhz);
    clk_rst_aon_if.set_active(.drive_clk_val(1'b1), .drive_rst_n_val(1'b0));

    // Print simulation time as ps in log messages
    $timeformat(-12, 0, " ps", 12);

    // Run UVM test
    run_test();
  end

  `undef SIM_SRAM_IF

  // Control assertions in the DUT with UVM resource string "dut_assert_en"
  //
  // Targets the top instance. VCS refuses a generate block as the scope argument of $asserton and
  // others, where Xcelium accepts one, so tb.dut fails to elaborate there.
  // Note this does not rescue hw/dv/tools/vcs/xprop.cfg, which names tb.dut and is shared with the
  // sibling tops; a chip-level wrapper is what fixes both (TODO see peppermint-embargoed#38).
  `DV_ASSERT_CTRL("dut_assert_en", tb.dut.top_peppermint)

  // Drives alert_if[*].alert_tx from each IP's alert_tx_o, in the order of LIST_OF_ALERTS
  `include "../autogen/tb__alert_handler_connect.sv"

endmodule: tb
