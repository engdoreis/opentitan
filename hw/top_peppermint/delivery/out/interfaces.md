# Peppermint Interfaces (Release `Peppermint-1.0-M1-RC1`)

This document describes the parameters and ports of `lowrisc_top_peppermint_wrapper`, which is Peppermint's intended integration boundary.

Signal name suffixes indicate the direction: `_i` input, `_o` output, and `_ni`/`_no` active-low input/output.


## Parameters

| Parameter | Default | Meaning |
|---|---|---|
| `SocCpuBootAddrWidth` | `32` | Width of `soc_cpu_boot_addr_o`. Between 1 and 32 bits. |
| `EntropySrcRngBusWidth` | `4` | Width of `es_rng_bit_i`. Confirm any value other than 4 with the supplier before using. |

`lowrisc_top_peppermint` has additional parameters, which are not integrator-facing.


## Port types

The following types are used by one or more of Peppermint's input or output ports.
All these types are defined in `lowrisc_top_packages.sv`.


### `lowrisc_prim_mubi_pkg::mubi4_t`

```systemverilog
typedef enum logic [3:0] {
  MuBi4True  = 4'h6,  // 0110 - enabled
  MuBi4False = 4'h9   // 1001 - disabled
} mubi4_t;
```

A 4-bit multibit (*mubi*) value.
The two legal values are bitwise complements, so no single-bit fault turns one into the other.


### `lowrisc_prim_alert_pkg::alert_tx_t` and `lowrisc_prim_alert_pkg::alert_rx_t`

```systemverilog
typedef struct packed {
  logic alert_p;
  logic alert_n;
} alert_tx_t;
```

```systemverilog
typedef struct packed {
  logic ping_p;
  logic ping_n;
  logic ack_p;
  logic ack_n;
} alert_rx_t;
```

Differential (**p**ositive / **n**egative) alert signals from alert sender to receiver (TX) and from alert recevier to sender (RX), respectively.
A skew of up to three clock cycles (caused, e.g., by clock-domain crossings) is tolerated on each differential pair.


### `lowrisc_lc_ctrl_pkg::lc_tx_t`

```systemverilog
typedef enum logic [3:0] {
  On  = 4'h5,  // 0101 - enabled
  Off = 4'hA   // 1010 - disabled
} lc_tx_t;
```

The two legal values are bitwise complements, so no single-bit fault turns one into the other.
*Not* interchangeable with `mubi4_t`.


### `lowrisc_ahb_pkg::ahb_h2d_t`

```systemverilog
localparam int unsigned AhbAddrWidth = 32;
localparam int unsigned AhbDataWidth = 32;

typedef struct packed {         // Manager -> Subordinate
  logic       hsel;
  addr_t      haddr;
  ahb_trans_e htrans;           // IDLE/BUSY/NONSEQ/SEQ = 2'b00/01/10/11
  logic       hwrite;
  size_t      hsize;            // [2:0]
  ahb_burst_e hburst;           // [2:0]
  prot_t      hprot;            // [3:0]
  logic       hmastlock;
  data_t      hwdata;
  logic       hready;           // the interconnect's global HREADY
} ahb_h2d_t;
```

AHB3-Lite host-to-device (manager -> subordinate) signal bundle.


### `lowrisc_ahb_pkg::ahb_d2h_t`

```systemverilog
typedef struct packed {         // Subordinate -> Manager
  data_t     hrdata;
  logic      hreadyout;
  ahb_resp_e hresp;             // OKAY/ERROR = 1'b0/1'b1
} ahb_d2h_t;
```

AHB3-Lite device-to-host (subordinate -> manager) signal bundle.


### `lowrisc_tlul_pkg::tl_h2d_t`

```systemverilog
typedef struct packed {
  logic [9:0]                    rsvd;
  lowrisc_prim_mubi_pkg::mubi4_t instr_type;
  logic [6:0]                    cmd_intg;
  logic [6:0]                    data_intg;
} tl_a_user_t;
```

```systemverilog
typedef struct packed {
  logic         a_valid;
  tl_a_op_e     a_opcode;       // PutFullData/PutPartialData/Get
  logic [2:0]   a_param;
  logic [1:0]   a_size;         // log2(bytes)
  logic [7:0]   a_source;
  logic [31:0]  a_address;
  logic [3:0]   a_mask;
  logic [31:0]  a_data;
  tl_a_user_t   a_user;
  logic         d_ready;
} tl_h2d_t;
```

TileLink Uncached Lightweight (TL-UL) host-to-device signal bundle.


### `lowrisc_tlul_pkg::tl_d2h_t`

```systemverilog
typedef struct packed {
  logic [6:0]   rsp_intg;
  logic [6:0]   data_intg;
} tl_d_user_t;
```

```systemverilog
typedef struct packed {
  logic         d_valid;
  tl_d_op_e     d_opcode;       // AccessAck/AccessAckData
  logic [2:0]   d_param;
  logic [1:0]   d_size;
  logic [7:0]   d_source;
  logic [0:0]   d_sink;
  logic [31:0]  d_data;
  tl_d_user_t   d_user;
  logic         d_error;
  logic         a_ready;
} tl_d2h_t;
```

TileLink Uncached Lightweight (TL-UL) device-to-host signal bundle.


## Clocks and resets

| Port | Type | Description |
|---|---|---|
| `clk_aon_i` | `logic` | AON (always-on) domain clock |
| `rst_aon_ni` | `logic` | AON domain reset, asynchronous active low |
| `clk_main_i` | `logic` | Main domain clock |
| `rst_main_no` | `logic` | Main domain reset, active low, asynchronously asserted, synchronously deasserted with main clock |
| `rst_soc_cpu_no` | `logic` | SoC CPU reset, active low, asynchronously asserted, synchronously deasserted with AON clock |

`rst_soc_cpu_no` must be connected to the reset of the first CPU in the SoC to boot after Peppermint.


## Power handshake

| Port | Type |
|---|---|
| `power_main_req_o` | `logic` |
| `power_main_ok_i` | `logic` |
| `clk_aon_ok_i` | `logic` |
| `clk_main_ok_i` | `logic` |
| `wakeup_main_i` | `logic` |

These signals are synchronous to `clk_aon_i` and are reset with `rst_aon_ni`.

A proposal of the power handshaking protocol is presented in the shared *Power Handshaking Proposal* document; once agreed, the protocol will be added to the deliverable.

***Note***: In `Peppermint-1.0-M1`, the power handshake signals will not behave according to the proposal document above.


## DFT

| Port | Type |
|---|---|
| `scan_rst_ni` | `logic` |
| `scan_en_i` | `logic` |
| `scanmode_i` | `mubi4_t` |

The `scanmode_i` input selects scan test mode; it must be driven with:
- `MuBi4True` in scan test mode to bypass the clock manager's clock gates and dividers and substitute `scan_rst_ni` for both domains' resets.
- `MuBi4False` outside scan test mode.

`scan_en_i` is the scan shift enable and is currently only attached to the OTP macro's DFT port.

For an initial functional integration, tie these ports off as follows:
- `scanmode_i = MuBi4False`
- `scan_en_i = 1'b0`
- `scan_rst_ni = 1'b1`


## Incoming alerts from the SoC

| Port | Type |
|---|---|
| `incoming_alert_soc_tx_i` | `alert_tx_t [NIncomingAlertsSoc-1:0]` |
| `incoming_alert_soc_rx_o` | `alert_rx_t [NIncomingAlertsSoc-1:0]` |
| `incoming_lpg_cg_en_soc_i` | `mubi4_t [NIncomingLpgsSoc-1:0]` |
| `incoming_lpg_rst_en_soc_i` | `mubi4_t [NIncomingLpgsSoc-1:0]` |

These signals are synchronous to `clk_aon_i` and are reset with `rst_aon_ni`.

Peppermint is currently configured to support four alerts from the SoC (`NIncomingAlertsSoc = 4`) from one SoC low-power group (LPG; `NIncomingLpgsSoc = 1`).
All incoming SoC alert channels are currently mapped to SoC LPG 0.
Different values for these internal parameters can be requested from the supplier.

Each channel must be driven by a [`prim_alert_sender`](https://github.com/lowRISC/opentitan/blob/master/hw/ip/prim/rtl/prim_alert_sender.sv) in the SoC, instantiated with `AsyncOn = 1` to match Peppermint's alert receivers.
The alert protocol requires every channel to answer pings within a certain number of clock cycles, to detect hangups.
An unanswered ping will result in an internal alert.

The low-power group (LPG) inputs tell the alert handler when alert senders in LPG `i` are clock-gated (`incoming_lpg_cg_en_soc_i[i] = MuBi4True`) or held in reset (`incoming_lpg_rst_en_soc_i[i] = MuBi4True`) as they then cannot return a ping.
If the alert senders in an LPG are permanently clocked and out of reset, tie these signals to `MuBi4False`.


## Life cycle function and SoC control

| Port | Type |
|---|---|
| `soc_lc_dft_en_o` | `lc_tx_t` |
| `soc_lc_nvm_debug_en_o` | `lc_tx_t` |
| `soc_lc_hw_debug_en_o` | `lc_tx_t` |
| `soc_lc_cpu_en_o` | `lc_tx_t` |
| `soc_cpu_boot_addr_o` | `logic [SocCpuBootAddrWidth-1:0]` |

These signals are synchronous to `clk_aon_i` and are reset with `rst_aon_ni`.

The four life cycle signals (`soc_lc_*`) communicate a subset of the [life cycle function control](https://opentitan.org/book/hw/ip/lc_ctrl/doc/theory_of_operation.html#life-cycle-function-control-signals) to the SoC.
The SoC must wire them ensuring the following (for the full SoC, not just Peppermint):
- `soc_lc_dft_en_o` is a necessary condition for accessing any DFT functionality including scan mode and BISTs.
- `soc_lc_nvm_debug_en_o` is a necessary condition for any access to non-volatile on-chip memory (including one-time programmable memory, eFuses, resistive RAM, and magnetoresistive RAM) that does not go through the ‘frontdoor’/operational ports.
- `soc_lc_hw_debug_en_o` is a necessary condition for any other hardware debug functionality, including all RISC-V debug modules.
- `soc_lc_cpu_en_o` is a necessary condition for any CPU in the SoC to execute instructions.

`soc_cpu_boot_addr_o` must be connected to the first CPU in the SoC to boot after Peppermint.
It provides the boot address/vector of that CPU.

***Note***: `soc_cpu_boot_addr_o` is tied to zero in `Peppermint-1.0-M1`.


## Noise source

| Port | Type |
|---|---|
| `es_rng_enable_o` | `logic` |
| `es_rng_valid_i` | `logic` |
| `es_rng_bit_i` | `logic [EntropySrcRngBusWidth-1:0]` |
| `es_rng_fips_o` | `logic` |

These signals are synchronous to `clk_main_i` and are reset with `rst_main_no`.

The output `es_rng_enable_o` indicates if Peppermint expects bits from the noise source.
It can be left unconnected if the noise source cannot be deactivated.

`es_rng_bit_i` are the random bits provided by the noise source.
They must be valid and fresh in every cycle in which `es_rng_valid_i` is high.

The output `es_rng_fips_o` high asks the noise source for FIPS-grade entropy.


## Mailboxes

| Port | Type |
|---|---|
| `soc_mbx_ahb_req_i` | `ahb_h2d_t` |
| `soc_mbx_ahb_rsp_o` | `ahb_d2h_t` |
| `mbx0_doe_intr_o` | `logic` |
| `mbx0_doe_intr_en_o` | `logic` |
| `mbx0_doe_intr_support_o` | `logic` |
| `mbx0_doe_async_msg_support_o` | `logic` |
| `mbx1_doe_intr_o` | `logic` |
| `mbx1_doe_intr_en_o` | `logic` |
| `mbx1_doe_intr_support_o` | `logic` |
| `mbx1_doe_async_msg_support_o` | `logic` |

These signals are synchronous to `clk_main_i` and are reset with `rst_main_no`.

`soc_mbx_ahb_req_i` / `soc_mbx_ahb_rsp_o` is an AHB3-Lite subordinate port exposing the following address space:

| Offset | Size | Target |
|---|---|---|
| `0x000` | `0x20` | `mbx0` - Mailbox 0 |
| `0x100` | `0x20` | `mbx1` - Mailbox 1 |

`soc_mbx_ahb_req_i.hready` carries the global HREADY of the AHB segment to the subordinate.

The `mbx*_doe_*` signals belong to the PCIe Data Object Exchange (DOE) capability registers.

All Mailbox IP instances feature an inbox (for messages from the SoC to Peppermint) and an outbox (for messages from Peppermint to the SoC).


## AHB3-Lite manager port

| Port | Type |
|---|---|
| `soc_mgr_ahb_req_o` | `ahb_h2d_t` |
| `soc_mgr_ahb_rsp_i` | `ahb_d2h_t` |

These signals are synchronous to `clk_main_i` and are reset with `rst_main_no`.

This AHB3-Lite manager port is used by Peppermint to access (parts) of the SoC's address space.

`soc_mgr_ahb_req_o.hready` is tied off to zero.


## Debug module interface (DMI) over TL-UL protocol

| Port | Type |
|---|---|
| `soc_dbg_tl_req_i` | `tl_h2d_t` |
| `soc_dbg_tl_rsp_o` | `tl_d2h_t` |

These signals are synchronous to `clk_main_i` and are reset with `rst_main_no`.

TL-UL device port exposing memory-mapped registers as follows:

| Offset | Size | Target |
|---|---|---|
| `0x0000` | `0x200` | `rv_dm` = the RISC-V Debug Module attached to Ibex |
| `0x3000` | `0x1000` | `lc_ctrl` = the Life Cycle Controller CSRs |

The RISC-V Debug specification reaches a Debug Module over the Debug Module Interface (DMI), a word-addressed read/write bus.
Peppermint exposes that bus as TL-UL device port, with DMI address `n` corresponding to byte address `4*n`.

Both blocks check command (`a_user.cmd_intg`) and data (`a_user.data_intg`) integrity, so the SoC must generate them using the `get_cmd_intg` and `get_data_intg` functions in `lowrisc_tlul_pkg`, respectively.

`a_user.instr_type` must be tied to `MuBi4False`.
