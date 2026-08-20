// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

package ahb_pkg;

  localparam int unsigned AhbAddrWidth = 32'd32;
  localparam int unsigned AhbDataWidth = 32'd32;

  localparam int unsigned AhbMaskWidth   = AhbDataWidth / 32'd8;
  localparam int unsigned AhbMaskNumBits = prim_util_pkg::vbits(AhbMaskWidth);
  localparam logic [2:0]  AhbSizeFull    = 3'(AhbMaskNumBits);

  // HTRANS[1:0] encoding.
  typedef enum logic [1:0] {
    AhbTransIdle   = 2'b00,
    AhbTransBusy   = 2'b01,
    AhbTransNonseq = 2'b10,
    AhbTransSeq    = 2'b11
  } ahb_trans_e;

  // HBURST[2:0] encoding.
  typedef enum logic [2:0] {
    AhbBurstSingle = 3'b000,
    AhbBurstIncr   = 3'b001,
    AhbBurstWrap4  = 3'b010,
    AhbBurstIncr4  = 3'b011,
    AhbBurstWrap8  = 3'b100,
    AhbBurstIncr8  = 3'b101,
    AhbBurstWrap16 = 3'b110,
    AhbBurstIncr16 = 3'b111
  } ahb_burst_e;

  // HRESP encoding.
  typedef enum logic {
    AhbRespOkay  = 1'b0,
    AhbRespError = 1'b1
  } ahb_resp_e;

  typedef logic [AhbAddrWidth-1:0] addr_t;
  typedef logic [AhbDataWidth-1:0] data_t;
  typedef logic [AhbMaskWidth-1:0] mask_t;
  typedef logic [2:0]              size_t;
  typedef logic [3:0]              prot_t;

  // Manager -> Subordinate
  typedef struct packed {
    logic       hsel;
    addr_t      haddr;
    ahb_trans_e htrans;
    logic       hwrite;
    size_t      hsize;
    ahb_burst_e hburst;
    prot_t      hprot;
    logic       hmastlock;
    data_t      hwdata;
    logic       hready;
  } ahb_m2s_t;

  // Subordinate -> Manager
  typedef struct packed {
    data_t     hrdata;
    logic      hreadyout;
    ahb_resp_e hresp;
  } ahb_s2m_t;

  localparam ahb_m2s_t AHB_M2S_DEFAULT = '{
    htrans: AhbTransIdle,
    hburst: AhbBurstSingle,
    default: '0
  };

  localparam ahb_s2m_t AHB_S2M_DEFAULT = '{
    hreadyout: 1'b1,
    hresp: AhbRespOkay,
    default: '0
  };

  function automatic mask_t ahb_calc_mask(
    input addr_t addr,
    input size_t size
  );
    return (mask_t'((32'd1 << (32'd1 << size)) - 32'd1)) << addr[AhbMaskNumBits-1:0];
  endfunction

endpackage
