#!/usr/bin/env bash
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Regenerates the deliverables in `out/` from the current RTL.  Run it after
# every RTL change, so that `out/` keeps matching the RTL in the tree.  The
# "Reproducing the Flow" section of README.md gives the overview; the comments
# below give the reason for each step.
#
# The release identifier stamped into the generated files defaults to the one
# `out/` already carries, because `scripts/create_release.py` restamps every
# file at release time.  Pass --release to set a different one.
#
# Requires `fusesoc`, `bender` and `python3` on PATH.  See the Tool Versions
# section of README.md for the versions this flow was developed against.

set -euo pipefail

usage() {
    cat <<'USAGE'
Usage: generate_out.sh [--release <identifier>] [--keep-pickle]

  --release <identifier>  Release identifier to stamp into the generated files,
                          e.g. Peppermint-1.0-M1-RC4.  Defaults to the
                          identifier currently stamped into out/.
  --keep-pickle           Keep the intermediate lowrisc_peppermint.sv instead of
                          deleting it.
  -h, --help              Show this help.
USAGE
}

release=""
keep_pickle=0
while [ $# -gt 0 ]; do
    case "$1" in
        --release)
            [ $# -ge 2 ] || { echo "error: --release needs an argument" >&2; exit 1; }
            release="$2"
            shift 2
            ;;
        --keep-pickle)
            keep_pickle=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "error: unknown argument '$1'" >&2
            usage >&2
            exit 1
            ;;
    esac
done

repo_top="$(git rev-parse --show-toplevel)"
delivery_dir="${repo_top}/hw/top_peppermint/delivery"
build_dir="${repo_top}/build/lowrisc_systems_top_peppermint_0.1/lint-verilator"
pickle="${delivery_dir}/lowrisc_peppermint.sv"

# The files `split_pickle.py` writes.  The normalisation below is spelled out
# per file rather than as `out/*.sv`, because that glob would also rewrite
# `out/lowrisc_top_peppermint_wrapper.sv`, which is maintained by hand.
generated_sv=(
    lowrisc_peppermint_rtl.sv
    lowrisc_prim_generic.sv
    lowrisc_top_packages.sv
)

for tool in fusesoc bender python3; do
    command -v "${tool}" >/dev/null 2>&1 || {
        echo "error: ${tool} not found on PATH" >&2
        exit 1
    }
done

# The pickle depends on the bender version byte for byte, so a mismatch would
# rewrite the whole deliverable and look like an RTL change.  The version the
# flake pins is the one the committed deliverables were generated with; keep
# this, `flake.nix` and the Tool Versions section of README.md in step.
bender_want=0.32.1
bender_have="$(bender --version | awk '{print $2}')"
[ "${bender_have}" = "${bender_want}" ] || {
    echo "error: found bender ${bender_have}, need ${bender_want}" >&2
    echo "Run this inside the flake devshell, which pins it:" >&2
    echo "    nix run .#eda -- ${0}" >&2
    exit 1
}

# Take the release identifier from the files in out/ unless one was given, so
# that a regeneration between releases does not change the stamp.
if [ -z "${release}" ]; then
    release="$(sed -n 's|^// Release \(.*\)\.$|\1|p' \
        "${delivery_dir}/out/lowrisc_peppermint_rtl.sv" 2>/dev/null \
        | head -n 1 || true)"
    [ -n "${release}" ] || {
        echo "error: could not read the release identifier from out/;" \
             "pass --release" >&2
        exit 1
    }
    echo "Reusing the release identifier already stamped into out/: ${release}"
fi

# Prepare the bender source manifest with FuseSoC.  FuseSoC copies the sources
# into the build directory, so this has to run after every RTL change.
cd "${repo_top}"
fusesoc --cores-root hw run --target=lint --setup lowrisc:systems:top_peppermint
python3 util/edalize_to_bender.py \
    "${build_dir}/lowrisc_systems_top_peppermint_0.1.eda.yml"

# Pickle the design into a single file.
cd "${build_dir}"
bender pickle \
    -t rtl \
    -t generic \
    --prefix lowrisc_ \
    --expand-macros \
    -D SYNTHESIS \
    --top top_peppermint > "${pickle}"

# Repair the package references that bender's renaming missed.
# (Issue opened in bender repo: `pulp-platform/bender/issues/338`)
cd "${delivery_dir}"
python3 scripts/fix_pickle_prefix.py lowrisc_peppermint.sv

# Split the pickle into the requested files.
mkdir -p out
python3 scripts/split_pickle.py --release "${release}" lowrisc_peppermint.sv

# Normalise the generated files.  Without this they trip this repository's
# whitespace and ASCII checks, and would show up as lint noise for the
# recipient.
#
# Bender's macro expansion leaves trailing whitespace behind.
# fix_trailing_whitespace.py resolves its arguments against the repository root
# and then opens them relative to the working directory, so it only works when
# run from the root.  It also exits non-zero when it changes a file, which is
# not an error here.
cd "${repo_top}"
set +e
python3 util/fix_trailing_whitespace.py \
    "${generated_sv[@]/#/hw/top_peppermint/delivery/out/}"
whitespace_status=$?
set -e
[ "${whitespace_status}" -le 1 ] || {
    echo "error: fix_trailing_whitespace.py failed with ${whitespace_status}" >&2
    exit "${whitespace_status}"
}
cd "${delivery_dir}"

# Some vendored sources use typographic punctuation in their comments: the PULP
# debug module in its Solderpad licence notice, the CHERIoT Ibex in its register
# file commentary.  Those files are exempt from this repository's ASCII check
# only because they sit under `vendor/`, an exemption the pickle does not
# inherit, so fold the characters to ASCII.  They are spelled as UTF-8 byte
# sequences because this script is itself subject to that check.  Keep one
# expression per character: a bracket expression matching several would match
# the individual UTF-8 bytes under `LC_ALL=C` and corrupt the file.
ascii_folds=()
fold() {  # <utf-8 bytes of the character> <ASCII spelling>
    ascii_folds+=(-e "s/$(printf '%b' "$1")/$2/g")
}
fold '\xe2\x80\x98' "'"     # U+2018 LEFT SINGLE QUOTATION MARK
fold '\xe2\x80\x99' "'"     # U+2019 RIGHT SINGLE QUOTATION MARK
fold '\xe2\x80\x9c' '"'     # U+201C LEFT DOUBLE QUOTATION MARK
fold '\xe2\x80\x9d' '"'     # U+201D RIGHT DOUBLE QUOTATION MARK
fold '\xe2\x80\x93' '-'     # U+2013 EN DASH
fold '\xe2\x80\x94' '--'    # U+2014 EM DASH
fold '\xe2\x86\x92' '->'    # U+2192 RIGHTWARDS ARROW
sed -i "${ascii_folds[@]}" "${generated_sv[@]/#/out/}"

# Any character not in that list would reach the recipient and trip this
# repository's ASCII check, so say which one rather than leave the lint to find
# it.  A vendor update can introduce one at any time.  The detection matches
# ci/scripts/check-ascii.sh.
remaining="$(env LC_ALL=C grep -n -d skip -P '[^\0-\x7f]' \
    "${generated_sv[@]/#/out/}" || true)"
[ -z "${remaining}" ] || {
    echo "error: non-ASCII characters left in the generated files:" >&2
    echo "${remaining}" >&2
    echo "Add each one to the fold list in ${0}." >&2
    exit 1
}

# Copy the memory macro descriptions, appending the release identifier to
# the title.  The deliverable copies carry that identifier the way
# `split_pickle.py` stamps the pickled files: `create_release.py` rewrites the
# stamp in every file of `out/` at release time and aborts on a file that
# carries none.
sed -e "s|^\\(title = \".*\\)\"|\\1 (Release ${release})\"|" \
    ../doc/memories.toml > out/memories.toml

# Regenerate the table from the TOML rather than copying `../doc/memories.md`,
# so that a stale copy there cannot reach the deliverable.  The heading, and
# with it the release stamp, comes from the TOML's title.
"${repo_top}/util/memory_macro_to_md.py" out/memories.toml

if [ "${keep_pickle}" -eq 0 ]; then
    rm -f "${pickle}"
fi

echo "Regenerated ${delivery_dir}/out for release ${release}."
