#!/usr/bin/env python3
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

from pathlib import Path
import hjson
import importlib.resources
import logging as log
import sys

from reggen import ip_block, register, multi_register, field


def extend_optional_fields(arg_vendor_file: str) -> None:
    """Extend the optional fields with vendor specific fields, in case it is defined."""

    vendor_specific_fields = import_fields(arg_vendor_file)
    ip_block.OPTIONAL_FIELDS.update(vendor_specific_fields.get("ip_block", {}))
    register.OPTIONAL_FIELDS.update(vendor_specific_fields.get("register", {}))
    multi_register.OPTIONAL_FIELDS.update(vendor_specific_fields.get("register", {}))
    field.OPTIONAL_FIELDS.update(vendor_specific_fields.get("field", {}))


def import_fields(arg_vendor_file: str) -> dict[str, str]:
    """Return vendor specific fields."""

    vendor_specific_fields = {}
    arg_vendor_file = Path(arg_vendor_file)
    if arg_vendor_file.is_file():
        vendor_specific_fields = hjson.load(arg_vendor_file.open("r"))
    else:
        log.error("File % does not exist".format(arg_vendor_file))
        sys.exit(1)

    return vendor_specific_fields
