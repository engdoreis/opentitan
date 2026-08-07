# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

read_verilog -sv {
    lowrisc_top_packages.sv
    lowrisc_prim_generic.sv
    lowrisc_peppermint_rtl.sv
    lowrisc_top_peppermint_wrapper.sv
}
synth_design -rtl -top lowrisc_top_peppermint_wrapper -part xc7k160tfbg484-1
