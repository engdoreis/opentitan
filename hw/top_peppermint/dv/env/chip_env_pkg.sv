// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Peppermint top-level DV environment package
package chip_env_pkg;
  import uvm_pkg::*;
  import top_pkg::*;
  import bus_params_pkg::*;
  import chip_common_pkg::*;
  import cip_base_pkg::*;
  import csr_utils_pkg::*;
  import tl_agent_pkg::*;
  import dv_base_reg_pkg::*;
  import dv_lib_pkg::*;
  import dv_utils_pkg::*;

  // dv_utils primitives reused for the SW-driven C-test framework
  import mem_bkdr_util_pkg::*;
  import rom_ctrl_bkdr_util_pkg::*;
  import sram_ctrl_bkdr_util_pkg::*;
  import otp_ctrl_mem_bkdr_util_pkg::*;
  import lc_ctrl_state_pkg::*;
  import sw_test_status_pkg::*;

  import top_peppermint_pkg::*;
  import top_peppermint_rnd_cnst_pkg::*;
  import chip_ral_pkg::*;

  // Macro includes
  `include "uvm_macros.svh"
  `include "dv_macros.svh"

  // ROM digest parameters. rom_ctrl checks every word below the digest, which occupies the top of
  // the ROM, so a randomly filled image has to stop short of it and then have the digest written.
  localparam uint RomDigestDw = 256;
  localparam uint RomMaxCheckAddr = top_peppermint_pkg::TOP_PEPPERMINT_ROM_CTRL_ROM_SIZE_BYTES -
                                    (RomDigestDw / 8);

  typedef virtual sw_logger_if      sw_logger_vif;
  typedef virtual sw_test_status_if sw_test_status_vif;

  // Types of memories in the Peppermint top, accessed by backdoor
  //
  // RAM instances have support for up to 16 tiles. Actual number of tiles in use in the design is a
  // runtime setting in chip_env_cfg.
  // TODO: 16 is a placeholder; size these from the real tile counts once they are settled
  //   (peppermint-private#76).
  typedef enum {
    RamMain[16],
    RamRet[16],
    Rom,
    Otp
  } chip_mem_e;

  // All the SW image slots the external regression tool can set, one per image a test may load
  //
  // Note: the set is shared across tops, so a slot stays listed even where Peppermint has no use
  // for it. Any change here needs util/py/scripts/build_sw_collateral_for_sim.py updating to match.
  typedef enum {
    SwTypeRom       = 0,  // Ibex SW - first stage boot ROM
    SwTypeTestSlotA = 1,  // Ibex SW - ROM_EXT / test image, slot A
    SwTypeTestSlotB = 2,  // Ibex SW - ROM_EXT / test image, slot B
    SwTypeOtbn      = 3,  // Otbn SW
    SwTypeOtp       = 4,  // Customized OTP image
    SwTypeDebug     = 5   // Debug SW - injected into SRAM
  } sw_type_e;

  // package sources
  `include "chip_env_cfg.sv"
  `include "chip_env_cov.sv"
  `include "chip_virtual_sequencer.sv"
  `include "chip_scoreboard.sv"
  `include "chip_env.sv"
  `include "seq_lib/chip_vseq_list.sv"

endpackage: chip_env_pkg
