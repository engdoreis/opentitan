# Elaborating the Deliverable

Commands to read the pickled RTL in [`out/`](out) into each tool.
Run them from `out/`.

The four files are one compilation unit and must be read in this order, since each one refers to packages the previous ones declare:

```
lowrisc_top_packages.sv
lowrisc_prim_generic.sv
lowrisc_peppermint_rtl.sv
lowrisc_top_peppermint_wrapper.sv
```

`lowrisc_top_peppermint_wrapper` is the top module in every flow below.


## VCS

```sh
vlogan -sverilog -full64 \
    lowrisc_top_packages.sv \
    lowrisc_prim_generic.sv \
    lowrisc_peppermint_rtl.sv \
    lowrisc_top_peppermint_wrapper.sv

vcs -full64 lowrisc_top_peppermint_wrapper -o simv.lowrisc_top_peppermint_wrapper
```


## Vivado

`synth_design -rtl` stops after RTL elaboration.
The part is only needed because `synth_design` requires one; nothing in the design depends on it.

```sh
vivado -mode batch -nojournal -nolog -source ../elab_vivado.tcl
```


## Yosys

```sh
yosys -p "read_slang --top lowrisc_top_peppermint_wrapper --single-unit \
              lowrisc_top_packages.sv \
              lowrisc_prim_generic.sv \
              lowrisc_peppermint_rtl.sv \
              lowrisc_top_peppermint_wrapper.sv; \
          hierarchy -check -top lowrisc_top_peppermint_wrapper"
```
