# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def display_drivers_repos():
    http_archive(
        name = "display_drivers",
        build_file = Label("//third_party/display_drivers:BUILD.display_drivers.bazel"),
        sha256 = "d71900edcd5b1815da646c4f2025cc58510ca9c1d3cac49594de5c0bfdf6c835",
        strip_prefix = "display_drivers-0.3.1",
        urls = [
            "https://github.com/engdoreis/display_drivers/archive/refs/tags/v0.3.1.tar.gz",
        ],
    )
