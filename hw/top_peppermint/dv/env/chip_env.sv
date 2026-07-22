// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Peppermint top-level UVM environment
class chip_env extends cip_base_env #(
  .CFG_T              (chip_env_cfg),
  .COV_T              (chip_env_cov),
  .VIRTUAL_SEQUENCER_T(chip_virtual_sequencer),
  .SCOREBOARD_T       (chip_scoreboard)
);
  `uvm_component_utils(chip_env)

  // TODO: add agents

  // Standard SV/UVM methods
  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
endclass: chip_env


function chip_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction: new

function void chip_env::build_phase(uvm_phase phase);
  chip_mem_e mem;

  super.build_phase(phase);

  if (!uvm_config_db#(virtual chip_if)::get(this, "", "chip_vif", cfg.chip_vif)) begin
    `uvm_fatal(`gfn, "failed to get chip_vif from uvm_config_db")
  end

  if (!uvm_config_db#(virtual clk_rst_if)::get(this, "", "clk_rst_aon_vif",
                                               cfg.clk_rst_aon_vif)) begin
    `uvm_fatal(`gfn, "failed to get clk_rst_aon_vif from uvm_config_db")
  end

  // TL agent activity follows stub_cpu (stubbed-CPU tests drive TL directly) while SW-driven tests
  // let Ibex be the TL host
  cfg.m_tl_agent_cfg.is_active = cfg.chip_vif.stub_cpu;

  // Disable each alert_esc_agent's driver and keep only its monitor. cip_base_env_cfg brings these
  // up active in Device mode, which is correct at block level where the testbench answers the alert
  // handshake. At top level the alert_handler inside the DUT drives alert_rx, so an active agent
  // fights it and its alert_init_done never asserts, which then hangs post_apply_reset.
  foreach (LIST_OF_ALERTS[i]) begin
    cfg.m_alert_agent_cfgs[LIST_OF_ALERTS[i]].is_active = 0;
  end

  // Backdoor memory handles
  //
  // Iterate over the enumeration. The associative array starts empty, so a foreach over it fetches
  // nothing and leaves every handle null. Skip the RAM tiles beyond the ones that exist, since
  // chip_mem_e reserves 16 per RAM and tb.sv only publishes tile 0 of each.
  // TODO: the skip below is hardcoded to one tile per RAM, which is a guess. Drive it from the real
  //   tile counts, or drop it entirely, once they are settled (peppermint-private#76).
  mem = mem.first();
  do begin
    string inst = $sformatf("mem_bkdr_util[%0s]", mem.name());
    bit    is_invalid;

    is_invalid  = mem inside {[RamMain1:RamMain15]};
    is_invalid |= mem inside {[RamRet1:RamRet15]};

    if (is_invalid) begin
      mem_bkdr_util unexpected;
      // tb.sv is expected to publish tile 0 only, so a handle turning up for a tile skipped here
      // means the two have drifted apart. Without this the entry in mem_bkdr_util_h stays null
      // until some backdoor access dereferences it.
      if (uvm_config_db#(mem_bkdr_util)::get(this, "", inst, unexpected)) begin
        `uvm_fatal(`gfn, {inst, " is published by tb.sv but skipped here, so the tile counts and ",
                          "the skip above have drifted"})
      end
    end else if (!uvm_config_db#(mem_bkdr_util)::get(this, "", inst,
                                                     cfg.mem_bkdr_util_h[mem])) begin
      `uvm_fatal(`gfn, {"failed to get ", inst, " from uvm_config_db"})
    end

    // next() wraps round to the first member after the last one, which is what ends the loop
    mem = mem.next();
  end while (mem != mem.first());

  // SW-test framework VIFs
  if (!uvm_config_db#(sw_logger_vif)::get(this, "", "sw_logger_vif", cfg.sw_logger_vif)) begin
    `uvm_fatal(`gfn, "failed to get sw_logger_vif from uvm_config_db")
  end
  if (!uvm_config_db#(sw_test_status_vif)::get(this, "", "sw_test_status_vif",
                                               cfg.sw_test_status_vif)) begin
    `uvm_fatal(`gfn, "failed to get sw_test_status_vif from uvm_config_db")
  end
endfunction: build_phase

function void chip_env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // TODO: connect required agents
endfunction: connect_phase

function void chip_env::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  // TODO: set jtag_riscv_map as the default RAL map so CSR access can be driven over
  //   the DMI (mirror the Darjeeling/Earlgrey chip_env pattern).
endfunction: end_of_elaboration_phase
