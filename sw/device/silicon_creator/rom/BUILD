# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("@rules_pkg//pkg:mappings.bzl", "pkg_files")
load("//rules:files.bzl", "output_groups")
load(
    "//rules/opentitan:defs.bzl",
    "fpga_params",
    "opentitan_binary",
    "opentitan_manual_test",
    "opentitan_test",
)
load("//rules/opentitan:legacy.bzl", "legacy_rom_targets")
load("//rules:symbols.bzl", "check_elf_symbols_test")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "doc_files",
    srcs = glob([
        "**/*.md",
        "**/*.svg",
    ]) + [
        "//sw/device/silicon_creator/rom/data:rom_e2e_testplan.hjson",
        "//sw/device/silicon_creator/rom/data:rom_manual_testplan.hjson",
    ],
)

[
    # Generate targets with `sim_dv` and `sim_verilator` suffixes as expected
    # by dvsim.
    alias(
        name = "rom_{}".format(env),
        actual = "//hw/top:rom",
    )
    for env in [
        "sim_dv",
        "sim_verilator",
    ]
]

opentitan_binary(
    name = "earlgrey_rom",
    srcs = [
        "rom_earlgrey.c",
    ],
    collect_code_coverage = 0,
    exec_env = [
        "//hw/top_earlgrey:fpga_cw340",
        "//hw/top_earlgrey:sim_dv_base",
        "//hw/top_earlgrey:sim_verilator_base",
        "//hw/top_earlgrey:sim_qemu_base",
        "//hw/top_earlgrey:silicon_creator",
    ],
    kind = "rom",
    linker_script = "//sw/device/silicon_creator/rom/lib:linker_script",
    transitive_features = [
        "use_lld",
        "lto",
        "minsize",
    ],
    deps = [
        "//sw/device/silicon_creator/rom/lib:rom_lib",
        "//sw/device/silicon_creator/rom/lib:rom_init",
        "//sw/device/silicon_creator/rom/lib:rom_try_boot",
        # We depend on rom_isrs here rather than in mask_rom_lib so that the
        # `rom_exception_handler` symbol remains unresolved and can be supplied
        # by tests such as `rom_epmp_test`.
        "//sw/device/silicon_creator/rom/lib:rom_isrs",
    ],
)

# 64-bit division is forbidden in the ROM (or needs to use udiv64_slow)
check_elf_symbols_test(
    name = "mask_rom_symbol_check",
    forbidden = [
        "__udivdi3",
        "__divdi3",
    ],
    target = "//hw/top:rom",
)

# Create the legacy ROM target names so that existing splicing rules can find
# the rom VMEM files.
legacy_rom_targets(
    suffixes = {
        "fpga_cw340": ["//hw/top_earlgrey:fpga_cw340"],
    },
    target = "//hw/top:rom",
)

[
    filegroup(
        name = "earlgrey_rom_{}_hashfile".format(dev),
        testonly = True,
        srcs = ["//hw/top:rom"],
        output_group = "{}_hashfile".format(dev),
    )
    for dev in [
        "fpga_cw340",
        "silicon_creator",
    ]
]

output_groups(
    name = "pre_package",
    testonly = True,
    srcs = ["//hw/top:rom"],
    groups = [
        "fpga_cw340_binary",
        "fpga_cw340_elf",
        "fpga_cw340_rom",
        "fpga_cw340_mapfile",
        "sim_dv_elf",
        "sim_dv_rom",
        "sim_dv_logs",
        "sim_dv_mapfile",
        "sim_verilator_elf",
        "sim_verilator_rom",
        "sim_verilator_mapfile",
        "silicon_creator_binary",
        "silicon_creator_elf",
        "silicon_creator_rom",
        "silicon_creator_mapfile",
    ],
)

pkg_files(
    name = "package",
    testonly = True,
    srcs = [":pre_package"],
    prefix = "earlgrey/rom",
)

opentitan_manual_test(
    name = "manual_test",
    tags = [
        "manual",
        "no-cache",
    ],
    testplan = "//sw/device/silicon_creator/rom/data:rom_manual_testplan.hjson",
)

output_groups(
    name = "rom_binaries",
    srcs = ["//hw/top:rom"],
    groups = [
        "fpga_cw340_binary",
        "sim_dv_binary",
        "sim_verilator_binary",
        "silicon_creator_binary",
    ],
)

output_groups(
    name = "rom_disassembly",
    srcs = ["//hw/top:rom"],
    groups = [
        "fpga_cw340_disassembly",
        "sim_dv_disassembly",
        "sim_verilator_disassembly",
        "silicon_creator_disassembly",
    ],
)

genrule(
    name = "rom_hashes",
    testonly = True,
    srcs = [
        ":rom_binaries",
    ],
    outs = ["rom_hashes.txt"],
    cmd = """
        echo "SHA256 of rom with real keys" > $@
    for f in $(locations :rom_binaries); do
        if [[ "$$f" == *bin ]]; then
            name=$$(basename $$f)
        echo $$f >> $@
        size=$$(stat -L -c %s $$f)
        full=$$(sha256sum $$f | cut -f1 -d' ')
        without_build_info=$$(head -c -12 $$f | sha256sum | cut -f1 -d' ')
        code=$$(echo $$without_build_info | sed -E s'/(.{8})(.{8})(.{8})(.{8})(.{8})(.{8})(.{8})(.{8})/0x\\8,0x\\7,0x\\6,0x\\5,0x\\4,0x\\3,0x\\2,0x\\1,/g')

        echo "              size: $$size" >> $@
        echo "     complete hash: $$full" >> $@
        echo " without build_info: $$without_build_info" >> $@
        echo "w/o build_info le32: $$code" >> $@
        echo >> $@
        fi
    done
    """,
)

genrule(
    name = "empty_flash",
    testonly = True,
    outs = ["empty_flash.bin"],
    cmd = """
        head --bytes=65536 /dev/zero | tr '\\0' '\\377' > $@
    """,
)

STACK_UTILIZATION_FPGA_PARAMS = {
    fpga: fpga_params(
        binaries = {
            "//sw/device/silicon_creator/rom/e2e:empty_test_slot_a_prod_key_0": "good_a",
            "//sw/device/silicon_creator/rom/e2e:empty_test_slot_b_prod_key_0": "good_b",
            "//sw/device/silicon_creator/rom/e2e:empty_test_slot_a_prod_key_0_corrupted_fpga_{}_rom_with_fake_keys_signed_bin".format(fpga): "bad_a",
            ":empty_flash": "empty",
        },
        stack_usage = "STK:[0-9A-Fa-f/]+\r\n",
        tags = ["manual"],
        test_cmd = """
            --exec="no-op --info '
            ###########################################################################
            # This is a manual test.  Run it with:
            #     --test_output=streamed --copt=-DSTACK_UTILIZATION_CHECK
            ###########################################################################'"

            --exec="no-op --info '### Measuring stack utilization for bootstrap slot A'"
            --exec="bootstrap --clear-uart=true --leave-in-bootstrap {good_a}"
            --exec="console --non-interactive --exit-success='{stack_usage}' --exit-failure='{exit_failure}'"

            --exec="gpio remove ROM_BOOTSTRAP"
            --exec="gpio apply RESET"
            --exec="gpio remove RESET"
            --exec="no-op --info '### Measuring stack utilization for booting slot A'"
            --exec="console --non-interactive --exit-success='PASS.*\r\n' --exit-failure='{exit_failure}'"

            --exec="no-op --info '### Measuring stack utilization for bootstrap slot B'"
            --exec="bootstrap --mirror=false --clear-uart=true --leave-in-bootstrap {good_b}@{rom_ext_slot_b}"
            --exec="console --non-interactive --exit-success='{stack_usage}' --exit-failure='{exit_failure}'"

            --exec="gpio remove ROM_BOOTSTRAP"
            --exec="gpio apply RESET"
            --exec="gpio remove RESET"
            --exec="no-op --info '### Measuring stack utilization for booting slot A'"
            --exec="console --non-interactive --exit-success='PASS.*\r\n' --exit-failure='{exit_failure}'"

            --exec="no-op --info '### Measuring stack utilization for bootstrap slot A (corrupted image)'"
            --exec="bootstrap --clear-uart=true --leave-in-bootstrap {bad_a}"
            --exec="console --non-interactive --exit-success='{stack_usage}' --exit-failure='{exit_failure}'"

            --exec="gpio remove ROM_BOOTSTRAP"
            --exec="gpio apply RESET"
            --exec="gpio remove RESET"
            --exec="no-op --info '### Measuring stack utilization for failed boot of slot A'"
            --exec="console --non-interactive --exit-success='{stack_usage}' --exit-failure='PASS|FAIL'"

            --exec="no-op --info '### Measuring stack utilization for bootstrap slot A (empty image)'"
            --exec="bootstrap --clear-uart=true --leave-in-bootstrap {empty}"
            --exec="console --non-interactive --exit-success='{stack_usage}' --exit-failure='{exit_failure}'"

            --exec="gpio remove ROM_BOOTSTRAP"
            --exec="gpio apply RESET"
            --exec="gpio remove RESET"
            --exec="no-op --info '### Measuring stack utilization for empty flash'"
            --exec="console --non-interactive --exit-success='{stack_usage}' --exit-failure='PASS|FAIL'"
            no-op
        """,
        testopt_bootstrap = "False",
    )
    for fpga in ["cw340"]
}

opentitan_test(
    name = "stack_utilization_test",
    cw340 = STACK_UTILIZATION_FPGA_PARAMS["cw340"],
    exec_env = {
        "//hw/top_earlgrey:fpga_cw340_rom_with_fake_keys": "cw340",
    },
)
