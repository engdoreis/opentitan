# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def display_drivers_repos():
    http_archive(
        name = "display_drivers",
        build_file = Label("//third_party/display_drivers:BUILD.display_drivers.bazel"),
        sha256 = "8dc986c010757847d3189cd3635396de6098f8aeb78f5f80ac92177e6bc9c8ff",
        strip_prefix = "display_drivers-rc0.2.0",
        urls = [
            "https://github.com/engdoreis/display_drivers/archive/refs/tags/rc0.2.0.tar.gz",
        ],
    )
