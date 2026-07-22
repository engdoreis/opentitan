// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Binds the power-handshake assertions to the top_peppermint module, so any testbench instantiating
// the top picks them up without rewiring.
module chip_pwr_handshake_bind;
`ifndef GATE_LEVEL

  bind top_peppermint chip_pwr_handshake_sva_if u_chip_pwr_handshake_sva_if (
    .clk_aon_i     (clk_aon_i  ),
    .por_ni        (rst_aon_ni ),
    .rst_main_no_i (rst_main_no)
  );

`endif
endmodule: chip_pwr_handshake_bind
