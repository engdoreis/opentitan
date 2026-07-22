// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Peppermint top-level env configuration object
class chip_env_cfg extends cip_base_env_cfg #(.RAL_T(chip_reg_block));
  `uvm_object_utils(chip_env_cfg)

  // Top-level virtual interface
  virtual chip_if chip_vif;

  // The AON clock. Reset and the pwrmgr slow FSM are paced by this, not by clk_main, so anything
  // sequencing reset has to count in these cycles.
  virtual clk_rst_if clk_rst_aon_vif;

  // Memory backdoor util instances for all memory instances in the chip
  mem_bkdr_util mem_bkdr_util_h[chip_mem_e];

  // SW-driven C-test framework VIFs
  sw_logger_vif      sw_logger_vif;
  sw_test_status_vif sw_test_status_vif;

  // Types of SW images used in the test.
  //
  // Set via plusarg. This is the basename of the SW image. If the SW image is not pre-built
  // (e.g., generated with Bazel), then the ~sw_build_device~ is suffixed to the basename to
  // pick the correct image. The following files (extensions) with this basename are expected
  // to exist there:
  // - .elf:          embedded executable
  // - .32.vmem:      mem image with 32-bit word size (for boot ROM)
  // - .64.vmem:      mem image with 64-bit word size (for sw_test / flash load)
  // - .rodata.txt:   dump of RO sections of the SW
  // - .logs.txt:     dump of SW logs
  //
  // The ~resolve_sw_image_paths()~ function does the job of suffixing this path with
  // ~sw_build_device~.
  string             sw_images[sw_type_e];
  string             sw_image_flags[sw_type_e][$];

  uint               sw_test_timeout_ns = 12_000_000; // 12ms
  // Write logs from SW test to separate log file as well, in addition to the simulator log file
  bit                write_sw_logs_to_file = 1'b1;

  // Standard SV/UVM methods
  extern function new(string name = "");

  // Class specific methods
  extern function void initialize();
endclass: chip_env_cfg


function chip_env_cfg::new(string name = "");
  super.new(name);
endfunction: new

function void chip_env_cfg::initialize();
  // Mark this as a chip-level environment. Among other things it stops cip_base_env looking for a
  // rst_shadowed_vif, which is a block-level interface: at top level the shadow reset comes from
  // rstmgr inside the DUT.
  is_chip = 1;

  // Every alert the top exposes, as emitted by topgen. cip_base_env_cfg cross-checks this against
  // the update_err and storage_err alert names of every shadowed register in the RAL, so it has to
  // be set before super.initialize(), and tb.sv has to supply one alert_esc_if per entry.
  list_of_alerts = chip_common_pkg::LIST_OF_ALERTS;

  // Integrity error corner cases are covered by the block-level environments, so do not re-cover
  // them here.
  en_tl_intg_err_cov = 0;

  // alert_esc_agent does not support the ping timeout check at top level. The loc_alert_cause
  // register is the way to observe a ping timeout here.
  en_scb_ping_chk = 0;

  super.initialize();

  // Source ID width of the TL agent hooked onto the Ibex cored port. The port comes from
  // tl_adapter_host_d_ibex, which is instantiated with MAX_REQS 2, the same as on the sibling tops.
  m_tl_agent_cfg.valid_a_source_width = 6;

  // TODO: ralgen emits a register model per address space, so chip_soc_dbg_reg_block and
  //   chip_soc_mbx_reg_block exist alongside chip_reg_block and neither is registered yet.
  //   Darjeeling registers both, and its chip_env_cfg::initialize is the recipe: push the names
  //   onto ral_model_names before super.initialize(), downcast ral_models[name] into typed handles,
  //   then give each agent cip_base creates a tl_if at *.env.m_tl_agent_<name>* and a clk_rst_vif.
  //   chip_soc_dbg follows that unchanged, since soc_dbg_tl is real TL-UL on the boundary.
  //   chip_soc_mbx needs a decision first. cip_base creates a TL agent per model and Darjeeling has
  //   a TL boundary to hang it on, whereas Peppermint reaches that space over AHB through
  //   ahb_bridge. Either hang the TL agent off the bridge's internal TL port, which reaches the
  //   registers but leaves the bridge unexercised by register traffic, or drive the AHB boundary
  //   with the manager agent and give the model an AHB register adapter. Settle it when that agent
  //   lands, not after.
endfunction: initialize
