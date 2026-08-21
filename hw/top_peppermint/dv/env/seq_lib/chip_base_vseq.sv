// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Peppermint top-level base virtual sequence
//
// Base for all top vseqs. Owns POR/reset application and the common init hooks. SW-driven tests run
// a C image on Ibex; stubbed-CPU tests drive the buses directly.
class chip_base_vseq extends cip_base_vseq #(
  .CFG_T               (chip_env_cfg           ),
  .RAL_T               (chip_reg_block         ),
  .COV_T               (chip_env_cov           ),
  .VIRTUAL_SEQUENCER_T (chip_virtual_sequencer )
);
  `uvm_object_utils(chip_base_vseq)

  // Whether dut_init places an OTP image before releasing the reset
  //
  // On by default, because nothing else supplies one yet: a test that skipped this would release
  // reset onto an undefined macro and lc_ctrl would latch an invalid state. A test that
  // backdoor-loads a generated fuse image clears this and does its own.
  // TODO: revisit the default once data/otp carries the otp_ctrl_img_*.hjson set
  //   (peppermint-embargoed#39)
  bit do_otp_init = 1'b1;

  // Life-cycle state placed when do_otp_init is set. RMA enables the CPU along with debug and DFT,
  // which is what a connectivity sweep wants, and a lockdown test picks a production state instead.
  // The state and the transition count have to be a pair lc_ctrl accepts, so change both together.
  lc_ctrl_state_pkg::lc_state_e otp_lc_state = lc_ctrl_state_pkg::LcStRma;
  lc_ctrl_state_pkg::lc_cnt_e   otp_lc_cnt   = lc_ctrl_state_pkg::LcCnt8;

  // ---------------------------------
  // Standard SV/UVM methods
  // ---------------------------------
  extern function new(string name = "");
  // Fill the ROM before the first reset, then run dut_init if the test wants one
  extern task pre_start();

  // ---------------------------------
  // Methods extending base methods
  // ---------------------------------
  // Drive a POR pulse on the AON domain, then hand over to the base class
  extern task apply_reset(string kind = "HARD");
  // Place an OTP image if the test wants one, then reset the chip through the base class
  extern virtual task dut_init(string reset_kind = "HARD");

  // ---------------------------------
  // Class specific methods
  // ---------------------------------
  // Clear the OTP macro so it holds a defined, ECC-clean image, then place otp_lc_state into it.
  // Called by dut_init when do_otp_init is set.
  extern protected virtual function void otp_init();
  // Fill the ROM with random data correctly scrambled and ECC encoded, and append a valid digest.
  // Called by pre_start, before the first reset.
  extern protected virtual function void random_rom_init_with_digest();
  // Wait for rom_ctrl to finish its KMAC pass and for lc_ctrl to report itself initialised
  extern protected virtual task wait_rom_check_done();
endclass: chip_base_vseq


function chip_base_vseq::new(string name = "");
  super.new(name);
endfunction: new

// The memories must hold something the design accepts before reset is released, and dut_init is
// where the reset happens, so the ROM is filled here. Subclasses that have a real ROM image
// overwrite this later.
task chip_base_vseq::pre_start();
  bit do_dut_init_save = do_dut_init;

  do_dut_init = 1'b0;
  super.pre_start();

`ifdef DISABLE_ROM_INTEGRITY_CHECK
  cfg.mem_bkdr_util_h[Rom].randomize_mem();
`else
  random_rom_init_with_digest();
`endif

  do_dut_init = do_dut_init_save;
  if (do_dut_init) begin
    dut_init();
  end
endtask: pre_start

// POR is the only reset this testbench drives: the main-domain reset sequences off the power
// handshake rather than directly off POR, so a POR pulse here is enough to reset the whole chip.
task chip_base_vseq::apply_reset(string kind = "HARD");
  // Hold wakeup_main idle before POR is released, or pwrmgr samples X on wakeup source 0
  cfg.chip_vif.wakeup_main_if.drive(0);

  // Assert POR on the AON domain, then release
  //
  // Hold it for whole AON clock cycles. POR and the pwrmgr slow FSM are paced by clk_aon, which at
  // 33 kHz has a period of about 30 us, so a fixed delay shorter than that leaves POR narrower than
  // a single AON cycle. clk_rst_if randomises each clock's starting phase per seed, so such a pulse
  // lands differently every run and the reset is only sometimes captured, which shows up as a
  // seed-dependent hang later in the boot. wait_clks counts posedges, so the first one can land
  // arbitrarily soon after drive(0): NumAonClksPorAssert has to be at least 2 for a full cycle of
  // POR to be guaranteed.
  `uvm_info(`gfn, "Asserting POR_N", UVM_LOW)
  cfg.chip_vif.por_n_if.drive(0);
  cfg.clk_rst_aon_vif.wait_clks(NumAonClksPorAssert);
  cfg.chip_vif.por_n_if.drive(1);
  `uvm_info(`gfn, "POR_N complete", UVM_LOW)

  // A no-op today, kept for the base-class contract. cfg.num_edn is 0, and both clk_rst_ifs are
  // clock-only, so clk_rst_if::apply_reset drives nothing: its whole body sits under drive_rst_n.
  // It goes live if an EDN or a reset-driving clk_rst_vif appears, so leave it after the POR pulse.
  super.apply_reset(kind);
endtask: apply_reset

task chip_base_vseq::dut_init(string reset_kind = "HARD");
  if (do_otp_init) begin
    otp_init();
  end

  // TODO: backdoor-load the ROM_EXT test image per the test. Model the SoC at the AHB boundary
  //   only.
  super.dut_init(reset_kind);
endtask: dut_init

// The state matters more than it looks. An all zero OTP decodes as RAW, and RAW holds lc_cpu_en
// deasserted, which closes the tlul_lc_gate on the rv_core_ibex data port. That gate is built with
// ReturnBlankResp, so every request through it is acknowledged with zero data and no error: CSR
// reads come back as zero from every block in both power domains and nothing reports a fault.
//
// A test that has a generated fuse image clears do_otp_init and loads it, leaving this function
// alone, so the blank-and-place path stays available to tests which want a chosen life-cycle state
// without depending on the image build.
function void chip_base_vseq::otp_init();
  cfg.mem_bkdr_util_h[Otp].clear_mem();
  otp_write_lc_partition_state(cfg.mem_bkdr_util_h[Otp], otp_lc_state);
  otp_write_lc_partition_cnt(cfg.mem_bkdr_util_h[Otp], otp_lc_cnt);
endfunction: otp_init

// Without this, rom_ctrl never reports a good check and pwrmgr holds the chip short of active, so
// no CSR is reachable. Filling the ROM here means the testbench does not depend on a ROM software
// build.
function void chip_base_vseq::random_rom_init_with_digest();
  rom_ctrl_bkdr_util rom;

  `uvm_info(`gfn, "Random ROM init with a valid digest", UVM_MEDIUM)
  `downcast(rom, cfg.mem_bkdr_util_h[Rom])

  // Randomize the memory contents
  //
  // mem_bkdr_util::randomize_mem is no help here. It ECC-encodes each word and writes it as is,
  // whereas rom_ctrl expects both the data and the address to have been scrambled: the ECC is
  // computed over the plaintext word and the resulting 39 bits are then scrambled as a whole. A
  // plain write therefore lands at the wrong address holding data that descrambles to garbage, and
  // the ECC check fails on it.
  for (int unsigned addr = 0; addr < RomMaxCheckAddr; addr += top_pkg::TL_DW / 8) begin
    // Assigned rather than initialised in the declaration, so that a fresh value per word does not
    // depend on when a tool chooses to run declaration initialisers for an automatic variable
    bit [top_pkg::TL_DW-1:0] rnd_data;

    rnd_data = $urandom;
    rom.rom_encrypt_write32_integ(addr,
                                  rnd_data,
                                  top_peppermint_rnd_cnst_pkg::RndCnstRomCtrlScrKey,
                                  top_peppermint_rnd_cnst_pkg::RndCnstRomCtrlScrNonce,
                                  1'b1);  // Enable scrambling
  end

  // Set the top words of the ROM to match the result of running cSHAKE256 over the rest of its
  // contents, which is the digest rom_ctrl recomputes and compares after reset
  rom.update_rom_digest(top_peppermint_rnd_cnst_pkg::RndCnstRomCtrlScrKey,
                        top_peppermint_rnd_cnst_pkg::RndCnstRomCtrlScrNonce);
endfunction: random_rom_init_with_digest

// Sequences that touch CSRs must not start before this, or they can write a KMAC register
// mid-operation or hit a register still gated by life cycle. Treat it as part of reset. Both reads
// are backdoor ones so this works with or without the CPU stubbed.
//
// The ROM check and the life-cycle initialisation run concurrently out of reset, so the digest
// appearing says nothing about lc_ctrl. It only looks that way because digesting the whole ROM
// through KMAC takes far longer than the initialisation it races. The second wait covers otp_ctrl
// as well, since pwrmgr does not start the life-cycle initialisation until the OTP one has
// finished.
task chip_base_vseq::wait_rom_check_done();
  `uvm_info(`gfn, "Waiting for the rom_ctrl check after reset...", UVM_MEDIUM)
  csr_spinwait(.ptr(ral.rom_ctrl_regs.digest[0]), .exp_data(0), .compare_op(CompareOpNe),
               .backdoor(1), .spinwait_delay_ns(1000), .timeout_ns(RomCheckTimeoutNs));
  `uvm_info(`gfn, "The rom_ctrl check is done", UVM_HIGH)

  csr_spinwait(.ptr(ral.lc_ctrl_regs.status.ready), .exp_data(1), .backdoor(1),
               .spinwait_delay_ns(1000));
  `uvm_info(`gfn, "lc_ctrl reports itself initialised", UVM_HIGH)
endtask: wait_rom_check_done
