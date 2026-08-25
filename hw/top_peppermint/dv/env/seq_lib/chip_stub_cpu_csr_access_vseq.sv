// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Peppermint top-level stub-CPU CSR access vseq
//
// With the CPU stubbed out, use CSR reads and writes over the crossbar to reach every IP that has a
// register interface. This confirms the address map and the fabric wiring before any firmware
// exists.
//
// Each register interface is reached by reading the reset value of one register, writing something
// different to it, then reading it back, comparing against the RAL each time. The scoreboard is off
// for this test.
//
// TODO: sweep chip_soc_dbg (peppermint-embargoed#40)
// TODO: sweep chip_soc_mbx once the AHB manager agent lands (peppermint-embargoed#41 and
//   peppermint-embargoed#42)
class chip_stub_cpu_csr_access_vseq extends chip_base_vseq;
  `uvm_object_utils(chip_stub_cpu_csr_access_vseq)

  // How should the vseq deal with a particular register block? Skip it, or test it by accessing a
  // CSR?
  typedef enum bit {
    SkipBlock   = 0,
    TestWithCsr = 1
  } reg_blk_approach_e;

  // Detailed information about how the vseq will deal with a register interface.
  //
  // If approach is SkipBlock then skip_reason says why the block is being skipped and csr is null.
  //
  // If approach is TestWithCsr then csr is the register to access and skip_reason is empty. The two
  // payloads cannot share one field the way a name and a reason could, so approach is what says
  // which of them is meaningful.
  typedef struct {
    reg_blk_approach_e approach;
    uvm_reg            csr;
    string             skip_reason;
  } ping_target_t;

  // A map from register block to the way in which the vseq will interact with the block. Keyed by
  // the block handle, so a register that does not exist is a compile error rather than a run-time
  // lookup that fails.
  ping_target_t ping_targets[uvm_reg_block];

  // Tallies for the end of test summary
  int num_pinged;
  int num_read_only;

  // The blocks that were skipped, with the reason as the value. Held so that sign-off can see each
  // omission named rather than having to reconstruct it from the run log.
  string skipped_blocks[uvm_reg_block];

  // ---------------------------------
  // Standard SV/UVM methods
  // ---------------------------------
  extern function new(string name = "");
  // Hold the sequence off until the design can answer a register access
  extern task pre_start();
  extern task body();

  // ---------------------------------
  // Class specific methods
  // ---------------------------------
  // Fill in ping_targets, one entry per direct child of the chip register block
  extern function void build_ping_targets();
  // Record that blk should be tested by accessing csr, which must be one of its registers
  extern function void add_ping(uvm_reg_block blk, uvm_reg csr);
  // Record that blk should be skipped, for the given reason
  extern function void add_skip(uvm_reg_block blk, string reason);
  // Check that the set of blocks in blks is equal to the set of blocks in ping_targets
  extern function void check_targets_match_ral(const ref uvm_reg_block blks[$]);
  // Reach one register interface using the register that ping_targets holds for it
  extern task ping_block(uvm_reg_block blk, uvm_reg csr);
  // Log the tallies, name every omission, and fail a run that reached too few interfaces
  extern function void print_ping_report();
endclass: chip_stub_cpu_csr_access_vseq


function chip_stub_cpu_csr_access_vseq::new(string name = "");
  super.new(name);
endfunction: new

task chip_stub_cpu_csr_access_vseq::pre_start();
  super.pre_start();
  // lc_ctrl gates some registers until it has initialised, and KMAC is busy while rom_ctrl runs its
  // check, so nothing may be poked until that has finished.
  wait_rom_check_done();
endtask: pre_start

task chip_stub_cpu_csr_access_vseq::body();
  uvm_reg_block blks[$];

  if (!cfg.chip_vif.stub_cpu) begin
    `uvm_fatal(`gfn, "This sequence needs the stubbed CPU. Run it with +stub_cpu=1.")
  end

  build_ping_targets();

  // Direct children only: these are the per-IP register interfaces, and UVM_HIER would also return
  // sub-blocks inside an IP, which ping_targets does not name.
  cfg.ral.get_blocks(blks, UVM_NO_HIER);
  `uvm_info(`gfn, $sformatf("Pinging %0d register interfaces below %0s", blks.size(),
                            cfg.ral.get_name()), UVM_LOW)
  check_targets_match_ral(blks);

  foreach (blks[i]) begin
    // Blocks with no entry are already reported by check_targets_match_ral
    if (!ping_targets.exists(blks[i])) begin
      continue;
    end
    if (ping_targets[blks[i]].approach == SkipBlock) begin
      skipped_blocks[blks[i]] = ping_targets[blks[i]].skip_reason;
      continue;
    end
    ping_block(blks[i], ping_targets[blks[i]].csr);
  end

  print_ping_report();
endtask: body

// Register choice: intr_enable wherever a block has interrupts, being plain RW with a zero reset
// and no side effects. Elsewhere a plain RW register that csr_excl does not rule out and that holds
// no volatile field, so the read-back is predictable.
//
// Note prio and digest are register arrays, so the handle is indexed even though the register is
// named prio_0 and digest_0.
function void chip_stub_cpu_csr_access_vseq::build_ping_targets();
  add_ping(ral.aes,                    ral.aes.ctrl_aux_shadowed             );
  add_ping(ral.alert_handler,          ral.alert_handler.intr_enable         );
  add_ping(ral.clkmgr,                 ral.clkmgr.jitter_enable              );
  add_ping(ral.csrng,                  ral.csrng.reseed_interval             );
  add_ping(ral.dma,                    ral.dma.addr_space_id                 );
  add_ping(ral.edn0,                   ral.edn0.intr_enable                  );
  add_ping(ral.edn1,                   ral.edn1.intr_enable                  );
  add_ping(ral.entropy_src,            ral.entropy_src.health_test_windows   );
  add_ping(ral.hmac,                   ral.hmac.intr_enable                  );
  add_ping(ral.keymgr_dpe,             ral.keymgr_dpe.intr_enable            );
  add_ping(ral.kmac,                   ral.kmac.intr_enable                  );
  add_ping(ral.mbx0_core,              ral.mbx0_core.intr_enable             );
  add_ping(ral.mbx1_core,              ral.mbx1_core.intr_enable             );
  add_ping(ral.otbn,                   ral.otbn.intr_enable                  );
  add_ping(ral.otp_ctrl_core,          ral.otp_ctrl_core.intr_enable         );
  add_ping(ral.otp_macro_prim,         ral.otp_macro_prim.csr0               );
  add_ping(ral.pwrmgr,                 ral.pwrmgr.intr_enable                );
  add_ping(ral.rv_core_ibex_cfg,       ral.rv_core_ibex_cfg.mcounteren_writable);
  add_ping(ral.rv_plic,                ral.rv_plic.prio[0]                   );
  add_ping(ral.rv_timer,               ral.rv_timer.cfg0                     );
  add_ping(ral.sram_ctrl_main_regs,    ral.sram_ctrl_main_regs.exec          );
  add_ping(ral.sram_ctrl_ret_regs,     ral.sram_ctrl_ret_regs.exec           );
  add_ping(ral.lc_ctrl_regs,           ral.lc_ctrl_regs.claim_transition_if  );
  add_ping(ral.rv_dm_regs,             ral.rv_dm_regs.late_debug_enable      );
  add_ping(ral.rstmgr,                 ral.rstmgr.alert_info_ctrl            );
  add_ping(ral.rom_ctrl_regs,          ral.rom_ctrl_regs.digest[0]           );

  // Interfaces deliberately not reached. Listing them here puts each omission and its reason in the
  // source, where a run log would otherwise be the only record. Nothing rechecks the reason though:
  // a window that later gains registers stays skipped until someone revisits this list.
  add_skip(ral.ahb_bridge_ctn,        "memory window, no registers");
  add_skip(ral.rom_ctrl_rom,          "memory window, no registers");
  add_skip(ral.sram_ctrl_main_ram,    "memory window, no registers");
  add_skip(ral.sram_ctrl_ret_ram,     "memory window, no registers");
  add_skip(ral.rv_dm_mem,
           "debug module window, writes are ignored until dmactive is set over the DMI");
endfunction: build_ping_targets

function void chip_stub_cpu_csr_access_vseq::add_ping(uvm_reg_block blk, uvm_reg csr);
  ping_targets[blk] = '{approach: TestWithCsr, csr: csr, skip_reason: ""};
endfunction: add_ping

function void chip_stub_cpu_csr_access_vseq::add_skip(uvm_reg_block blk, string reason);
  ping_targets[blk] = '{approach: SkipBlock, csr: null, skip_reason: reason};
endfunction: add_skip

// Reports a uvm_error for each block that appears in one but not the other, so the test fails on
// either direction of drift between the table and the register model.
function void chip_stub_cpu_csr_access_vseq::check_targets_match_ral(
                                              const ref uvm_reg_block blks[$]);
  // The blocks in blks. This associative array is used as a set: only the keys matter.
  bit in_ral[uvm_reg_block];

  foreach (blks[i]) begin
    in_ral[blks[i]] = 1'b1;
  end

  foreach (blks[i]) begin
    if (!ping_targets.exists(blks[i])) begin
      `uvm_error(`gfn, $sformatf("%0s is in the register model but has no build_ping_targets entry",
                                 blks[i].get_name()))
    end
  end

  foreach (ping_targets[blk]) begin
    if (!in_ral.exists(blk)) begin
      `uvm_error(`gfn, $sformatf({"build_ping_targets names %0s but it is not a direct child of ",
                                  "the chip register block"}, blk.get_name()))
    end
  end
endfunction: check_targets_match_ral

// Reads the reset value, writes the complement of it and reads that back. A register with nothing
// writable is read only, and the read alone has to carry the evidence.
task chip_stub_cpu_csr_access_vseq::ping_block(uvm_reg_block blk, uvm_reg csr);
  csr_excl_item  excl;
  uvm_reg_field  flds[$];
  uvm_reg_data_t wr_val;
  bit            writable = 1'b0;

  // Writability comes from the register model, which is authoritative, so the table cannot differ.
  // Only a plain RW field counts. build_ping_targets picks such a register per block on purpose, so
  // anything else means the choice has drifted: a register whose only writable fields are W1C, W0C
  // or WO falls through to the read-only path below, where a non-zero reset value has to carry the
  // evidence instead. That degrades safely rather than passing quietly.
  csr.get_fields(flds);
  foreach (flds[i]) begin
    if (flds[i].get_access() == "RW") begin
      writable = 1'b1;
      break;
    end
  end

  // Log the address and the time the access starts, which is worth having when one fails. An
  // AON-domain interface cannot answer in less than an AON clock period, about 30 us, so if the
  // completion message for one of those follows this message within nanoseconds then the response
  // came from something nearer than the block itself.
  `uvm_info(`gfn, $sformatf("pinging %0s via %0s at 0x%0h", blk.get_name(), csr.get_name(),
                            csr.get_address()), UVM_MEDIUM)

  // If the register is not writeable, the only way to use it to check the block is reachable is to
  // read a nonzero value from it. This register (originally chosen in build_ping_targets) has been
  // selected because its value will be nonzero: if the read returns zero, this is a real failure.
  if (!writable) begin
    uvm_reg_data_t rd_val;

    csr_rd(.ptr(csr), .value(rd_val));
    if (rd_val == '0) begin
      `uvm_error(`gfn, $sformatf(
                 "%0s read back zero, which is indistinguishable from an unanswered access",
                 csr.get_full_name()))
      return;
    end
    num_read_only++;
    `uvm_info(`gfn, $sformatf("%0s reached via %0s at 0x%0h, read 0x%0h, nothing writable",
                              blk.get_name(), csr.get_name(), csr.get_address(), rd_val), UVM_LOW)
    return;
  end

  // Only the writable path has to respect the exclusions, and both of these are about to matter:
  // CsrExclWrite because we are going to write, and CsrExclInitCheck because we compare the reset
  // value against the register model first.
  excl = csr_utils_pkg::get_excl_item(blk);
  if (excl != null && (excl.is_excl(csr, CsrExclWrite, CsrRwTest) ||
                       excl.is_excl(csr, CsrExclInitCheck, CsrHwResetTest))) begin
    `uvm_error(`gfn, $sformatf("%0s: %0s is excluded by csr_excl, name another register",
                               blk.get_name(), csr.get_name()))
    return;
  end

  // The mirror still holds reset values at this point. csr_rd_check already reports the register
  // name and its reset value on a mismatch, so err_msg only has to say which of the two comparisons
  // in this task failed.
  csr_rd_check(.ptr(csr), .compare_vs_ral(1'b1), .err_msg("(initial read, before any write)"));

  // Write the inverse of the reset value, so a matching read-back proves the write landed. Safe
  // for the MuBi fields too, since the True and False encodings are bitwise complements. Predicting
  // through the RAL applies the per-field access policies, which keeps read-only fields inside the
  // chosen register from breaking the comparison. A shadowed register needs two matching writes to
  // commit, which csr_wr does on its own: en_shadow_wr defaults to 1 and csr_wr_sub repeats the
  // write for any dv_base_reg whose get_is_shadowed is set.
  wr_val = ~csr.get_reset();
  csr_wr(.ptr(csr), .value(wr_val), .predict(1'b1));

  csr_rd_check(.ptr(csr), .compare_vs_ral(1'b1), .err_msg("(read back after the write)"));

  num_pinged++;
  `uvm_info(`gfn,
            $sformatf("%0s reached via %0s at 0x%0h, reset 0x%0h, wrote and read back 0x%0h",
                      blk.get_name(), csr.get_name(), csr.get_address(), csr.get_reset(),
                      csr.get_mirrored_value()), UVM_LOW)
endtask: ping_block

// Fails the run when fewer interfaces were reached than ping_targets requires, so a block that was
// quietly missed cannot pass as a clean sweep.
function void chip_stub_cpu_csr_access_vseq::print_ping_report();
  string report;
  int    expected = 0;

  foreach (ping_targets[blk]) begin
    if (ping_targets[blk].approach == TestWithCsr) begin
      expected++;
    end
  end

  report = $sformatf({"\nStub-CPU CSR access report: %0d read and written, %0d read only, ",
                      "%0d skipped"}, num_pinged, num_read_only, skipped_blocks.size());
  foreach (skipped_blocks[blk]) begin
    report = {report, $sformatf("\n  skipped %0s: %0s", blk.get_name(), skipped_blocks[blk])};
  end

  `uvm_info(`gfn, report, UVM_LOW)

  if (num_pinged + num_read_only != expected) begin
    `uvm_error(`gfn, $sformatf("reached %0d of the %0d interfaces the table requires",
                               num_pinged + num_read_only, expected))
  end
endfunction: print_ping_report
