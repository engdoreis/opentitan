# AHB UVM Agent

The AHB agent drives and monitors the manager side of an AHB bus.
It provides a driver, a monitor, a register adapter and a register layering sequence, so a `uvm_reg` model can issue its accesses over AHB.

`ahb_if` uses a max-footprint approach: signals are declared at their widest.
The configurable properties (`addr_width`, `data_width`, `hburst_width`, `hprot_width`, `has_write_strobes`, `num_subordinates`) are set through `set_*` calls rather than parameters.
The interface has three modes, selected by `if_mode`: `Host` when a manager agent drives it, `Device` when a subordinate agent does, and `Monitor` when nothing drives it.

## Analysis ports

The monitor publishes on `m_request_port`, `m_response_port` and `m_transaction_port`.
A request goes out on `m_request_port` as soon as its address phase is seen, so a subscriber can watch a transfer while its data phase is still to come.
The write data of a write transfer is not known at that point, and only reaches subscribers on `m_transaction_port`, which carries the request and its response as a pair once the data phase completes.
A transfer that is still in flight when reset is asserted is reported on `m_transaction_port` as an item whose `m_response` is null.
Data captured from the bus is masked down to the transfer size, because AHB leaves the byte lanes outside the transfer undefined.

## Scope

Only the manager side is implemented here.
The work to write a subordinate agent is tracked by issue #41.

There is no functional coverage model yet.
