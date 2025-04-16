# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def display_drivers_repos():
    http_archive(
        name = "display_drivers",
        remote = "https://github.com/engdoreis/display_drivers.git",
        branch = "develop",
        build_file = "//third_party/display_drivers:BUILD.display_drivers.bazel",
    )
