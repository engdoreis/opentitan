# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("@rules_fuzzing//fuzzing:cc_defs.bzl", "cc_fuzz_test")
load("//rules:cross_platform.bzl", "dual_cc_library", "dual_inputs")
load("//hw/top:defs.bzl", "opentitan_require_ip", "opentitan_require_top", "opentitan_select_top")
load("//rules:linker.bzl", "ld_library")
load(
    "//rules/opentitan:defs.bzl",
    "OPENTITAN_CPU",
    "opentitan_test",
)

package(default_visibility = ["//visibility:public"])

dual_cc_library(
    name = "boot_policy_ptrs",
    srcs = dual_inputs(
        host = ["mock_boot_policy_ptrs.cc"],
        shared = ["boot_policy_ptrs.c"],
    ),
    hdrs = dual_inputs(
        host = ["mock_boot_policy_ptrs.h"],
        shared = ["boot_policy_ptrs.h"],
    ),
    deps = dual_inputs(
        host = [
            "//sw/device/lib/base:global_mock",
            "//sw/device/silicon_creator/testing:rom_test",
            "@googletest//:gtest",
        ],
        shared = [
            "//sw/device/silicon_creator/lib:nvm_ctrl",
            "//sw/device/silicon_creator/lib/base:chip",
            "//sw/device/lib/base:macros",
            "//sw/device/silicon_creator/lib:manifest",
        ],
    ),
)

cc_library(
    name = "boot_policy",
    srcs = ["boot_policy.c"],
    hdrs = ["boot_policy.h"],
    deps = [
        ":boot_policy_ptrs",
        "//sw/device/lib/base:hardened",
        "//sw/device/silicon_creator/lib:boot_data",
        "//sw/device/silicon_creator/lib:error",
        "//sw/device/silicon_creator/lib:manifest",
        "//sw/device/silicon_creator/lib:shutdown",
        "//sw/device/silicon_creator/lib/base:chip",
    ],
)

cc_test(
    name = "boot_policy_unittest",
    srcs = ["boot_policy_unittest.cc"],
    deps = [
        ":boot_policy",
        "//sw/device/silicon_creator/testing:rom_test",
        "@googletest//:gtest_main",
    ],
)

ld_library(
    name = "linker_script",
    script = "rom.ld",
    deps = [
        "//hw/top:top_ld",
        "//sw/device:info_sections",
    ],
)

cc_library(
    name = "rom_isrs",
    srcs = [
        "rom_isrs.c",
    ] + opentitan_select_top(
        {"earlgrey": ["//sw/device/silicon_creator/lib:rram_exc_handler"]},
        ["//sw/device/silicon_creator/lib:flash_exc_handler"],
    ),
    hdrs = ["rom_isrs.h"],
    defines = [
        "INTERRUPT_HANDLER=rom_interrupt_handler",
    ],
    target_compatible_with = [OPENTITAN_CPU],
    deps = [
        "//hw/top:top_lib",
        "//sw/device/lib/base:csr",
        "//sw/device/lib/base:macros",
        "//sw/device/silicon_creator/lib:error",
        "//sw/device/silicon_creator/lib:shutdown",
    ] + opentitan_select_top(
        {"earlgrey": ["//hw/top:rram_ctrl_c_regs"]},
        ["//hw/top:flash_ctrl_c_regs"],
    ),
)

cc_library(
    name = "rom_lib",
    srcs = ["rom_start.S"],
    target_compatible_with = [OPENTITAN_CPU],
    deps = [
        ":rom_common",
        ":rom_epmp",
        "//hw/top:aon_timer_c_regs",
        "//hw/top:ast_c_regs",
        "//hw/top:clkmgr_c_regs",
        "//hw/top:csrng_c_regs",
        "//hw/top:edn_c_regs",
        "//hw/top:entropy_src_c_regs",
        "//hw/top:gpio_c_regs",
        "//hw/top:lc_ctrl_c_regs",
        "//hw/top:otp_ctrl_c_regs",
        "//hw/top:pinmux_c_regs",
        "//hw/top:pwrmgr_c_regs",
        "//hw/top:rstmgr_c_regs",
        "//hw/top:rv_core_ibex_c_regs",
        "//hw/top:sensor_ctrl_c_regs",
        "//hw/top:sram_ctrl_c_regs",
        "//hw/top:top_lib",
        "//sw/device/lib/base:hardened",
        "//sw/device/lib/base:multibits",
        "//sw/device/silicon_creator/lib/base:chip",
    ],
    alwayslink = True,
)

cc_library(
    name = "rom_init",
    srcs = ["rom_init.c"],
    hdrs = ["rom_init.h"],
    target_compatible_with = [OPENTITAN_CPU],
    deps = [
        "//hw/top:top_lib",
        "//sw/device/lib/base:hardened",
        "//sw/device/lib/base:multibits",
        "//sw/device/silicon_creator/lib/base:chip",
        "//sw/device/silicon_creator/rom/lib:rom_lib",
    ],
    alwayslink = True,
)

cc_library(
    name = "rom_common",
    hdrs = [
        "rom.h",
    ],
    deps = [
        ":boot_policy",
        ":boot_policy_ptrs",
        ":bootstrap",
        ":rom_epmp",
        ":rom_state",
        ":sigverify_keys_ecdsa_p256",
        ":sigverify_keys_spx",
        ":sigverify_otp_keys",
        "//hw/top:aon_timer_c_regs",
        "//hw/top/dt",
        "//sw/device/lib/arch:device",
        "//sw/device/lib/base:bitfield",
        "//sw/device/lib/base:csr",
        "//sw/device/lib/base:macros",
        "//sw/device/lib/base:memory",
        "//sw/device/lib/base:stdasm",
        "//sw/device/lib/crt",
        "//sw/device/lib/runtime:hart",
        "//sw/device/silicon_creator/lib:boot_log",
        "//sw/device/silicon_creator/lib:build_info",
        "//sw/device/silicon_creator/lib:cfi",
        "//sw/device/silicon_creator/lib:epmp_state",
        "//sw/device/silicon_creator/lib:error",
        "//sw/device/silicon_creator/lib:irq_asm",
        "//sw/device/silicon_creator/lib:manifest",
        "//sw/device/silicon_creator/lib:nvm_ctrl",
        "//sw/device/silicon_creator/lib:otbn_boot_services",
        "//sw/device/silicon_creator/lib:shutdown",
        "//sw/device/silicon_creator/lib:stack_utilization",
        "//sw/device/silicon_creator/lib/base:chip",
        "//sw/device/silicon_creator/lib/base:sec_mmio",
        "//sw/device/silicon_creator/lib/base:static_critical",
        "//sw/device/silicon_creator/lib/base:util",
        "//sw/device/silicon_creator/lib/drivers:alert",
        "//sw/device/silicon_creator/lib/drivers:ast",
        "//sw/device/silicon_creator/lib/drivers:hmac",
        "//sw/device/silicon_creator/lib/drivers:ibex",
        "//sw/device/silicon_creator/lib/drivers:keymgr_dpe",
        "//sw/device/silicon_creator/lib/drivers:lifecycle",
        "//sw/device/silicon_creator/lib/drivers:otp",
        "//sw/device/silicon_creator/lib/drivers:pinmux",
        "//sw/device/silicon_creator/lib/drivers:pwrmgr",
        "//sw/device/silicon_creator/lib/drivers:retention_sram",
        "//sw/device/silicon_creator/lib/drivers:rnd",
        "//sw/device/silicon_creator/lib/drivers:rstmgr",
        "//sw/device/silicon_creator/lib/drivers:sensor_ctrl",
        "//sw/device/silicon_creator/lib/drivers:uart",
        "//sw/device/silicon_creator/lib/drivers:watchdog",
        "//sw/device/silicon_creator/lib/sigverify",
        "@rom_hooks",
    ],
)

cc_library(
    name = "rom_try_boot",
    srcs = ["rom_try_boot.c"],
    hdrs = ["rom_try_boot.h"],
    target_compatible_with = [OPENTITAN_CPU],
    deps = [
        ":rom_common",
    ],
    alwayslink = True,
)

cc_library(
    name = "rom_epmp",
    srcs = [
        "rom_epmp.c",
        "rom_epmp_init.S",
    ],
    hdrs = ["rom_epmp.h"],
    target_compatible_with = [OPENTITAN_CPU],
    deps = [
        "//hw/top:top_lib",
        "//sw/device/lib/base:bitfield",
        "//sw/device/lib/base:csr",
        "//sw/device/lib/base:memory",
        "//sw/device/silicon_creator/lib:epmp_state",
        "//sw/device/silicon_creator/lib:nvm_ctrl",
        "//sw/device/silicon_creator/lib/drivers:lifecycle",
    ],
)

cc_library(
    name = "rom_state",
    srcs = ["rom_state.c"],
    hdrs = ["rom_state.h"],
    target_compatible_with = [OPENTITAN_CPU],
    deps = [
        "//sw/device/lib/base:hardened",
        "//sw/device/lib/base:macros",
        "//sw/device/silicon_creator/lib:cfi",
        "//sw/device/silicon_creator/lib:error",
        "//sw/device/silicon_creator/lib:shutdown",
    ],
    alwayslink = True,
)

opentitan_test(
    name = "rom_epmp_test",
    srcs = [
        "rom_epmp_test.c",
    ],
    # This test doesn't use the OTTF and can only run in verilator right now.
    #
    # This test is designed to run and complete entirely in the ROM boot stage.
    # Setting `kind = "rom"` makes the `opentitan_test` rule aware
    # of this, and instructs it to load the test image into ROM (rather than
    # loading the default test ROM, or any other ROM that may be specified via
    # Verilator or FPGA params).
    exec_env = {
        "//hw/top_earlgrey:sim_verilator": None,
    },
    kind = "rom",
    linker_script = ":linker_script",
    linkopts = [
        "-Wl,--defsym=rom_test=1",
    ],
    deps = [
        ":rom_lib",
        "//sw/device/lib/arch:device",
        "//sw/device/lib/base:abs_mmio",
        "//sw/device/lib/base:bitfield",
        "//sw/device/lib/base:csr",
        "//sw/device/lib/base:macros",
        "//sw/device/lib/crt",
        "//sw/device/lib/dif:pinmux",
        "//sw/device/lib/dif:sram_ctrl",
        "//sw/device/lib/runtime:hart",
        "//sw/device/lib/runtime:ibex",
        "//sw/device/lib/runtime:log",
        "//sw/device/lib/runtime:print",
        "//sw/device/lib/testing:pinmux_testutils",
        "//sw/device/lib/testing/test_framework:check",
        "//sw/device/lib/testing/test_framework:status",
        "//sw/device/silicon_creator/lib:epmp_state",
        "//sw/device/silicon_creator/lib:epmp_test_unlock",
        "//sw/device/silicon_creator/lib:irq_asm",
        "//sw/device/silicon_creator/lib:nvm_ctrl",
        "//sw/device/silicon_creator/lib/base:chip",
        "//sw/device/silicon_creator/lib/base:sec_mmio",
        "//sw/device/silicon_creator/lib/base:static_critical",
        "//sw/device/silicon_creator/lib/drivers:uart",
    ],
)

filegroup(
    name = "english_breakfast_test_rom_bootstrap_srcs",
    srcs = [
        "bootstrap.c",
        "bootstrap.h",
        "//sw/device/silicon_creator/lib:bootstrap_srcs",
    ],
)

cc_library(
    name = "bootstrap",
    srcs = ["bootstrap.c"],
    hdrs = ["bootstrap.h"],
    deps = [
        "//hw/top:gpio_c_regs",
        "//hw/top:otp_ctrl_c_regs",
        "//hw/top:top_lib",
        "//hw/top/dt",
        "//sw/device/lib/base:abs_mmio",
        "//sw/device/lib/base:bitfield",
        "//sw/device/lib/base:hardened",
        "//sw/device/silicon_creator/lib:bootstrap",
        "//sw/device/silicon_creator/lib:error",
        "//sw/device/silicon_creator/lib:nvm_ctrl",
        "//sw/device/silicon_creator/lib/base:chip",
        "//sw/device/silicon_creator/lib/drivers:otp",
    ],
)

cc_test(
    name = "bootstrap_unittest",
    srcs = ["bootstrap_unittest.cc"],
    deps = [
        ":bootstrap",
        "//hw/top:flash_ctrl_c_regs",
        "//hw/top:gpio_c_regs",
        "//hw/top:otp_ctrl_c_regs",
        "//hw/top:top_lib",
        "//sw/device/silicon_creator/lib:bootstrap_unittest_util",
        "@googletest//:gtest_main",
    ],
)

# To test this target, you must specify `--config=asan-libfuzzer`.
cc_fuzz_test(
    name = "bootstrap_fuzz_test",
    srcs = ["bootstrap_fuzz_test.cc"],
    tags = [
        "fuzzer",
        "manual",
    ],
    deps = [
        ":bootstrap",
        "//sw/device/silicon_creator/lib:bootstrap_fuzzer_util",
        "@abseil-cpp//absl/types:span",
    ],
)

cc_library(
    name = "sigverify_otp_keys",
    srcs = ["sigverify_otp_keys.c"],
    hdrs = ["sigverify_otp_keys.h"],
    target_compatible_with = opentitan_require_top("earlgrey"),
    deps = [
        ":sigverify_key_types",
        "//hw/top:otp_ctrl_c_regs",
        "//hw/top/dt",
        "//sw/device/lib/base:macros",
        "//sw/device/silicon_creator/lib:error",
        "//sw/device/silicon_creator/lib/drivers:hmac",
        "//sw/device/silicon_creator/lib/drivers:lifecycle",
        "//sw/device/silicon_creator/lib/drivers:otp",
        "//sw/device/silicon_creator/lib/drivers:rnd",
    ],
)

cc_library(
    name = "sigverify_key_types",
    hdrs = ["sigverify_key_types.h"],
    deps = [
        "//sw/device/silicon_creator/lib/sigverify:ecdsa_p256_key",
        "//sw/device/silicon_creator/lib/sigverify:rsa_key",
        "//sw/device/silicon_creator/lib/sigverify:spx_key",
    ],
)

cc_library(
    name = "sigverify_keys_ecdsa_p256",
    srcs = [
        "sigverify_keys_ecdsa_p256.c",
    ],
    hdrs = [
        "sigverify_keys_ecdsa_p256.h",
    ],
    deps = [
        ":sigverify_key_types",
        ":sigverify_otp_keys",
        "//sw/device/lib/base:macros",
        "//sw/device/silicon_creator/lib:error",
        "//sw/device/silicon_creator/lib/drivers:lifecycle",
        "//sw/device/silicon_creator/lib/sigverify",
        "//sw/device/silicon_creator/lib/sigverify:ecdsa_p256_key",
    ],
)

cc_library(
    name = "sigverify_keys_spx",
    srcs = [
        "sigverify_keys_spx.c",
    ],
    hdrs = [
        "sigverify_keys_spx.h",
    ],
    deps = [
        ":sigverify_key_types",
        ":sigverify_otp_keys",
        "//hw/top:otp_ctrl_c_regs",
        "//sw/device/lib/base:macros",
        "//sw/device/silicon_creator/lib:error",
        "//sw/device/silicon_creator/lib/drivers:lifecycle",
        "//sw/device/silicon_creator/lib/sigverify",
        "//sw/device/silicon_creator/lib/sigverify:spx_key",
    ],
)
