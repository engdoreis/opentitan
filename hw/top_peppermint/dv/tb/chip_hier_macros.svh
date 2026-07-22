// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Hierarchical paths into the Peppermint DUT
//
// Every path is derived from `DUT_HIER, which is guarded by an `ifndef so a gate-level build can
// redefine it and have the rest follow. Nothing outside this header should spell out a DUT path:
// keeping them centralised here is what makes the environment retargetable to a netlist without
// editing the testbench, which is one of the GLS-support obligations.
`ifndef DUT_HIER
  `define DUT_HIER              tb.dut
`endif

// DUT_HIER is the chip-level scope. topgen's generated DV collateral assumes it holds an instance
// named top_peppermint, so tb.sv provides that scope and TOP_HIER is the generated top itself.
`define TOP_HIER                `DUT_HIER.top_peppermint

// top_peppermint is a thin wrapper hosting one instance per power domain plus the connections
// between them, so every block sits one level below it.
`define PD_MAIN_HIER            `TOP_HIER.peppermint_pd_main
`define PD_AON_HIER             `TOP_HIER.peppermint_pd_aon

// Always-on domain blocks
`define ALERT_HANDLER_HIER      `PD_AON_HIER.u_alert_handler
`define PWRMGR_HIER             `PD_AON_HIER.u_pwrmgr
`define SRAM_CTRL_RET_AON_HIER  `PD_AON_HIER.u_sram_ctrl_ret_aon

// Main domain blocks
`define CPU_HIER                `PD_MAIN_HIER.u_rv_core_ibex
`define CPU_CORE_HIER           `CPU_HIER.u_core
`define CPU_TL_ADAPT_D_HIER     `CPU_HIER.tl_adapter_host_d_ibex
`define OTP_MACRO_HIER          `PD_MAIN_HIER.u_otp_macro
`define ROM_CTRL_HIER           `PD_MAIN_HIER.u_rom_ctrl
`define SRAM_CTRL_MAIN_HIER     `PD_MAIN_HIER.u_sram_ctrl_main

// Memory array hierarchies, one per chip_mem_e entry, for mem_bkdr_util construction. The
// scrambling-disabled ROM variant drops the PRINCE wrapper, so the path differs.
`define MEM_ARRAY_SUB           mem
`ifdef DISABLE_ROM_INTEGRITY_CHECK
  `define ROM_CTRL_INT_PATH     gen_rom_scramble_disabled.u_rom.u_prim_rom.`MEM_ARRAY_SUB
`else
  `define ROM_CTRL_INT_PATH     gen_rom_scramble_enabled.u_rom.u_rom.u_prim_rom.`MEM_ARRAY_SUB
`endif

`define RAM_MAIN_HIER     `SRAM_CTRL_MAIN_HIER.u_prim_ram_1p_scr
`define RAM_RET_HIER      `SRAM_CTRL_RET_AON_HIER.u_prim_ram_1p_scr

`define RAM_MAIN_MEM_HIER `RAM_MAIN_HIER.u_prim_ram_1p_adv.gen_ram_inst[0].u_mem.`MEM_ARRAY_SUB
`define RAM_RET_MEM_HIER  `RAM_RET_HIER.u_prim_ram_1p_adv.gen_ram_inst[0].u_mem.`MEM_ARRAY_SUB
`define ROM_MEM_HIER      `ROM_CTRL_HIER.`ROM_CTRL_INT_PATH
`define OTP_MEM_HIER      `OTP_MACRO_HIER.u_prim_ram_1p_adv.gen_ram_inst[0].u_mem.`MEM_ARRAY_SUB
