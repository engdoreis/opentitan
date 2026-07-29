// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

package rstmgr_pkg;

  // Power domain parameters
  parameter int PowerDomains = 2;
  parameter int DomainAonSel = 0;
  parameter int DomainMainSel = 1;

  // Number of non-always-on domains
  parameter int OffDomains = PowerDomains-1;

  // positions of software controllable reset bits
  parameter int SOC_CPU = 0;

  // resets generated and broadcast
  // SEC_CM: LEAF.RST.SHADOW
  typedef struct packed {
    logic [PowerDomains-1:0] rst_por_aon_n;
    logic [PowerDomains-1:0] rst_por_main_n;
    logic [PowerDomains-1:0] rst_sys_n;
    logic [PowerDomains-1:0] rst_lc_main_shadowed_n;
    logic [PowerDomains-1:0] rst_lc_main_n;
    logic [PowerDomains-1:0] rst_lc_aon_shadowed_n;
    logic [PowerDomains-1:0] rst_lc_aon_n;
    logic [PowerDomains-1:0] rst_soc_cpu_n;
  } rstmgr_out_t;

  // reset indication for alert handler
  typedef struct packed {
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] por_aon;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] por_main;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] sys;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] lc_main_shadowed;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] lc_main;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] lc_aon_shadowed;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] lc_aon;
    prim_mubi_pkg::mubi4_t [PowerDomains-1:0] soc_cpu;
  } rstmgr_rst_en_t;

  parameter int NumOutputRst = 8 * PowerDomains;

  // cpu reset requests and status
  typedef struct packed {
    logic ndmreset_req;
  } rstmgr_cpu_t;

  // exported resets

  // default value for rstmgr_ast_rsp_t (for dangling ports)
  parameter rstmgr_cpu_t RSTMGR_CPU_DEFAULT = '{
    ndmreset_req: '0
  };

  // Enumeration for pwrmgr hw reset inputs
  import rstmgr_reg_pkg::NumTotalResets;
  localparam int ResetWidths = $clog2(NumTotalResets);
  typedef enum logic [ResetWidths-1:0] {
    ReqPeriResetIdx[0:0],
    ReqMainPwrResetIdx,
    ReqEscResetIdx,
    ReqNdmResetIdx
  } reset_req_idx_e;

  // Enumeration for reset info bit idx
  typedef enum logic [ResetWidths-1:0] {
    InfoPorIdx,
    InfoLowPowerExitIdx,
    InfoSwResetIdx,
    InfoPeriResetIdx[0:0],
    InfoMainPwrResetIdx,
    InfoEscResetIdx,
    InfoNdmResetIdx
  } reset_info_idx_e;


endpackage // rstmgr_pkg
