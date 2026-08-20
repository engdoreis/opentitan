// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

module ahb_from_tlul
  import ahb_pkg::*;
  import tlul_pkg::*; (

  input  logic clk_i,
  input  logic rst_ni,

  input  tl_h2d_t tl_i,
  output tl_d2h_t tl_o,

  output ahb_m2s_t ahb_o,
  input  ahb_s2m_t ahb_i
);

  typedef struct packed {
    logic                       write;
    logic [top_pkg::TL_SZW-1:0] a_size;
  } meta_t;

  typedef struct packed {
    data_t     hrdata;
    ahb_resp_e hresp;
  } ahb_resp_t;


  logic a_handshake;
  logic d_handshake;
  logic d_valid;
  logic a_ready;

  ahb_trans_e htrans;

  data_t a_data_q;

  logic ahb_txn_pending_q, ahb_txn_pending_d;
  logic ahb_txn_settled_q;
  logic ahb_hreadyout_q;

  meta_t meta_in, meta_out;

  ahb_resp_t resp_in, resp_out;
  logic      resp_in_ready;

  prim_fifo_sync #(
    .Width($bits(meta_t)),
    .Depth(32'd3),
    .NeverClears(1'b1),
    .Secure(1'b0)
  ) u_prim_fifo_sync_meta (
    .clk_i,
    .rst_ni,
    .clr_i   (1'b0),
    .wvalid_i(a_handshake),
    .wready_o(),
    .wdata_i (meta_in),
    .rvalid_o(),
    .rready_i(d_handshake),
    .rdata_o (meta_out),
    .full_o  (),
    .depth_o (),
    .err_o   ()
  );

  assign meta_in = '{
    write:  tl_i.a_opcode == Get ? 1'b0 : 1'b1,
    a_size: tl_i.a_size
  };

  prim_fifo_sync #(
    .Width($bits(ahb_resp_t)),
    .Depth(32'd1),
    .NeverClears(1'b1),
    .Secure(1'b0)
  ) u_prim_fifo_sync_resp (
    .clk_i,
    .rst_ni,
    .clr_i   (1'b0),
    .wvalid_i(ahb_txn_settled_q && ahb_hreadyout_q),
    .wready_o(resp_in_ready),
    .wdata_i (resp_in),
    .rvalid_o(d_valid),
    .rready_i(tl_i.d_ready),
    .rdata_o (resp_out),
    .full_o  (),
    .depth_o (),
    .err_o   ()
  );

  assign resp_in = '{
    hrdata: ahb_i.hrdata,
    hresp:  ahb_i.hresp
  };

  always_ff @(posedge clk_i or negedge rst_ni) begin : proc_store_a_data
    if(!rst_ni) begin
      a_data_q <= '0;
    end else begin
      if  (a_handshake) begin
        a_data_q <= tl_i.a_data;
      end
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin : proc_ahb_txn_pending
    if (!rst_ni) begin
      ahb_txn_pending_q <= 1'b0;
      ahb_txn_settled_q <= 1'b0;
      ahb_hreadyout_q   <= 1'b0;
    end else begin
      ahb_txn_pending_q <= ahb_txn_pending_d;
      ahb_txn_settled_q <= ahb_txn_pending_q;
      ahb_hreadyout_q   <= ahb_i.hreadyout;
    end
  end

  assign ahb_txn_pending_d = a_handshake || (ahb_txn_pending_q && !ahb_i.hreadyout);

  assign a_ready     = ahb_i.hreadyout && resp_in_ready;
  assign a_handshake = tl_i.a_valid && a_ready;

  assign htrans = tl_i.a_valid && resp_in_ready ? AhbTransNonseq : AhbTransIdle;

  always_comb begin : proc_assemble_ahb_m2s

    // Default values: inert transaction
    ahb_o      = AHB_M2S_DEFAULT;
    ahb_o.hsel = 1'b1;

    ahb_o.hwrite = meta_in.write;
    ahb_o.hsize  = size_t'(meta_in.a_size);
    ahb_o.haddr  = tl_i.a_address;

    ahb_o.htrans = htrans;
    ahb_o.hwdata = a_data_q;
  end

  always_comb begin : proc_assemble_tl_d2h
    tl_o = TL_D2H_DEFAULT;

    tl_o.d_valid  = d_valid;
    tl_o.d_data   = meta_out.write ? '0 : resp_out.hrdata;
    tl_o.d_error  = resp_out.hresp == AhbRespError;
    tl_o.d_size   = meta_out.a_size;
    tl_o.d_opcode = meta_out.write ? AccessAck : AccessAckData;

    tl_o.a_ready  = a_ready;

    tl_o.d_user.rsp_intg  = get_rsp_intg(tl_o);
    tl_o.d_user.data_intg = get_data_intg(tl_o.d_data);
  end

  assign d_handshake = d_valid && tl_i.d_ready;

  logic unused_tl_i;
  assign unused_tl_i = ^tl_i;

endmodule
