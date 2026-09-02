// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// A monitor that watches an AHB interface

class ahb_monitor extends uvm_monitor;
  `uvm_component_utils(ahb_monitor)

  // The interface being tracked. Set this with set_vif().
  local virtual ahb_if m_vif;

  // This event gets triggered when the monitor sees a reset. Structuring it like this (instead of
  // waiting on m_vif.rst_ni in watch_until_reset) simulates dramatically more quickly.
  local uvm_event saw_reset;

  // True between seeing the address phase of a transfer and seeing its data phase complete (or a
  // reset abandoning it). Read by phase_ready_to_end to hold the run phase open.
  local bit m_txn_in_flight;

  // True while an end-of-test objection raised by phase_ready_to_end is outstanding. This stops a
  // second call to phase_ready_to_end raising a second objection for the same transfer.
  local bit m_eot_objection_raised;

  // How many clock cycles phase_ready_to_end waits for an in-flight transfer to complete before it
  // gives up and reports an error. Set this with set_eot_drain_cycles().
  local int unsigned m_eot_drain_cycles = 100;

  // The analysis ports for requests, responses and complete transactions.
  //
  // A request is published as soon as its address phase is seen, so that a subscriber can see a
  // transfer while its data phase is still to come. The write data of a write transfer is not known
  // at that point, so the request that m_transaction_port carries is a copy with m_wdata and
  // m_wstrb filled in. A transfer that is still in flight when a reset is asserted appears on
  // m_transaction_port as an item whose m_response is null.
  uvm_analysis_port #(ahb_txn_request_item)  m_request_port;
  uvm_analysis_port #(ahb_txn_response_item) m_response_port;
  uvm_analysis_port #(ahb_txn_item)          m_transaction_port;

  // Standard SV/UVM methods
  extern function new(string name, uvm_component parent);
  extern function void build_phase (uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function void phase_ready_to_end(uvm_phase phase);

  // Set the interface that is being tracked
  extern function void set_vif(virtual ahb_if vif);

  // Set and get the number of clock cycles that phase_ready_to_end allows an in-flight transfer to
  // complete in. Raise this for a subordinate that applies back pressure for a long time.
  extern function void set_eot_drain_cycles(int unsigned cycles);
  extern function int unsigned get_eot_drain_cycles();

  // Track requests and responses on m_vif
  extern local task watch_interface();

  // Track requests and responses on m_vif, leaving early if reset is asserted
  extern local task watch_until_reset();
endclass

function ahb_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  saw_reset = new("saw_reset");
endfunction

function void ahb_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  m_request_port = new("m_request_port", this);
  m_response_port = new("m_response_port", this);
  m_transaction_port = new("m_transaction_port", this);

  if (m_vif == null && !uvm_config_db#(virtual ahb_if)::get(this, "", "vif", m_vif)) begin
    `uvm_fatal(get_full_name(), "Interface neither supplied with set_vif nor with uvm_config_db.")
  end
endfunction

task ahb_monitor::run_phase(uvm_phase phase);
  fork
    super.run_phase(phase);
    watch_interface();
    forever begin
      wait(m_vif.rst_ni === 1'b1);
      wait(m_vif.rst_ni !== 1'b1);
      saw_reset.trigger();
    end
  join
endtask

function void ahb_monitor::phase_ready_to_end(uvm_phase phase);
  super.phase_ready_to_end(phase);

  // Only the run phase has traffic on the bus, so there is nothing to hold open in any other phase
  if (phase.get_name() != "run") begin
    return;
  end

  // No transfer is waiting for a data phase, so the bus is idle and the phase can end
  if (!m_txn_in_flight) begin
    return;
  end

  // An objection raised by an earlier call is still outstanding and the process below will drop it
  // when the bus goes idle. A second objection for the same transfer would never be dropped.
  if (m_eot_objection_raised) begin
    return;
  end

  m_eot_objection_raised = 1;
  phase.raise_objection(this, "AHB transfer in flight");

  fork begin
    fork begin : isolation_fork
      fork
        wait (!m_txn_in_flight);
        repeat (m_eot_drain_cycles) @(m_vif.mon_cb);
      join_any
      disable fork;
    end join

    if (m_txn_in_flight) begin
      `uvm_error(get_full_name(),
                 $sformatf({"The AHB bus was still busy %0d cycles after the run phase was ready ",
                            "to end. Either a subordinate never completed a data phase, or a ",
                            "manager is still sending transfers."},
                           m_eot_drain_cycles))
    end

    m_eot_objection_raised = 0;
    phase.drop_objection(this, "AHB transfer drained");
  end join_none
endfunction

function void ahb_monitor::set_vif(virtual ahb_if vif);
  m_vif = vif;
endfunction

function void ahb_monitor::set_eot_drain_cycles(int unsigned cycles);
  m_eot_drain_cycles = cycles;
endfunction

function int unsigned ahb_monitor::get_eot_drain_cycles();
  return m_eot_drain_cycles;
endfunction

task ahb_monitor::watch_interface();
  forever begin
    wait(m_vif.rst_ni === 1'b1);
    watch_until_reset();

    // Check that there really has been a reset (to ensure the loop iterations take a positive
    // amount of time)
    if (m_vif.rst_ni === 1'b1) begin
      `uvm_fatal(get_full_name(), "watch_until_reset exited early")
    end
  end
endtask

task ahb_monitor::watch_until_reset();
  // A non-Idle request that has been seen. This is generated when we see a request being sent
  // (because there is no back pressure from the response side).
  ahb_txn_request_item req_item;

  forever begin
    // Wait until the observed region of a time slot where there is a positive clock edge, or drop
    // out early if there is a reset asserted.
    fork begin : isolation_fork
      fork
        @(m_vif.mon_cb);
        saw_reset.wait_ptrigger();
      join_any
      disable fork;
    end join

    if (m_vif.rst_ni !== 1'b1) begin
      // If req_item is not null, there was a transaction in flight that didn't get a response. Send
      // the partial transaction.
      if (req_item != null) begin
        ahb_txn_item txn_item = ahb_txn_item::type_id::create("txn_item");
        txn_item.m_request = req_item;
        m_transaction_port.write(txn_item);
      end
      m_txn_in_flight = 0;
      return;
    end

    // Has a request been sent? If so, the subordinate has the opportunity to generate a response.
    if (req_item != null) begin
      ahb_txn_request_item  full_req;
      ahb_txn_response_item rsp_item;
      ahb_txn_item          txn_item;

      // Infer an appropriate hwstrb value to use for the item if m_vif.has_write_strobes is false.
      int unsigned addr_mod_data_width  = req_item.m_addr % (m_vif.data_width / 8);
      bit [127:0]  observed_wstrb;

      // Masks selecting the bits of a transfer of 1 << m_size bytes. AHB leaves the byte lanes
      // outside the transfer undefined, so the captured data is masked down to the transfer before
      // it goes into an item.
      bit [1023:0] size_data_mask = (1024'd1 << (8 << req_item.m_size)) - 1;
      bit [127:0]  size_strb_mask = (128'd1 << (1 << req_item.m_size)) - 1;

      // If the muxed hready signal is low, the selected subordinate is applying back pressure and
      // there is no transfer on this cycle. Go round the loop again. Note that m_txn_in_flight is
      // already set, so the transfer still holds the run phase open.
      if (m_vif.mon_cb.hready !== 1'b1) begin
        continue;
      end

      // The wstrb value might not actually be signalled on the bus if m_vif.has_write_strobes is
      // false. In that case, infer a write strobe from hsize.
      observed_wstrb = m_vif.has_write_strobes ? m_vif.mon_cb.hwstrb
                                               : (size_strb_mask << addr_mod_data_width);

      // req_item went out on m_request_port when its address phase was seen and a subscriber may
      // still be holding it, so the write data goes onto a copy rather than onto req_item itself.
      // That copy is the request that m_transaction_port carries.
      if (!$cast(full_req, req_item.clone())) begin
        `uvm_fatal(get_full_name(), "Failed to clone the request item.")
      end

      // If the transfer is a write, the data phase will have write data from the manager. Add this
      // to full_req.
      full_req.m_wdata = (m_vif.mon_cb.hwdata >> (8 * addr_mod_data_width)) & size_data_mask;
      full_req.m_wstrb = (observed_wstrb >> addr_mod_data_width) & size_strb_mask;

      // Make a response item, then pair it up with the request, sending the response and the pair
      // on their respective analysis ports.
      rsp_item = ahb_txn_response_item::type_id::create("rsp_item");
      rsp_item.m_rdata = (m_vif.mon_cb.hrdata_muxed >> (8 * addr_mod_data_width)) & size_data_mask;
      rsp_item.m_resp  = m_vif.mon_cb.hresp_muxed;
      m_response_port.write(rsp_item);

      txn_item = ahb_txn_item::type_id::create("txn_item");
      txn_item.m_request = full_req;
      txn_item.m_response = rsp_item;
      m_transaction_port.write(txn_item);

      req_item = null;
    end

    // If we get here then there was either no pending request or there was a request that has had a
    // response. If the manager is asserting a NONSEQ or SEQ request for some subordinate now,
    // create an item to represent it.
    if (|m_vif.mon_cb.hsel &&
        m_vif.mon_cb.htrans inside {TransNonSequential, TransSequential}) begin
      if (!$onehot(m_vif.mon_cb.hsel)) begin
        `uvm_error(get_full_name(),
                   $sformatf("hsel signal for a request is not one-hot (hsel = 0x%0h)",
                             m_vif.mon_cb.hsel))
      end else begin
        req_item = ahb_txn_request_item::type_id::create("req_item");

        req_item.m_subordinate_idx = $clog2(m_vif.mon_cb.hsel);
        req_item.m_addr = m_vif.mon_cb.haddr;
        req_item.m_burst = burst_e'(m_vif.mon_cb.hburst);
        req_item.m_lock = m_vif.mon_cb.hmastlock;
        req_item.m_prot = m_vif.mon_cb.hprot;
        req_item.m_size = m_vif.mon_cb.hsize;
        req_item.m_trans = trans_e'(m_vif.mon_cb.htrans);
        req_item.m_write = m_vif.mon_cb.hwrite;
        m_request_port.write(req_item);
      end
    end

    // Update the in-flight flag once per clock edge, when the loop has finished deciding whether a
    // transfer is waiting for its data phase. Setting it in the branches above instead would let it
    // glitch low between two back-to-back transfers, which is enough for phase_ready_to_end to stop
    // waiting in the middle of a transfer.
    m_txn_in_flight = (req_item != null);
  end
endtask
