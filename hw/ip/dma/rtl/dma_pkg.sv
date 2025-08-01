// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

package dma_pkg;
  // Create a type to be exposed for the inter_signal_list in the HJSON definition
  // This type is needed since regtool cannot evaluate parameters defined in the HJSON
  typedef logic [dma_reg_pkg::NumIntClearSources-1:0] lsio_trigger_t;

  // Possible error bits the DMA can raise
  typedef enum logic [4:0] {
    DmaSrcAddrErr,
    DmaDstAddrErr,
    DmaOpcodeErr,
    DmaSizeErr,
    DmaBusErr,
    DmaBaseLimitErr,
    DmaRangeValidErr,
    DmaAsidErr,
    DmaErrLast
  } dma_error_e;

  // DMAC Transfer width as encoded in `transfer_width` register
  typedef enum logic [1:0] {
    DmaXfer1BperTxn = 2'h0,
    DmaXfer2BperTxn = 2'h1,
    DmaXfer4BperTxn = 2'h2
  } dma_transfer_width_e;

  // ASID uses a 4-bit FI protected encoding with a minimum Hamming distance of 2-bit
  parameter int unsigned ASID_WIDTH = 4;

  typedef enum logic [ASID_WIDTH-1:0] {
    OtInternalAddr = 4'h7,
    SocControlAddr = 4'ha,
    SocSystemAddr  = 4'h9
  } asid_encoding_e;

  // Supported opcodes by the DMA
  typedef enum logic [3:0] {
    OpcCopy   = 4'h0,
    OpcSha256 = 4'h1,
    OpcSha384 = 4'h2,
    OpcSha512 = 4'h3
  } opcode_e;

  // Named bit definitions for the SRC_ and DST_CTRL register for convenience
  parameter bit AddrIncrement   = 1'b1;
  parameter bit AddrNoIncrement = 1'b0;
  parameter bit AddrWrapChunk   = 1'b1;
  parameter bit AddrNoWrapChunk = 1'b0;

  // Control state captured during the operation
  typedef struct packed {
    // Control register
    opcode_e    opcode;
    logic       cfg_handshake_en;
    logic       cfg_digest_swap;
    logic       range_valid;
    // Enabled memory base register
    logic [31:0] enabled_memory_range_base;
    // Enabled memory limit register
    logic [31:0] enabled_memory_range_limit;
  } control_state_t;


  // Encoding generated with:
  // $ ./util/design/sparse-fsm-encode.py -d 3 -m 11 -n 8 \
  //     -s 8273645 --language=sv
  //
  // Hamming distance histogram:
  //
  //  0: --
  //  1: --
  //  2: --
  //  3: ||||||||||||| (27.27%)
  //  4: |||||||||||||||||||| (40.00%)
  //  5: ||||||||| (18.18%)
  //  6: |||| (9.09%)
  //  7: || (5.45%)
  //  8: --
  //
  // Minimum Hamming distance: 3
  // Maximum Hamming distance: 7
  // Minimum Hamming weight: 3
  // Maximum Hamming weight: 7

  typedef enum logic [7:0] {
    DmaIdle                 = 8'b11110111,
    DmaClearIntrSrc         = 8'b10101100,
    DmaWaitIntrSrcResponse  = 8'b00101011,
    DmaAddrSetup            = 8'b11110000,
    DmaSendRead             = 8'b01000011,
    DmaWaitReadResponse     = 8'b00011111,
    DmaSendWrite            = 8'b10010100,
    DmaWaitWriteResponse    = 8'b11011001,
    DmaError                = 8'b01010110,
    DmaShaFinalize          = 8'b00110001,
    DmaShaWait              = 8'b01111010
  } dma_ctrl_state_e;

  // Maximum number of outstanding TL-UL requests per host post
  parameter int unsigned NUM_MAX_OUTSTANDING_REQS = 1;

  ////////////////////////////
  // System Port Interfaces //
  ////////////////////////////

  parameter int unsigned SYS_NUM_REQ_CH      = 2;
  parameter int unsigned SYS_ADDR_WIDTH      = 64;
  parameter int unsigned SYS_METADATA_WIDTH  = 3;
  parameter int unsigned SYS_RACL_WIDTH      = 4;
  parameter int unsigned SYS_DATA_BYTEWIDTH  = 4;
  parameter int unsigned SYS_DATA_WIDTH      = SYS_DATA_BYTEWIDTH * 8;
  parameter int unsigned SYS_NUM_ERROR_TYPES = 1;

  // Supported Opcodes on the bus
  typedef enum logic [2:0] {
    SysOpcRead            = 3'd0,
    SysOpcCmoClean        = 3'd1,
    SysOpcAtomicNoDataRsp = 3'd2,
    SysOpcAtomicDataRsp   = 3'd3,
    SysOpcWrite           = 3'd4,
    SysOpcWriteOrdered    = 3'd5,
    SysOpcMsgIntrReq      = 3'd6,
    SysOpcMsgP2P          = 3'd7
  } sys_opc_e;

  // Request command type
  typedef enum logic {
    SysCmdRead  = 1'd0,
    SysCmdWrite = 1'd1
  } sys_cmd_type_e;

  // System port request interface
  typedef struct packed {
    logic     [SYS_NUM_REQ_CH-1:0]                         vld_vec;
    logic     [SYS_NUM_REQ_CH-1:0][SYS_METADATA_WIDTH-1:0] metadata_vec;
    sys_opc_e [SYS_NUM_REQ_CH-1:0]                         opcode_vec;
    logic     [SYS_NUM_REQ_CH-1:0][SYS_ADDR_WIDTH-1:0]     iova_vec;
    logic     [SYS_NUM_REQ_CH-1:0][SYS_RACL_WIDTH-1:0]     racl_vec;
    logic     [SYS_DATA_WIDTH-1:0]                         write_data;
    logic     [SYS_DATA_BYTEWIDTH-1:0]                     write_be;
    logic     [SYS_DATA_BYTEWIDTH-1:0]                     read_be;
  } sys_req_t;

  // System port response interface
  typedef struct packed {
    logic [SYS_NUM_REQ_CH-1:0]         grant_vec;
    logic                              read_data_vld;
    logic [SYS_DATA_WIDTH-1:0]         read_data;
    logic [SYS_METADATA_WIDTH-1:0]     read_metadata;
    logic                              error_vld;
    logic [SYS_NUM_ERROR_TYPES-1:0]    error_vec;
  } sys_rsp_t;

endpackage
