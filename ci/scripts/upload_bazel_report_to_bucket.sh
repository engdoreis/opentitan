#!/usr/bin/env bash
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

set -e

if [ $# == 0 ]; then
    echo >&2 "Usage: $0 <bucket>"
    exit 1
fi

branch=$(git branch --show-current)
job_name=${2:="fpga_cw310_sival"}
bucket="gs://$1/job/$job_name/branch/${branch}/$(date +%Y-%m-%d-%H%M%S)_test_results.xml"
merged_results="merged_report.xml"

if ! which merge-junit -v >/dev/null 2>&1; then
  echo "Downloading merge-junit"
  MERGE_JUNIT_PATH="/tools/merge-junit"
  MERGE_JUNIT_TAR="merge-junit-v0.2.1-x86_64-unknown-linux-musl.tar.gz"
  MERGE_JUNIT_URL="https://github.com/tobni/merge-junit/releases/download/v0.2.1/${MERGE_JUNIT_TAR}"
  MERGE_JUNIT_SHA256="5c6a63063f3a155ea4da912d5cae2ec4a89022df31d7942f2aba463ee4790152"

  curl -fLSs -o "/tmp/${MERGE_JUNIT_TAR}" "$MERGE_JUNIT_URL"
  HASH=$(sha256sum "/tmp/$MERGE_JUNIT_TAR" | awk '{print $1}')
  if [[ "$HASH" != "$MERGE_JUNIT_SHA256" ]]; then
    echo "The hash of merge-junit does not match" >&2
    echo "$HASH != $MERGE_JUNIT_SHA256" >&2
    exit 1
  fi

  sudo mkdir -p $MERGE_JUNIT_PATH
  sudo chmod 777 $MERGE_JUNIT_PATH
  tar -C $MERGE_JUNIT_PATH -xvzf "/tmp/${MERGE_JUNIT_TAR}" --strip-components=1
  PATH=$PATH:$MERGE_JUNIT_PATH
  rm "/tmp/${MERGE_JUNIT_TAR}"
fi

echo "Merging junit reports"
report_list="$(mktemp)"
if find -L bazel-out -wholename "*$job_name/test.xml" | grep -F '' >> $report_list; then
  cat $report_list | xargs merge-junit --force -o $merged_results
else
  echo No Results to upload
  exit 0
fi

echo "Adding host name"
host=$(hostname)
user=$(whoami)
os_name=$(grep ^NAME= /etc/os-release | cut -d= -f2 | tr -d '"')
os_version=$(grep ^VERSION= /etc/os-release | cut -d= -f2 | tr -d '"')
xmlstarlet ed --inplace -i '/testsuites/testsuite' -t attr -n hostname -v "$user-$host-$os_name-$os_version" "${merged_results}"

echo "Uploading to bucket $bucket"
gcloud storage cp "${merged_results}" "${bucket}" 
