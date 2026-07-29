// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

`ifdef __AST_PKG_SV
`else
`define __AST_PKG_SV

package ast_pkg;

// Analog Signal
  `ifdef ANALOGSIM
typedef real  awire_t;
  `else
typedef logic awire_t;
  `endif

typedef enum logic [4-1:0] {
  ObsNon = 4'h0,  // No module observed (disable)
  ObsAst = 4'h1,  // Observe AST
  ObsFla = 4'h2,  // Observe FLASH
  ObsOtp = 4'h3,  // Observe OTP
  ObsOt0 = 4'h4,  // Observe OT0
  ObsOt1 = 4'h5,  // Observe OT1
  ObsOt2 = 4'h6,  // Observe OT2
  ObsOt3 = 4'h7,  // Observe OT3
  ObsRs0 = 4'h8,  // RESERVED
  ObsRs1 = 4'h9,  // RESERVED
  ObsRs2 = 4'hA,  // RESERVED
  ObsRs3 = 4'hB,  // RESERVED
  ObsRs4 = 4'hC,  // RESERVED
  ObsRs5 = 4'hD,  // RESERVED
  ObsRs6 = 4'hE,  // RESERVED
  ObsRs7 = 4'hF   // RESERVED
} ast_omdl_e;

typedef struct packed {
  logic [4-1:0]          obgsl;
  ast_omdl_e             obmsl;
  prim_mubi_pkg::mubi4_t obmen;
} ast_obs_ctrl_t;

parameter ast_obs_ctrl_t AST_OBS_CTRL_DEFAULT = '{
  obgsl: '0,
  obmsl: ObsNon,
  obmen: prim_mubi_pkg::MuBi4False
};

endpackage  // of ast_pkg
`endif  // of __AST_PKG_SV
