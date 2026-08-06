# Peppermint 1.0 M1 Deliverable - Release Candidate 2 (`Peppermint-1.0-M1-RC2`)

This deliverable consists of four files, with the following intent:

- `lowrisc_peppermint_rtl.sv`: The pickled Peppermint top-level design including all load-bearing RTL (i.e., `lowrisc_top_peppermint` and all modules it instantiates together with all their packages). This needs to be encrypted.
- `lowrisc_top_packages.sv`: A pickle of all packages containing definitions needed for `lowrisc_top_peppermint`'s ports. This stays unencrypted.
- `lowrisc_top_peppermint_wrapper.sv`: A simple wrapper instantiating `lowrisc_top_peppermint` and importing the top-level package. This stays unencrypted.
- `lowrisc_prim_generic.sv`: A pickle of all tech-specific prim modules. This stays unencrypted and can be swapped for RTL, FPGA, and ASIC targets. The generic implementation is for RTL simulation only. For a sensible trial synthesis, at a minimum, the macros `prim_ram_1p` and `prim_rom` need to be black-boxed, all other cells should be sensibly synthesizable. For a production synthesis, all (or at least most) tech-specific prim modules need to be replaced with tech-specific implementations, either for security reasons or for PPA reasons.

The ports of `lowrisc_top_peppermint` are specified in the shared architecture document and described in detail in [interfaces.md](interfaces.md).

The recommended (for some tools required) file read order is:
```
lowrisc_top_packages.sv
lowrisc_prim_generic.sv
lowrisc_peppermint_rtl.sv
lowrisc_top_peppermint_wrapper.sv
```
