#!/usr/bin/env python3
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
"""
This script parses the dv testplan and generates a csv or/and update a spreadsheet.

usage with a single file:
    ./util/py/scripts/testplan_decoder.py --file <path/to/hjson/file> \
    --csv <path/to/output/csv>

usage with a dir:
    ./util/py/scripts/testplan_decoder.py --dir <path/to/dir/with/hjson/files> \
    --csv <path/to/output/csv>
"""

import argparse
import glob
import json
import logging
import os
import re
import sys
from enum import Enum

import hjson
import pandas as pd
from gh_issues_manager import GithubWrapper
from mako.template import Template

parser = argparse.ArgumentParser()
parser.add_argument(
    "--logging",
    default="info",
    choices=["debug", "info", "warning", "error", "critical"],
    help="Logging level",
)

parser.add_argument(
    "--logging_file",
    default="",
    help="Logging to file rather than stdout",
)

parser.add_argument(
    "--testplan",
    required=False,
    default="hw/top_earlgrey/data/chip_testplan.hjson",
    help="Path of a single testplan hjson file."

)
parser.add_argument(
    "--config",
    required=False,
    default="~/.config/opentitan/testplan_manager_config.json",
    help="Path to the config.json.",
)

# Create subparsers for each subcommand
subparsers = parser.add_subparsers(
    title="subcommands", dest="command", help="subcommand help"
)

# Subparser for the 'export' command
export_parser = subparsers.add_parser(
    "export",
    help="Export the testplan in different formats [csv, google sheet, github issues] ",
)
export_parser.add_argument(
    "--csv",
    help="Path of the output csv file.",
)
export_parser.add_argument(
    "--bazel-suite",
    help="""Output the bazel test suite as an output""",
)

export_parser.add_argument(
    "--spreadsheet",
    action=argparse.BooleanOptionalAction,
    help="""Output the bazel test suite as an output""",
)

export_parser.add_argument(
    "--github",
    action=argparse.BooleanOptionalAction,
    help="""Generate github issues""",
)

export_parser.add_argument(
    "--dry-run",
    action="store_true",
    help="""Dry run for github issues""",
)

# Subparser for the 'update' command
update_parser = subparsers.add_parser(
    "update", help="Update the testplans based on a csv"
)
update_parser.add_argument(
    "--csv",
    required=True,
    help="Path of the input csv file.",
)


def main(args):
    print(args.testplan)

    testplan = hjson.load(open(args.testplan, "r"))

    df = dataframe_from_testplan(args.testplan)
    for file in testplan["import_testplans"]:
        df = pd.concat([df, dataframe_from_testplan(file)])


    if args.command == "export":
        return export_cmd(args, df)
    elif args.command == "update":
        return update_cmd(args)

    return -1


LICENSE_HEADER = """// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
"""


def update_cmd(args):
    files = [f for f in glob.glob(f"{args.top_level_dir}/*.hjson")]

    df = pd.read_csv(args.csv, keep_default_na=False).fillna("None")
    df.groupby("hw_ip_block").apply(lambda block: update_ip_block(files, block))


def update_ip_block(files, block_dataframe):
    ip_name = block_dataframe.iloc[0]["hw_ip_block"]

    filename = get_testplan_filename(ip_name, files)
    if filename:
        testplan = hjson.load(open(filename, "r"))
        updated = block_dataframe.apply(
            lambda row: update_testpoint(testplan, row), axis=1
        )
        if any(updated):  # Update if there was a change.
            logging.info("Updating %s", filename)
            with open(filename, "w") as f:
                f.write(LICENSE_HEADER)
                hjson.dump(testplan, f, indent=2, for_json=True)

    else:
        logging.info(f"{ip_name} not found")


def update_testpoint(testplan, row):
    updated = False
    for testpoint in testplan["testpoints"]:
        if row["name"] != testpoint["name"]:
            continue

        for field in "si_stage Priority".split():
            logging.debug(
                f"Checking { row['name']}.{field} --> {testpoint.get(field)} == {row[field]}"
            )
            if row[field] != testpoint.get(field):
                logging.info(f"Updating {row['name']} ->{field} to [{row[field]}]")
                testpoint[field] = row[field]
                updated = True
    return updated


def get_testplan_filename(ip_name, files):
    for file in files:
        if ip_name in file:
            return file
    return None

# For each cell containing a list transform it into a string.
def string_to_list(val):
    if isinstance(val, str) and "," in val:
        val = [item.strip() for item in val.split(",")]
    return val

class Indexer:
    def __init__(self, index):
        self.index = index

    def group(self, group):
        if group["index"].isna().any() == True:
            self.index += 1
            group["index"] = self.index
        return group

def export_cmd(args, df: pd.DataFrame):
    config = {}
    with open(os.path.expanduser(args.config), "r", encoding="utf-8") as f:
        config = json.load(f)

    output_generated = False
    if args.spreadsheet:
        columns = "hw_ip_block name si_stage bazel lc_states tags features otp_mutate tests".split()
        sheet_id = config["spreadsheet"]["id"]
        sheet_tab = config["spreadsheet"]["tab"]
        oauth = config["spreadsheet"]["oauth"]
        gs = GoogleSheet(sheet_id, sheet_tab, AuthType.CLIENT_ID, oauth)
        gs.connect()
        upstream = gs.load()
        upstream["index"] = upstream["index"].astype(int)

        # Reset index
        if False:
            df = upstream[["name"]].copy(deep=True).drop_duplicates().reset_index(drop=True)
            df["index"] = df.index
            
            upstream = pd.merge(upstream[columns], df, on=["name"], how='left')
            upstream = upstream[["index"] + columns].sort_values(by="index", ignore_index=True)

            gs.update(upstream, config["spreadsheet"]["origin"])
            exit(1)

        upstream = upstream[["name", "index"]].drop_duplicates()

        df_sheet = df.copy(deep=True)
        df_sheet = df_sheet[columns]
        
        df_sheet["bazel"] = df_sheet["bazel"].map(string_to_list)
        df_sheet = df_sheet.explode("bazel", ignore_index=True)

        df_sheet = pd.merge(df_sheet, upstream, on=["name"], how='left').drop_duplicates()
       
        indexer = Indexer(upstream["index"].max())
        df_sheet = df_sheet.groupby("name").apply(indexer.group).reset_index(drop=True)
        df_sheet = df_sheet[["index"] + columns].sort_values(by="index", ignore_index=True)

        gs.update(df_sheet, config["spreadsheet"]["origin"])

        output_generated = True
        print("Updated spreadsheet ", config["spreadsheet"]["id"])

    df = sort_columns(df)
    if args.github:
        create_issues(args, config["github"], df)
        output_generated = True
    if args.bazel_suite:
        export_bazel_suite(args, df)
        output_generated = True

    if args.csv:
        df_csv = insert_lc_states_columns(df.copy(deep=True))
        df_csv.to_csv(args.csv)
        output_generated = True
        print(f"File {args.csv} generated.")

    if not output_generated:
        print("No output specified.")
        
    return 0


SIVAL_SUITE_TEMPLATE = """
test_suite(
    name = "${test_suite_name}",
    tests = [
        % for test in test_list:
        "${test}",
        % endfor
    ],
)
"""

SIVAL_REGRESSION_SUITE_TEMPLATE = """
test_suite(
    name = "regression_test_suite",
    tests = [
        # Silicon validation test suites.
        % for suite in suites:
        ":${suite}",
        % endfor
        # Crypto test suites.
        "//sw/device/tests/crypto:cryptolib_test_suite",
    ],
)
"""


def export_bazel_suite(args, df: pd.DataFrame):
    import numpy as np
    from mako.template import Template

    regression_template = Template(SIVAL_REGRESSION_SUITE_TEMPLATE)
    sival_template = Template(SIVAL_SUITE_TEMPLATE)
    with open(args.bazel_suite, "w") as file:
        file.write(LICENSE_HEADER.replace("//", "#"))
        sv_stages = sorted(df["si_stage"].dropna().unique())
        print(f"Found stages in testplan: {sv_stages}")

        sv_tests_df = df[df["si_stage"].isin(sv_stages)]["bazel si_stage".split()]
       
       # Remove duplicates prioritizing lower sival stages.
        sv_tests_df.sort_values(by=["si_stage", "bazel"], inplace = True)
        sv_tests_df.drop_duplicates(subset="bazel", keep="first", inplace = True)

        test_suites = []
        for stage in sv_stages:
            # filter by Sival stage
            df_tests = sv_tests_df[sv_tests_df["si_stage"] == stage].sort_values("bazel")

            # Remove tests without implementation
            df_tests["bazel"].replace(" ", np.nan, inplace=True)
            df_tests["bazel"].replace("", np.nan, inplace=True)
            df_tests.dropna(subset=["bazel"], inplace=True)

            if len(df_tests["bazel"]) == 0:
                continue

            sv_tests = []
            for test in df_tests["bazel"]:
                sv_tests.extend(re.split(r"\s?,\s?", test))

            sv_tests = list(sorted(set(sv_tests)))

            # Render the test suite
            name = stage.lower() + "_tests"
            test_suite = sival_template.render(test_suite_name=name, test_list=sv_tests)
            file.write(test_suite)
            test_suites.append(name)

        test_suite = regression_template.render(suites=test_suites)
        file.write(test_suite)

    print(f"Generated {args.bazel_suite}.")
    return 0


def create_issues(args, config, df: pd.DataFrame):
    repo = hjson.load(open(config["issue_template"], "r"))["repository"]
    repo = GithubWrapper(config["token"], repo)
    repo.load_issues(labels=["Component:ChipLevelTest"])
    issue_template = Template(filename=config["issue_template"])

    _filter = (df["bazel"] == "") | (df["bazel"] == " ") | (df["bazel"].isnull())
    _filter &= df["si_stage"] != "NA"
    df = df[_filter]


    updated = created = 0
    for _, row in df.fillna("None").iterrows():
        priority = row.get("Priority", "P2")
        priority = "P2" if priority == "" else priority
        ip_block = re.sub("chip_", "", row["hw_ip_block"])
        new_issue = hjson.loads(
            issue_template.render(
                ip_block=ip_block,
                test_name=row["name"],
                stage=row["si_stage"],
                priority=priority,
            )
        )

        if repo.issue_exist(new_issue["title"]):
            logging.info("Issue already exists: %s", new_issue["title"])
            repo_issue = repo.issues_by_title(new_issue["title"])[0]
            if (
                repo_issue.body != new_issue["body"]
                or repo_issue.labels != new_issue["labels"]
                or repo_issue.milestone != new_issue["milestone"]
            ):
                logging.info("Updating the issue")
                if args.dry_run:
                    logging.info("Dry-run: Updating body: \r\n%s", new_issue["body"])
                else:
                    try:
                        repo_issue.edit(
                            body=new_issue["body"],
                            labels=new_issue["labels"],
                            milestone=new_issue["milestone"].upper(),
                        )
                    except Exception as e:
                        logging.info(
                            "Could not update the issue, debug level to see the error"
                        )
                        logging.debug("%s", e)
                updated += 1
                continue

        # Search for test created manually contained the test name.
        issues = (
            repo.search_issues("sival")
            + repo.search_issues("si-val")
            + repo.search_issues("chip-test")
        )
        if len(issues) > 0:
            filtered = list(
                filter(lambda ms: row["name"] in (str(ms.title) + str(ms.body)), issues)
            )
            if len(filtered) > 0:
                logging.info("Found issue with the test name: %s", filtered[0])
                if args.dry_run:
                    logging.info("Dry-run: editing %s", new_issue["title"])
                else:
                    try:
                        issues[0].edit(
                            body=new_issue["body"],
                            labels=new_issue["labels"],
                            milestone=new_issue["milestone"].upper(),
                        )
                    except Exception as e:
                        logging.info(
                            "Could not update the issue, debug level to see the error"
                        )
                        logging.debug("%s", e)

                updated += 1
                continue

        if args.dry_run:
            logging.info("Dry-run: creating issue: %s", new_issue["title"])
            logging.debug(
                "\r\n\rBody:\r\n%s\r\n\rLabels: %s\r\n\rMilestone: %s",
                new_issue["body"],
                new_issue["labels"],
                new_issue["milestone"],
            )
        else:
            logging.info("creating issue: %s", new_issue["title"])
            try:
                repo.create_issue(
                    title=new_issue["title"],
                    body=new_issue["body"],
                    labels=new_issue["labels"],
                    milestone=new_issue["milestone"].upper(),
                )
            except Exception as e:
                logging.info("Could not create the issue, debug level to see the error")
                logging.debug("%s", e)

        created += 1
    logging.info(
        "Created %d, Updated %d, Total %d", created, updated, created + updated
    )


class AuthType(Enum):
    # A service account is a special type of Google account intended to represent
    # a non-human user that needs to authenticate and be authorized to access data
    # in Google APIs [sic].
    SERVICE_ACCOUNT = 0
    # This is the case where your application or a script is accessing spreadsheets
    # on behalf of an end user. When you use this scenario, your application or a
    # script will ask the end user (or yourself if you’re running it) to grant access
    # to the user’s data.
    CLIENT_ID = 1


import warnings
import gspread
class GoogleSheet:
    def __init__(
        self, sheet_id: str, tab_name: str, auth_type: AuthType, credentials: str = ""
    ):
        self.sheet_id = sheet_id
        self.tab_name = tab_name

        self.credentials = credentials
        self.auth_type = auth_type

    def connect(self) :
        self.gc = (
            gspread.oauth(credentials_filename=self.credentials)
            if self.auth_type == AuthType.CLIENT_ID
            else gspread.service_account(filename=self.credentials)
        )

    def update(self, df: pd.DataFrame, origin="A1"):
        warnings.filterwarnings("ignore")
        spreadsheet = self.gc.open_by_key(self.sheet_id)
        try:
            sheet = spreadsheet.worksheet(self.tab_name)
        except gspread.exceptions.WorksheetNotFound:
            sheet = spreadsheet.add_worksheet(title=self.tab_name, rows=1000, cols=64)

        sheet.update(
            [df.columns.values.tolist()] + df.fillna("None").values.tolist(), origin
        )
    

    def load(self, origin="A1") -> pd.DataFrame:
        warnings.filterwarnings("ignore")

        spreadsheet = self.gc.open_by_key(self.sheet_id)
        try:
            sheet = spreadsheet.worksheet(self.tab_name)
        except gspread.exceptions.WorksheetNotFound:
            return pd.DataFrame()

        data = sheet.get_all_values()
        return pd.DataFrame(data[1:], columns=data[0])


def insert_lc_states_columns(df: pd.DataFrame) -> pd.DataFrame:
    lc_states = unique_list(df, "lc_states")
    logging.debug(f"lc_states: {lc_states}")
    df.loc[:, lc_states] = "No"

    def fill_lc_state_column(row):
        for state in lc_states:
            if isinstance(row["lc_states"], str) and state in row["lc_states"]:
                row[state] = "yes"
        return row

    return df.apply(lambda row: fill_lc_state_column(row), axis="columns")


def unique_list(df: pd.DataFrame, column: str, fillna: str = "NONE") -> list[str]:
    return list(
        set(" ".join(df[column].fillna(fillna).values).replace(",", " ").split())
    )


def sort_columns(df: pd.DataFrame) -> pd.DataFrame:
    column_order = []
    for (
        col
    ) in "hw_ip_block name Priority si_stage desc stage tests features bazel host_support otp_mutate lc_states tags".split():
        if col in df.columns:
            column_order.append(col)

    return df[column_order]



def dataframe_from_testplan(testplan_hjson: str) -> pd.DataFrame:
    testplan = hjson.load(open(testplan_hjson, "r"))

    tests = testplan["testpoints"]
    df = pd.DataFrame.from_dict(tests)

    # For each cell containing a list transform it into a string.
    def list_to_string(val):
        if isinstance(val, list):
            val = ", ".join(val)
        return val

    df = df.map(list_to_string)

    df["hw_ip_block"] = testplan.get("name", "Unknown")
    return df.fillna(" ")


if __name__ == "__main__":
    args = parser.parse_args()
    logging.basicConfig(level=args.logging.upper(), filename=args.logging_file)
    sys.exit(main(args))
