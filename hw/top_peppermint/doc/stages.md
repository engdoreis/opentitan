# Peppermint design and verification stages

This page records the verification stage of the Peppermint top level, and the design and verification stages of every integrated IP.
Stage definitions are the standard OpenTitan ones, described in [Hardware Development Stages](../../../doc/project_governance/development_stages.md).
The per-item evidence behind a stage lives in each block's own checklist, linked from the tables below.

## Top level


| **Block** | **Design stage** | **Verification stage** | **Evidence** |
|---|---|---|---|
| `top_peppermint` | Not started | Not started | [checklist](checklist.md) |

> NOTE: This top-level row is manually maintained.

TODO: Defining a top-level design sign-off list for Peppermint is tracked by [issue #27](https://github.com/lowRISC/opentitan-embargoed-peppermint/issues/27).
Design stages are tracked per IP in the table below, and the verification stage comes from the [top-level sign-off definitions](signoff.md).

## Integrated IPs

The table below is generated from the resolved top definition: `hw/top_peppermint/data/autogen/top_peppermint.gen.hjson`.
Each stage is read from that block's own description, and the checklist link points at the evidence.

The "origin" column says where the block comes from.
A common block lives in `hw/ip`, is integrated unchanged, and keeps whatever stage it has upstream.
A top specific block lives under `hw/top_peppermint/ip_autogen` or `hw/top_peppermint/ip`, so the instance is configured for Peppermint.

A cell reading `not in <block>.hjson` means the description never carried the field.
Which mean that this block description file must add the field, and this field should reflect the actual maturity level.

A cell reading `checklist not in the book` means the checklist file is in the tree but no page is built from it, so there is nothing to link to.
This is where the Peppermint blocks generated from `ip_autogen` stand: their checklists exist next to the block, but `SUMMARY.md` does not list the Peppermint IP documentation, so none of it is published.
Publishing it is a separate piece of work from this table.

{{#ipstages top_peppermint }}

**Notes:**
  - The crossbars appear as a single `xbar` row.
    They are generated per top from the connection map and carry no description of their own, so there is no stage to read.
  - TL-UL is tracked centrally in `hw/ip/tlul/data/tlul.prj.hjson`, and that entry is scoped to the Earlgrey crossbar instances, so it is not inherited here.

## How this page is maintained

The IP table is rendered by the `ipstages` book preprocessor, `util/mdbook_ip_stages.py`, from the resolved top definition.
An IP added to or removed from the top appears or disappears without this page being edited, and a stage changed upstream is picked up on the next build.

To preview the table without building the book:

```sh
./util/mdbook_ip_stages.py --preview top_peppermint
```
