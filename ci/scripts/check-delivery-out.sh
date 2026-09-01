#!/usr/bin/env bash
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Check the Peppermint release deliverables are up to date with the RTL.
#
# The deliverables must be regenerated in the same commit as the change that
# affects them, so that the log ties a change in `out/` to its cause.  Without
# this check that goes unnoticed: the generated files are large and nobody reads
# them in review, and the drift only surfaces at release time.
#
# This is also the check that catches the case a per-PR run cannot: one pull
# request changes the RTL without regenerating while another regenerates against
# the old RTL.  Both pass alone and the merged tree is stale.  The `gen`
# category runs in the merge queue, where the merged tree is what gets checked.
#
# Unlike ci/scripts/check-generated.sh this needs no OT_DESTRUCTIVE, because
# generate_out.sh writes only files it owns.  So it is safe to run by hand:
#
#     nix run .#lint -- gen
#
# It needs `bender` from that devShell, pinned to the version the deliverables
# were generated with; generate_out.sh stops early on anything else.  Nothing
# here reaches the network: every FuseSoC core resolves under `hw/`, and the
# Bender manifest carries no dependencies for bender to fetch.

set -e

REPO_TOP="$(git rev-parse --show-toplevel)"
cd "$REPO_TOP"

OUT_DIR=hw/top_peppermint/delivery/out
GENERATOR=hw/top_peppermint/delivery/scripts/generate_out.sh
BUILD_DIR=build/lowrisc_systems_top_peppermint_0.1

# A stale pickle differs by more lines than anyone will read, so show every
# file's summary but only the head of the diff itself.
MAX_DIFF_LINES=200

# util/fix_trailing_whitespace.py reads and writes without naming an encoding,
# and it runs while the pickle still holds the UTF-8 quotes from the vendored
# PULP sources.  Fix the locale so the result cannot depend on the caller's.
export LC_ALL=C.UTF-8

# FuseSoC overwrites the sources it copies but does not prune ones that have
# since been deleted, and the include directories in the manifest are whole
# directories. A leftover header could therefore still reach the pickle and
# make this check disagree between a fresh CI checkout and a local tree.
rm -rf "$BUILD_DIR"

if ! "$GENERATOR"; then
    echo >&2 "::error::Failed to regenerate ${OUT_DIR}. (command: '${GENERATOR}')"
    echo >&2 "This is a failure of the generation flow itself, not stale output."
    exit 1
fi

# Compare with the committed state, not with whatever the tree held when this
# started.  A before/after snapshot would read as "regeneration is a no-op for
# you" and so pass on a tree that was already stale -- which is the very drift
# this check exists to catch.  `git diff` alone would miss a file the flow
# newly creates, so use the directory's status, which covers untracked files
# too.  The intermediate pickle and the FuseSoC build tree are gitignored, so
# neither shows up here.
drift="$(git status --porcelain --untracked-files=all -- "$OUT_DIR")"
if [ -z "$drift" ]; then
    exit 0
fi

echo "The regenerated deliverables differ from the ones committed:"
echo "$drift"
echo
git diff --stat -- "$OUT_DIR"
echo

# Write the diff out first: piping straight into a truncating reader would kill
# `git` with SIGPIPE, which `set -o pipefail` would turn into an abort here if
# anyone ever adds it.
diff_file="$(mktemp)"
trap 'rm -f "$diff_file"' EXIT
git diff -- "$OUT_DIR" > "$diff_file"
total="$(grep -c '' "$diff_file")"
if [ "$total" -gt "$MAX_DIFF_LINES" ]; then
    echo "First ${MAX_DIFF_LINES} of ${total} diff lines:"
    sed -n "1,${MAX_DIFF_LINES}p" "$diff_file"
    echo
    echo "... truncated. Regenerate locally to see the rest."
else
    cat "$diff_file"
fi
echo

echo >&2 "::error::${OUT_DIR} is not up to date with the RTL."
echo >&2 "Regenerate it, in the same commit as the change that made it stale:"
echo >&2 "    ${GENERATOR}"
echo >&2 "The regenerated files have been left in the working tree, so"
echo >&2 "\`git add\` is usually all that is needed.  To discard them instead:"
echo >&2 "    git restore --source=HEAD --worktree -- ${OUT_DIR}"
exit 1
