// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

package ibex_pmp_reset_pkg;
  import ibex_pkg::*;
  import top_peppermint_pkg::TOP_PEPPERMINT_ROM_CTRL_ROM_BASE_ADDR;
  import top_peppermint_pkg::TOP_PEPPERMINT_ROM_CTRL_ROM_SIZE_BYTES;
  import top_peppermint_pkg::TOP_PEPPERMINT_MMIO_BASE_ADDR;
  import top_peppermint_pkg::TOP_PEPPERMINT_MMIO_SIZE_BYTES;

  // Default reset values for PMP CSRs. Where the number of regions
  // (PMPNumRegions) is less than 16 the reset values for the higher numbered
  // regions are ignored.

  localparam pmp_cfg_t PmpCfgRst[16] = '{
                                                                              // Region info
    '{lock: 1'b0, mode: PMP_MODE_OFF,   exec: 1'b0, write: 1'b0, read: 1'b0}, // 0
    '{lock: 1'b0, mode: PMP_MODE_OFF,   exec: 1'b0, write: 1'b0, read: 1'b0}, // 1
    '{lock: 1'b1, mode: PMP_MODE_NAPOT, exec: 1'b1, write: 1'b0, read: 1'b1}, // 2  [ROM: LRX]
    '{lock: 1'b0, mode: PMP_MODE_OFF,   exec: 1'b0, write: 1'b0, read: 1'b0}, // 3
    '{lock: 1'b0, mode: PMP_MODE_OFF,   exec: 1'b0, write: 1'b0, read: 1'b0}, // 4
    '{lock: 1'b0, mode: PMP_MODE_OFF,   exec: 1'b0, write: 1'b0, read: 1'b0}, // 5
    '{lock: 1'b0, mode: PMP_MODE_OFF,   exec: 1'b0, write: 1'b0, read: 1'b0}, // 6
    '{lock: 1'b0, mode: PMP_MODE_OFF,   exec: 1'b0, write: 1'b0, read: 1'b0}, // 7
    '{lock: 1'b0, mode: PMP_MODE_OFF,   exec: 1'b0, write: 1'b0, read: 1'b0}, // 8
    '{lock: 1'b0, mode: PMP_MODE_OFF,   exec: 1'b0, write: 1'b0, read: 1'b0}, // 9
    '{lock: 1'b0, mode: PMP_MODE_OFF,   exec: 1'b0, write: 1'b0, read: 1'b0}, // 10
    '{lock: 1'b1, mode: PMP_MODE_NAPOT, exec: 1'b0, write: 1'b1, read: 1'b1}, // 11 [MMIO: LRW]
    '{lock: 1'b0, mode: PMP_MODE_OFF,   exec: 1'b0, write: 1'b0, read: 1'b0}, // 12
    '{lock: 1'b0, mode: PMP_MODE_OFF,   exec: 1'b0, write: 1'b0, read: 1'b0}, // 13
    '{lock: 1'b0, mode: PMP_MODE_OFF,   exec: 1'b0, write: 1'b0, read: 1'b0}, // 14
    '{lock: 1'b0, mode: PMP_MODE_OFF,   exec: 1'b0, write: 1'b0, read: 1'b0}  // 15
  };

  // Calculate NAPOT regions
  // Size for NAPOT is encoded as:
  // 'b000: 8-byte region
  // 'b0100: 16-byte region
  // 'b01100: 32-byte region
  // ...
  // The number of ones equals to the log2(size/8) where size is in bytes
  // Alternatively the ones can be encoded as: (((size >> 3) - 1) << 2)
  // Both assume size is a power of two.
  localparam [33:0] RomNapotEncoding = {
    2'b0, // Top bits are zero
    TOP_PEPPERMINT_ROM_CTRL_ROM_BASE_ADDR +
      (((TOP_PEPPERMINT_ROM_CTRL_ROM_SIZE_BYTES >> 3) - 1) << 2)
  };
  localparam [33:0] MmioNapotEncoding = {
    2'b0, // Top bits are zero
    TOP_PEPPERMINT_MMIO_BASE_ADDR +
      (((TOP_PEPPERMINT_MMIO_SIZE_BYTES >> 3) - 1) << 2)
  };

  // Addresses are given in byte granularity for readability. A minimum of two
  // bits will be stripped off the bottom (PMPGranularity == 0) with more stripped
  // off at coarser granularities.
  //
  // Note: The size of region 2 below must match the ROM size configured in
  // top_peppermint.hjson (rom_ctrl.rom: base 0x0004_0000, 128 KiB) and, once
  // Peppermint's ROM software exists, its `_epmp_reset_rx_size` linker symbol.
  localparam logic [33:0] PmpAddrRst[16] = '{
    34'h00000000,      // rgn 0
    34'h00000000,      // rgn 1
    RomNapotEncoding,  // rgn 2: ROM
    34'h00000000,      // rgn 3
    34'h00000000,      // rgn 4
    34'h00000000,      // rgn 5
    34'h00000000,      // rgn 6
    34'h00000000,      // rgn 7
    34'h00000000,      // rgn 8
    34'h00000000,      // rgn 9
    34'h00000000,      // rgn 10
    MmioNapotEncoding, // rgn 11: MMIO
    34'h00000000,      // rgn 12
    34'h00000000,      // rgn 13
    34'h00000000,      // rgn 14
    34'h00000000       // rgn 15
  };

  localparam pmp_mseccfg_t PmpMseccfgRst = '{rlb : 1'b1, mmwp: 1'b1, mml: 1'b0};
endpackage
