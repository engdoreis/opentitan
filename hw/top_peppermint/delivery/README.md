# Peppermint M1 Delivery

## Reproducing the Flow

Prepare the bender source manifest with FuseSoC.
```sh
fusesoc --cores-root hw run --target=lint --setup lowrisc:systems:top_peppermint
python3 util/edalize_to_bender.py \
    build/lowrisc_systems_top_peppermint_0.1/lint-verilator/lowrisc_systems_top_peppermint_0.1.eda.yml
cd build/lowrisc_systems_top_peppermint_0.1/lint-verilator
```

FuseSoC copies the sources into this build directory, so re-run the two commands
above after every RTL change.

After changing into the build dir, run bender
```sh
bender pickle \
    -t rtl \
    -t generic \
    --prefix lowrisc_ \
    --expand-macros \
    -D SYNTHESIS \
    --top top_peppermint > ../../../hw/top_peppermint/delivery/lowrisc_peppermint_m1.sv
```


Then repair the package references that bender's renaming missed.
(Issue opened in bender repo: `pulp-platform/bender/issues/338`)
```sh
cd ../../../hw/top_peppermint/delivery
python3 scripts/fix_pickle_prefix.py lowrisc_peppermint_m1.sv
```

We first pickle, then finally split into the requested files.
```sh
mkdir -p out
python3 scripts/split_pickle.py lowrisc_peppermint_m1.sv
```

Lastly, normalise the generated files.  Without this they trip this repository's
whitespace and ASCII checks, and would show up as lint noise for the recipient.

Bender's macro expansion leaves trailing whitespace behind.  Note that the
script below deliberately exits non-zero when it changes a file, so guard it if
you ever run this from a script with `set -e`.
```sh
python3 ../../../util/fix_trailing_whitespace.py out/*.sv
```

The vendored PULP debug-module sources spell their Solderpad licence notice with
typographic quotes.  Those are exempt from the ASCII check only because they sit
under `vendor/`, an exemption the pickle does not inherit, so fold them to ASCII.
Keep this as two separate expressions: a bracket expression such as `[“”]` would
match the individual UTF-8 bytes under `LC_ALL=C` and corrupt the file.
```sh
sed -i -e 's/“/"/g' -e 's/”/"/g' out/*.sv
```

### Tool Versions
* `bender 0.32.1`


## Delivery

The deliverables land in `out/`.  See [`out/README.md`](out/README.md), which
ships with them, for what each file contains and the order they must be read
in.

As the final step, pack them into the archive that gets handed over.  Run this
from this directory.
```sh
tar -I 'zstd -19 -T0' \
    -cf lowrisc_top_peppermint_m1_rc0.tar.zst \
    --transform 's,^out,lowrisc_top_peppermint_m1_rc0,' \
    --owner=0 --group=0 --numeric-owner --sort=name \
    out
```

`--transform` renames `out/` to `lowrisc_top_peppermint_m1_rc0/` inside the
archive, so it unpacks into a directory named after the delivery.  The
remaining flags keep the archive reproducible and free of local uid/gid.
