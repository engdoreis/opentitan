#!/usr/bin/env python3
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

from pathlib import Path
import hjson
import importlib.resources

from reggen import ip_block, register, multi_register, field


def extend_optional_fields(arg_vendor_file: str) -> None:
    """Extend the optional fields with vendor specific fields, in case it is defined."""

    vendor_specific_fields = import_fields(arg_vendor_file)
    if "ip_block" in vendor_specific_fields:
        ip_block.OPTIONAL_FIELDS.update(vendor_specific_fields["ip_block"])
    if "register" in vendor_specific_fields:
        register.OPTIONAL_FIELDS.update(vendor_specific_fields["register"])
        multi_register.OPTIONAL_FIELDS.update(vendor_specific_fields["register"])
    if "field" in vendor_specific_fields:
        field.OPTIONAL_FIELDS.update(vendor_specific_fields["field"])


def import_fields(arg_vendor_file: str) -> dict[str, str]:
    """Return vendor specific fields."""

    vendor_specific_fields = {}
    arg_vendor_file = Path(arg_vendor_file)
    local_vendor_file = importlib.resources.files("reggen") / "vendor_specific_fields.hjson"
    if arg_vendor_file.is_file():
        vendor_specific_fields = hjson.load(arg_vendor_file.open("r"))
    elif local_vendor_file.is_file():
        vendor_specific_fields = hjson.load(local_vendor_file.open("r"))

    return vendor_specific_fields
