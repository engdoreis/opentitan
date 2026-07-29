// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// This checks that the outgoing resets and the corresponding reset enable going to alert handler
// are shifted by a single clock cycle.
interface rstmgr_rst_en_track_sva_if (
  input rstmgr_pkg::rstmgr_out_t resets_i,
  input rstmgr_pkg::rstmgr_rst_en_t reset_en_i,
  input logic clk_aon_i,
  input logic clk_main_i,
  input logic rst_por_ni
);
  import rstmgr_pkg::DomainAonSel;
  import rstmgr_pkg::DomainMainSel;
  localparam int DELAY = 1;

  `ASSERT(DAonRstPorAonEnTracksRstPorAonActive_A,
          $fell(resets_i.rst_por_aon_n[DomainAonSel]) |-> ##[0:DELAY]
          reset_en_i.por_aon[DomainAonSel] == prim_mubi_pkg::MuBi4True,
          clk_aon_i,
          !rst_por_ni)

  `ASSERT(DAonRstPorAonEnTracksRstPorAonInactive_A,
          $rose(resets_i.rst_por_aon_n[DomainAonSel]) |-> ##DELAY
          !resets_i.rst_por_aon_n[DomainAonSel] ||
          reset_en_i.por_aon[DomainAonSel] == prim_mubi_pkg::MuBi4False,
          clk_aon_i,
          !rst_por_ni)

  `ASSERT(DMainRstPorAonEnTracksRstPorAonActive_A,
          $fell(resets_i.rst_por_aon_n[DomainMainSel]) |-> ##[0:DELAY]
          reset_en_i.por_aon[DomainMainSel] == prim_mubi_pkg::MuBi4True,
          clk_aon_i,
          !rst_por_ni)

  `ASSERT(DMainRstPorAonEnTracksRstPorAonInactive_A,
          $rose(resets_i.rst_por_aon_n[DomainMainSel]) |-> ##DELAY
          !resets_i.rst_por_aon_n[DomainMainSel] ||
          reset_en_i.por_aon[DomainMainSel] == prim_mubi_pkg::MuBi4False,
          clk_aon_i,
          !rst_por_ni)

  `ASSERT(DAonRstPorMainEnTracksRstPorMainActive_A,
          $fell(resets_i.rst_por_main_n[DomainAonSel]) |-> ##[0:DELAY]
          reset_en_i.por_main[DomainAonSel] == prim_mubi_pkg::MuBi4True,
          clk_main_i,
          !rst_por_ni)

  `ASSERT(DAonRstPorMainEnTracksRstPorMainInactive_A,
          $rose(resets_i.rst_por_main_n[DomainAonSel]) |-> ##DELAY
          !resets_i.rst_por_main_n[DomainAonSel] ||
          reset_en_i.por_main[DomainAonSel] == prim_mubi_pkg::MuBi4False,
          clk_main_i,
          !rst_por_ni)

  `ASSERT(DMainRstSysEnTracksRstSysActive_A,
          $fell(resets_i.rst_sys_n[DomainMainSel]) |-> ##[0:DELAY]
          reset_en_i.sys[DomainMainSel] == prim_mubi_pkg::MuBi4True,
          clk_main_i,
          !rst_por_ni)

  `ASSERT(DMainRstSysEnTracksRstSysInactive_A,
          $rose(resets_i.rst_sys_n[DomainMainSel]) |-> ##DELAY
          !resets_i.rst_sys_n[DomainMainSel] ||
          reset_en_i.sys[DomainMainSel] == prim_mubi_pkg::MuBi4False,
          clk_main_i,
          !rst_por_ni)

  `ASSERT(DAonRstLcMainShadowedEnTracksRstLcMainShadowedActive_A,
          $fell(resets_i.rst_lc_main_shadowed_n[DomainAonSel]) |-> ##[0:DELAY]
          reset_en_i.lc_main_shadowed[DomainAonSel] == prim_mubi_pkg::MuBi4True,
          clk_main_i,
          !rst_por_ni)

  `ASSERT(DAonRstLcMainShadowedEnTracksRstLcMainShadowedInactive_A,
          $rose(resets_i.rst_lc_main_shadowed_n[DomainAonSel]) |-> ##DELAY
          !resets_i.rst_lc_main_shadowed_n[DomainAonSel] ||
          reset_en_i.lc_main_shadowed[DomainAonSel] == prim_mubi_pkg::MuBi4False,
          clk_main_i,
          !rst_por_ni)

  `ASSERT(DMainRstLcMainShadowedEnTracksRstLcMainShadowedActive_A,
          $fell(resets_i.rst_lc_main_shadowed_n[DomainMainSel]) |-> ##[0:DELAY]
          reset_en_i.lc_main_shadowed[DomainMainSel] == prim_mubi_pkg::MuBi4True,
          clk_main_i,
          !rst_por_ni)

  `ASSERT(DMainRstLcMainShadowedEnTracksRstLcMainShadowedInactive_A,
          $rose(resets_i.rst_lc_main_shadowed_n[DomainMainSel]) |-> ##DELAY
          !resets_i.rst_lc_main_shadowed_n[DomainMainSel] ||
          reset_en_i.lc_main_shadowed[DomainMainSel] == prim_mubi_pkg::MuBi4False,
          clk_main_i,
          !rst_por_ni)

  `ASSERT(DAonRstLcAonShadowedEnTracksRstLcAonShadowedActive_A,
          $fell(resets_i.rst_lc_aon_shadowed_n[DomainAonSel]) |-> ##[0:DELAY]
          reset_en_i.lc_aon_shadowed[DomainAonSel] == prim_mubi_pkg::MuBi4True,
          clk_aon_i,
          !rst_por_ni)

  `ASSERT(DAonRstLcAonShadowedEnTracksRstLcAonShadowedInactive_A,
          $rose(resets_i.rst_lc_aon_shadowed_n[DomainAonSel]) |-> ##DELAY
          !resets_i.rst_lc_aon_shadowed_n[DomainAonSel] ||
          reset_en_i.lc_aon_shadowed[DomainAonSel] == prim_mubi_pkg::MuBi4False,
          clk_aon_i,
          !rst_por_ni)

  `ASSERT(DMainRstLcAonShadowedEnTracksRstLcAonShadowedActive_A,
          $fell(resets_i.rst_lc_aon_shadowed_n[DomainMainSel]) |-> ##[0:DELAY]
          reset_en_i.lc_aon_shadowed[DomainMainSel] == prim_mubi_pkg::MuBi4True,
          clk_aon_i,
          !rst_por_ni)

  `ASSERT(DMainRstLcAonShadowedEnTracksRstLcAonShadowedInactive_A,
          $rose(resets_i.rst_lc_aon_shadowed_n[DomainMainSel]) |-> ##DELAY
          !resets_i.rst_lc_aon_shadowed_n[DomainMainSel] ||
          reset_en_i.lc_aon_shadowed[DomainMainSel] == prim_mubi_pkg::MuBi4False,
          clk_aon_i,
          !rst_por_ni)

  `ASSERT(DAonRstSocCpuEnTracksRstSocCpuActive_A,
          $fell(resets_i.rst_soc_cpu_n[DomainAonSel]) |-> ##[0:DELAY]
          reset_en_i.soc_cpu[DomainAonSel] == prim_mubi_pkg::MuBi4True,
          clk_aon_i,
          !rst_por_ni)

  `ASSERT(DAonRstSocCpuEnTracksRstSocCpuInactive_A,
          $rose(resets_i.rst_soc_cpu_n[DomainAonSel]) |-> ##DELAY
          !resets_i.rst_soc_cpu_n[DomainAonSel] ||
          reset_en_i.soc_cpu[DomainAonSel] == prim_mubi_pkg::MuBi4False,
          clk_aon_i,
          !rst_por_ni)

endinterface
