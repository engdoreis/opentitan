# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("//rules/opentitan:defs.bzl", "opentitan_binary", "opentitan_test", "silicon_params")

cc_library(
    name = "bridge",
    srcs = ["main.c"],
    deps = [
        "//hw/top_earlgrey/sw/autogen:top_earlgrey",
        "//sw/device/lib/dif:spi_device",
        "//sw/device/lib/testing:spi_device_testutils",
        "//sw/device/lib/testing/test_framework:check",
        "//sw/device/silicon_creator/lib:dbg_print",
    ],
)

opentitan_binary(
    name = "bridge_virtual",
    testonly = True,
    srcs = ["//sw/device/silicon_owner/bare_metal:bare_metal_start.S"],
    exec_env = { "//hw/top_earlgrey:silicon_owner_proda_rom_ext": None },
    linker_script = "//sw/device/silicon_owner/bare_metal:ld_slot_virtual",
    manifest = "//sw/device/silicon_owner/bare_metal:manifest",
    deps = [
        ":bridge",
        "//sw/device/lib/crt",
        "//sw/device/silicon_creator/lib:manifest_def",
        "//sw/device/silicon_creator/lib/base:static_critical",
    ],
)

opentitan_test(
    name = "bridge_test",
    exec_env = { "//hw/top_earlgrey:silicon_owner_proda_rom_ext": None },
    silicon = silicon_params(
        binaries = {
            ":bridge_virtual": "firmware",
        },
        # exit_success = "CONFIGURED\r\n",
        interface = "ftdi",
        timeout = "eternal",
    ),
)
