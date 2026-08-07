#!/bin/sh
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

mkdir -p out

wavedrom-cli -i src/peppermint_coldstart.WaveJSON    -s out/peppermint_coldstart.svg
wavedrom-cli -i src/peppermint_hotstart_int.WaveJSON -s out/peppermint_hotstart_int.svg
wavedrom-cli -i src/peppermint_hotstart_soc.WaveJSON -s out/peppermint_hotstart_soc.svg
wavedrom-cli -i src/peppermint_shutdown.WaveJSON     -s out/peppermint_shutdown.svg

drawio -x src/PowerStateDiagram.drawio -o out/PowerStateDiagram.pdf

inkscape src/peppermint_coldstart_annot.svg    -w 2000 -o out/peppermint_coldstart_annot.png
inkscape src/peppermint_hotstart_int_annot.svg -w 2000 -o out/peppermint_hotstart_int_annot.png
inkscape src/peppermint_hotstart_soc_annot.svg -w 2000 -o out/peppermint_hotstart_soc_annot.png
inkscape src/peppermint_shutdown_annot.svg     -w 2000 -o out/peppermint_shutdown_annot.png
inkscape out/PowerStateDiagram.pdf             -w 2000 -o out/PowerStateDiagram.png
