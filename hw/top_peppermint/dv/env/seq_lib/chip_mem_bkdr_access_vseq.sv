// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Peppermint top-level memory backdoor access vseq
//
// Write a few words into every memory the testbench publishes and read them back. This derisks the
// backdoor before anything depends on it: the ROM image and the OTP fuse image both reach the
// design this way. A deposit that does not stick leaves rom_ctrl hashing something other than the
// image the test meant to boot, so it reports pwrmgr_data_o.good as false and pwrmgr does not allow
// the boot.
//
// mem_bkdr_util::new already fatals on a bad hierarchical path, so what is left to catch is a depth
// or width that disagrees with the array, and an address decode fault. Hence the first and last
// word, and writing every offset before reading any of them. The chip_mem_e tag in the data names
// the memory in a mismatch message.
//
// NOTE:
//  - ECC bits and scrambling are deliberately out of scope for this test.
//  - Because these test patterns stay in the memories after the sequence, this has to run after
//    rom_ctrl has hashed the contents of the ROM. Otherwise, rom_ctrl will fail its check that the
//    hash over the main part of ROM matches an expected digest that is stored in the top words.
class chip_mem_bkdr_access_vseq extends chip_base_vseq;
  `uvm_object_utils(chip_mem_bkdr_access_vseq)

  // Random offsets checked per memory, on top of the first and the last word. The two ends catch a
  // depth or an address shift that is out by one, so the random offsets are there for the decode
  // bits in between, and raising this is the only way to widen that. A backdoor access costs no
  // simulation time, so it is cheap, but each one is a read-modify-write over a whole row, so this
  // should remain relatively contained (<100).
  int unsigned num_random_offsets = 8;

  // ---------------------------------
  // Standard SV/UVM methods
  // ---------------------------------
  extern function new(string name = "");
  extern task pre_start();
  extern task body();

  // ---------------------------------
  // Class specific methods
  // ---------------------------------
  // Write and read back at some offsets for one memory
  extern local task check_mem(chip_mem_e mem, mem_bkdr_util util);
  // Word written to mem at offset
  extern local function bit [31:0] written_word(chip_mem_e mem, bit [BUS_AW-1:0] offset,
                                                int unsigned pass);
endclass: chip_mem_bkdr_access_vseq


function chip_mem_bkdr_access_vseq::new(string name = "");
  super.new(name);
endfunction: new

task chip_mem_bkdr_access_vseq::pre_start();
  super.pre_start();
  wait_rom_check_done();
endtask: pre_start

task chip_mem_bkdr_access_vseq::body();
  // A running Ibex fetches from the ROM and writes the main SRAM, which would race the read-back.
  // So we need to ensure that the CPU is stubbed-out.
  if (!cfg.chip_vif.stub_cpu) begin
    `uvm_fatal(`gfn, {"This sequence corrupts the contents of memory, so should not be run ",
                      "without +stub_cpu=1."})
  end

  foreach (cfg.mem_bkdr_util_h[mem]) begin
    check_mem(mem, cfg.mem_bkdr_util_h[mem]);
  end
endtask: body

task chip_mem_bkdr_access_vseq::check_mem(chip_mem_e mem, mem_bkdr_util util);
  bit [BUS_AW-1:0] offsets[$];
  int unsigned     num_words = util.get_size_bytes() / 4;

  `uvm_info(`gfn, $sformatf("%0s: %0d rows of %0d bits at %0s",
                            mem.name(), util.get_depth(), util.get_width(), util.get_path()),
            UVM_LOW)

  // The two ends are where an off-by-one in the depth or in the address shift shows up, since a row
  // index past the end of the array makes uvm_hdl_read fail
  offsets.push_back(0);
  offsets.push_back((num_words - 1) * 4);
  for (int unsigned i = 0; i < num_random_offsets; i++) begin
    offsets.push_back($urandom_range(0, num_words - 1) * 4);
  end

  // Two passes with complementary words, so a write that never landed cannot be masked by whatever
  // the memory already held
  for (int unsigned pass = 0; pass < 2; pass++) begin
    // Every offset is written before any is read, so a read that returns another offset's word
    // fails here. Writing and reading one offset at a time would look identical to a working memory
    foreach (offsets[i]) begin
      util.write32(offsets[i], written_word(mem, offsets[i], pass));
    end
    foreach (offsets[i]) begin
      bit [31:0] exp_word;
      bit [31:0] rd_word;

      exp_word = written_word(mem, offsets[i], pass);
      rd_word  = util.read32(offsets[i]);
      if (rd_word !== exp_word) begin
        `uvm_error(`gfn, $sformatf("%0s: offset 0x%0h read back 0x%0h, expected 0x%0h",
                                   mem.name(), offsets[i], rd_word, exp_word))
      end
    end
  end
endtask: check_mem

function bit [31:0] chip_mem_bkdr_access_vseq::written_word(chip_mem_e mem,
                                                            bit [BUS_AW-1:0] offset,
                                                            int unsigned pass);
  bit [31:0] word;

  word = {8'(int'(mem)), 24'(offset)};
  return (pass == 0) ? word : ~word;
endfunction: written_word
