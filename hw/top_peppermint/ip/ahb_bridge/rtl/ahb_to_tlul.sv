// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

module ahb_to_tlul
  import ahb_pkg::*;
  import tlul_pkg::*; (

  input  logic clk_i,
  input  logic rst_ni,

  output tl_h2d_t tl_o,
  input  tl_d2h_t tl_i,

  input  ahb_m2s_t ahb_i,
  output ahb_s2m_t ahb_o
);

  typedef struct packed {
    size_t hsize;
    logic  hwrite;
    addr_t haddr;
  } ahb_req_t;

  ahb_req_t ahb_req_q;

  logic ahb_handshake;
  logic ahb_txn_pending_q, ahb_txn_pending_d;

  logic tl_a_sent_q, tl_a_sent_d;

  logic tl_a_valid;
  logic tl_a_handshake;

  logic hreadyout;

  logic tl_resp_err;
  logic err_c2_q, err_c2_d;

  // LOW while this module is in reset, and for the first cycle after its
  // release.
  logic rst_done_q;

  always_ff @(posedge clk_i or negedge rst_ni) begin : proc_store_ahb_req
    if(!rst_ni) begin
      ahb_req_q <= '0;
    end else begin
      if  (ahb_handshake) begin
        ahb_req_q <= '{hsize:  ahb_i.hsize,
                       hwrite: ahb_i.hwrite,
                       haddr:  ahb_i.haddr};
      end
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin : proc_ahb_txn_pending
    if (!rst_ni) begin
      ahb_txn_pending_q <= 1'b0;
      tl_a_sent_q       <= 1'b0;
      err_c2_q          <= 1'b0;
      rst_done_q        <= 1'b0;
    end else begin
      ahb_txn_pending_q <= ahb_txn_pending_d;
      tl_a_sent_q       <= tl_a_sent_d;
      err_c2_q          <= err_c2_d;
      rst_done_q        <= 1'b1;
    end
  end


  assign ahb_handshake     = ahb_i.hsel && ahb_i.hready &&
                            ((ahb_i.htrans == AhbTransNonseq) || (ahb_i.htrans == AhbTransSeq));
  assign ahb_txn_pending_d = ahb_handshake || (ahb_txn_pending_q && !hreadyout);

  assign tl_resp_err = ahb_txn_pending_q && tl_i.d_valid && tl_i.d_error;
  assign err_c2_d    = tl_resp_err && !err_c2_q;

  assign hreadyout = !ahb_txn_pending_q || (tl_i.d_valid && !tl_i.d_error) || err_c2_q;

  assign tl_a_valid     = ahb_txn_pending_q && !tl_a_sent_q;
  assign tl_a_handshake = tl_a_valid && tl_i.a_ready;
  assign tl_a_sent_d    = ahb_handshake ? 1'b0 : (tl_a_sent_q || tl_a_handshake);

  always_comb begin : proc_assemble_ahb_s2m

    // Default values: inert response
    ahb_o = AHB_S2M_DEFAULT;

    // HRESP=ERROR across both cycles of the two-cycle ERROR response, and
    // whenever this module has not left reset yet.
    ahb_o.hresp     = (tl_resp_err || err_c2_q || !rst_done_q) ? AhbRespError : AhbRespOkay;
    ahb_o.hrdata    = tl_i.d_data;
    // During reset all Subordinates must ensure that HREADYOUT is HIGH (7.1.2)
    ahb_o.hreadyout = hreadyout || !rst_done_q;

  end

  always_comb begin : proc_assemble_tl_d2h

    // Default: idle bus
    tl_o = TL_H2D_DEFAULT;

    tl_o.a_valid   = tl_a_valid;
    tl_o.a_size    = top_pkg::TL_SZW'(ahb_req_q.hsize);
    tl_o.a_opcode  = !ahb_req_q.hwrite              ? Get         :
                     ahb_req_q.hsize == AhbSizeFull ? PutFullData : PutPartialData;
    tl_o.a_mask    = ahb_calc_mask(ahb_req_q.haddr, ahb_req_q.hsize);
    tl_o.a_address = ahb_req_q.haddr;

    tl_o.a_data    = ahb_i.hwdata;
    tl_o.d_ready   = 1'b1;

    tl_o.a_user.cmd_intg  = get_cmd_intg(tl_o);
    tl_o.a_user.data_intg = get_data_intg(tl_o.a_data);
  end

  logic unused_inputs;
  assign unused_inputs = ^{tl_i, ahb_i};

endmodule
