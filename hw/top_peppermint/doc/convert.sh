#!/bin/sh
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

wavedrom-cli -i peppermint_coldstart.WaveJSON    -p peppermint_coldstart.png
wavedrom-cli -i peppermint_hotstart_int.WaveJSON -p peppermint_hotstart_int.png
wavedrom-cli -i peppermint_hotstart_soc.WaveJSON -p peppermint_hotstart_soc.png
wavedrom-cli -i peppermint_shutdown.WaveJSON     -p peppermint_shutdown.png
