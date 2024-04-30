#!/usr/bin/env python3
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

"""
This script lint the various opentitan testplan.hjson
usage:
    python3 ./util/lint_testplan.py --schema hw/lint/sival_testplan_schema.json \
                                    --dir hw/top_earlgrey/data/ip/
"""

import argparse
import glob
import logging
import sys
import pathlib
import hjson
import json
import jsonschema


def main(args: argparse.Namespace) -> int:
    files = [f for f in glob.glob(f"{args.dir}/*.hjson")]

    assert args.schema
    return Linter(args.schema).check(files)


class Linter:
    def __init__(self, schema_file: str):
        self.schema = json.load(open(schema_file, "r", encoding="utf-8"))

    def check(self, files: str) -> int:
        res: int = 0
        for f in files:
            try:
                testplan = hjson.load(open(f, "r", encoding="utf-8"))
                jsonschema.validate(testplan, schema=self.schema)

            except jsonschema.ValidationError as e:
                logging.info("Validation failed on file %s: %s", f, e)
                res = -1
            except hjson.scanner.HjsonDecodeError as e:
                logging.info("Failed to decode file %s: %s", f, e)
                res = -1
                break

        if res == 0:
            logging.info("No errors found!")

        return res


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--logging",
        default="info",
        choices=["debug", "info", "warning", "error", "critical"],
        help="Logging level",
    )
    parser.add_argument(
        "--dir",
        required=True,
        help="A dir with all the testplan.hjson.",
    )
    parser.add_argument(
        "--schema",
        required=True,
        type=pathlib.Path,
        help="A json file with the linting rules to be used.",
    )

    args = parser.parse_args()
    logging.basicConfig(level=args.logging.upper())
    sys.exit(main(args))
