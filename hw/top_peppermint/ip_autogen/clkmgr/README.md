# Clock Manager HWIP Technical Specification
<!-- BEGIN CMDGEN util/mdbook_regression_links.py --hjson hw/top_peppermint/ip_autogen/clkmgr/data/clkmgr.hjson --top peppermint -->
| Regression | Version | [Stages](https://opentitan.org/book/doc/project_governance/development_stages.html) | Results |
|-|-|-|-|
 [`clkmgr`](https://dashboard.reports.lowrisc.org/opentitan/peppermint/dashboard.html) | 1.0.1 | D3, V2S | ![](https://dashboard.reports.lowrisc.org/opentitan/peppermint/badge/clkmgr/test.svg) ![](https://dashboard.reports.lowrisc.org/opentitan/peppermint/badge/clkmgr/passing.svg) ![](https://dashboard.reports.lowrisc.org/opentitan/peppermint/badge/clkmgr/functional.svg) ![](https://dashboard.reports.lowrisc.org/opentitan/peppermint/badge/clkmgr/code.svg) |

<!-- END CMDGEN -->

# Overview

This document specifies the functionality of the OpenTitan clock manager.

## Features

- Attribute based controls of OpenTitan clocks.
- Minimal software clock controls to reduce risks in clock manipulation.
- External clock switch support
- Clock frequency /time-out measurement
