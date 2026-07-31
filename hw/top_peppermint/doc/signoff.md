# Peppermint top-level verification stages and sign-off

## Purpose

This defines the verification stages and the sign-off checklists for the Peppermint top-level testbench.
Block-level stages are out of scope here: inherited OpenTitan IPs keep their upstream stages, and the customised `clkmgr`, `rstmgr` and `pwrmgr` follow the standard OpenTitan block checklists.
Throughout this document, "the integrator" means the party instantiating Peppermint inside a host SoC.

## Governing documents

The checklists below name what must be demonstrated at each stage.
The testplan and the Verification Plan (vPlan) derive from this checklist.
The testplan carries the testpoints and their descriptions, and the vPlan carries the coverage items to cover.
Detail such as exact signals, stimulus and coverage objects are specified in those two files.

- Testplan: `hw/top_peppermint/data/chip_testplan.hjson`.
  It captures testpoints, each with a description, the verification stage it belongs to, and the tests that implement it.
  DVSim maps regression results onto those testpoints and derives the per-stage regressions, so the V1 and V2 gates below can be read off a regression report.
- Verification plan (vPlan): `hw/top_peppermint/data/chip_vplan.hjson`.
  It bridges from the specification to the verification results, with each item naming its evidence and the stage it belongs to.
  Evidence can be a mixture of code coverage, functional coverage, assertions, formal proofs or manual inspection.
  DVPlan back-annotates the matching results into the vPlan automatically, so per-stage coverage is a clear report rather than a manual count.

Each stage has its own testplan items and vPlan items: the testplan says what to run, the vPlan says which part of the specification is covered.
Both must stay consistent as the project progresses.
The authoring order is this sign-off list first, then the testplan against it, then the vPlan.

## Standing constraints

These apply to every top-level stage.

### IP floor

Every integrated IP must be at or above the verification stage being signed at top level.
Inherited OpenTitan IPs are recorded at their upstream V-stage, cited per IP, and are held to the same floor.
The instances topgen generates for this top keep the stage in their own description file, so the question is what changed for Peppermint since that stage was signed.
`alert_handler`, `clkmgr`, `rstmgr` and `pwrmgr` need close attention, and the three managers must re-close at V1 for the Peppermint two-domain parametrisation.
`rv_core_ibex`, `otp_ctrl` and the crossbars have changes to assess, and some Peppermint-specific work is expected of them.
The exception is `otp_macro` behind `otp_ctrl`, which needs a technology-specific implementation.
Blocks below the floor need a written waiver signed by relevant stakeholders.
Three blocks sit below the floor by construction, because they have no block-level verification anywhere: `rv_core_ibex`, `otp_macro` and `ahb_bridge`.
`rv_plic` is verified formally, so top level is still the only place its registers see a testbench.
Each waiver names the top-level coverage that stands in for a block environment.

### Modelling the SoC boundary

The SoC is outside of Peppermint DV scope, so every SoC-facing port must be driven or observed by one model or UVM agent.
The authoritative port list is defined in this file `hw/top_peppermint/delivery/out/interfaces.md`.
The life-cycle ports are outputs, so a checker observes them against the current life-cycle state.
A tied-off port counts as unexercised and needs a documented justification.

DFT verification itself is out of scope, because scan insertion happens after delivery: the integrator owns it and countersigns under `TOP_INTEGRATOR_HANDOFF`.
What stays in scope is the life-cycle mechanism that disables DFT, including the `scanmode_i`, `scan_en_i` and `scan_rst_ni` inputs, covered by `TOP_LC_DEBUG_LOCKDOWN_V1`.

### Power-domain claims are functional only

The SoC owns the power switches, so simulation asserts the main-domain resets and stops its clocks with no rail removed and no state lost.
The sign-off covers the power-handshake FSM and its ordering, the AON to main crossings, and retention as a functional flow.
Off-state isolation needs the power intent, a Unified Power Format (UPF) description and a power-aware gate-level run, so the integrator owns it and countersigns under `TOP_INTEGRATOR_HANDOFF`.

### Software-directed checking

Software-directed tests are the primary checking mechanism at top level, and the UVM environment is kept light.
Independent observation by scoreboard, protocol checker or assertion is mandatory only where firmware cannot see the effect: the SoC-facing boundary, the power handshake and reset sequencing, and any behaviour while the main domain is powered off.

## What top-level tests cover

These are the integration paths that no block-level testbench can observe.
Peppermint sits inside a host SoC, so its boundary is an on-chip interface, not a pad ring.

- Every SoC-facing port listed under [the SoC boundary constraint](#modelling-the-soc-boundary).
- Interrupts in both directions:
    - Inbound: each IP interrupt goes through the PLIC to an Ibex trap, and the SoC-driven `incoming_interrupt_soc_i` lines take the same path.
    - Outbound: the mailbox DOE interrupts have to reach the boundary.
- Alerts, inbound only, over `incoming_alert_soc_tx_i` and `incoming_alert_soc_rx_o`.
  Block-level DV covers the alert handler itself, so top level owns alert and ping handling while the main domain is off, including the `incoming_lpg_cg_en_soc_i` and `incoming_lpg_rst_en_soc_i` inputs that flag SoC senders unable to answer a ping.
  NOTE: How much of that is closable depends on the alert handler power split, tracked by [issue #29](https://github.com/lowRISC/opentitan-embargoed-peppermint/issues/29).
- Cross-IP data paths:
  `rom_ctrl` uses the KMAC application interface at boot, `keymgr_dpe` drives KMAC, the entropy flows from `entropy_src` through `csrng` and `edn` to its consumers, alert escalation lands in `rstmgr`, and mailbox and DMA traffic reaches the SRAMs.
- Clock, reset and power across the two domains: handshake ordering, the AON to main crossings, `rst_soc_cpu_no` surviving a main-domain power-off, the `reset_info` register, retention save and restore, and wake-up from `wakeup_main_i`.
- Boot:
  ROM runs on Ibex and passes its integrity check.
  ROM_EXT is then fetched from off-chip non-volatile memory through its SoC-side controller, over the AHB egress into the main SRAM, and authenticated.
  If authentication fails, ROM moves to the other slot or to the recovery image, both held in the non-volatile memory models.
- SoC CPU release, Peppermint's primary function: `rst_soc_cpu_no` released with a valid `soc_cpu_boot_addr_o` once ROM_EXT authenticates.
  The reset-holding case is security-critical and covered too: no release when authentication fails, and none when the image version is below the OTP minimum.
- CPU integration: Ibex in dual lockstep wired into the memory subsystem, the interrupt infrastructure and the debug module, with DMI access behaving as specified.
- Life-cycle and debug policy export:
  Each function-control signal must gate both the internal consumer and the SoC-facing port.
- Memory egress and ingress: mailbox and DMA traffic crossing between the SoC and the Peppermint memories, including AHB error responses and backpressure.
  These are two of the paths by which an untrusted SoC reaches Peppermint memory; the rest of the trust boundary runs through the other SoC-facing ports.
- OTP-driven boot decisions:
  ROM behaviour follows the OTP contents backdoored into each test.
  Two fields matter at top level: the Secure Boot bypass field, where only the sanctioned encodings bypass and anything else falls back to normal Secure Boot, and the anti-rollback strike counters, where an image version below the recorded minimum is rejected.
  TODO: add details about the secure boot bypass feature and related items in the checklist (issue [#53](https://github.com/lowRISC/opentitan-embargoed-peppermint/issues/53))

## What top-level tests do not cover

- IP-internal behaviour: CSR semantics, bit-bash, protocol compliance, intra-IP error injection, IP functional coverage.
  These are verified at block level, and closed upstream for the inherited IPs.
  The exception is the blocks with no block-level DV environment listed under [the IP floor](#ip-floor).
  Top level is the only place their registers and their interrupt behaviour are ever exercised, so `TOP_ADDRESS_MAP_SWEEP`, `TOP_BIT_BASH_NO_BLOCK_DV` and `TOP_INTERRUPT_BEYOND_ROUTING` reach into them.
- The SoC firmware that orchestrates secure boot, firmware update, recovery and anti-rollback end to end, and the SoC interconnect it runs over.
  The decisions Peppermint makes inside those flows are covered above.
- Physical low-power sign-off: isolation, level-shifter and retention cells, power-switch sequencing, power-aware gate-level simulation.
  Also owned by the integrator.
- Crypto correctness.
  Verified at IP level; only the service integration path is covered at top level.
- SoC-specific ROM_EXT verification, which top-level DV supports but does not own.
- Static CDC and RDC analysis.
  Top-level DV depends on them being clean and exercises the crossings functionally instead, under `TOP_CROSSING_DELAY_INJECTION`.

If a test can pass or fail purely on IP-internal behaviour, with no observable effect at top level, it does not belong here.

## Stage definitions

| **Stage** | **Name** | **Definition** |
|-----------|----------|----------------|
| V0 | Initial Work | <ul> <li> Testbench being set up </li> <li> Testplan carrying the V1 and V2 testpoints </li> <li> vPlan structure created </li> <li> DV document being drafted, capturing the verification strategy </li> <li> Internal register access proven with the CPU stubbed out </li> </ul> |
| V1 | Smoke Passing | <ul> <li> All V1 testpoints passing, mostly smoke tests </li> <li> Testbench infrastructure validated, including the software to DV signalling </li> <li> Every boundary port connected to an active model and exercised by at least one passing test </li> <li> Interrupt routing confirmed for all interrupt-capable IPs </li> <li> SoC CPU release proven in both directions </li> <li> Power-on reset bringing both domains up, the main domain turned off, and turned back on for both wake sources </li> <li> Life-cycle function-control fan-out connectivity confirmed </li> <li> Primary read and write paths over the DMI and over AHB in both directions </li> <li> Power-handshake ordering assertions enabled </li> <li> Smoke regression running in CI </li> </ul> |
| V2 | Integration Complete | <ul> <li> All V1 and V2 testpoints passing </li> <li> Address map swept through the RAL, and register semantics checked for the blocks with no testbench of their own </li> <li> PLIC behaviour beyond routing exercised, since `rv_plic` has no simulation environment </li> <li> Cross-IP paths, reset paths and the remaining power-cycle flows exercised </li> <li> AON to main crossings exercised with randomised crossing delay </li> <li> Negative and corner-case testing complete on the memory egress and ingress paths, the DMI and the life-cycle fan-out </li> <li> Coverage targets met with justified exclusions </li> </ul> |
| V3 | Verification Complete | Not in scope for now, see below. |

V1 is the sign-off bar for now, and V2 is a stretch goal that must not be used to gate it.
V0 exit is the connectivity shell defined by the V0 checklist below.

## Smoke test expectations

A top-level smoke test covers one IP at a time and must show two things.

1. Register reachability: software writes and reads at least one CSR, confirming the address-map wiring through the crossbar.
2. One integration-unique functional path: a single transaction over a path that only exists at top level.

A few caveats:

- The software to DV pass/fail and logging window must work before any firmware-driven result is trusted.
- Many IPs have no port leaving Peppermint at all, the crypto blocks and the SRAM controllers among them.
  For those, the integration-unique path is an internal one that does not exist in the block environment, such as an interrupt reaching Ibex through the PLIC, an alert reaching the alert handler, or entropy arriving from `edn`.
- Every per-IP smoke test runs in the simple state, with both power domains on.
  Powering the main domain down and waking from sleep are covered by their own testpoints rather than being folded into each smoke test.

Smoke tests must be short and deterministic.
A smoke failure caused by an IP-internal bug rather than a wiring or routing bug means the IP has not reached its own V1, and it should not block top-level V1.

## Smoke regression and CI shape

The V1 smoke regression is most of the V1 gate: the per-IP smoke tests, plus the cross-cutting checks that belong to no single IP.
`TOP_ALL_TESTS_PASSING_V1` gates on every V1 testpoint though, and some of those are too long or too stateful for a smoke suite, the per-state lockdown tests and the power-cycle flows in particular.

Interrupt routing is one consolidated test that forces every source through its `INTR_TEST` register and confirms delivery to the CPU, rather than being repeated inside each per-IP smoke.
The other cross-cutting checks are a power up and down cycle with the ordering assertions active, a lockdown check in one production life-cycle state as defined by `TOP_LC_DEBUG_LOCKDOWN_V1`, the SoC CPU release in both directions, and the life-cycle fan-out connectivity pass.

CI runs lint, elaboration and the smoke suite on every pull request, with the smoke suite gating the merge, and the full suite weekly.

## V0 exit checklist

| **Item name** | **Description** |
|---------------|-----------------|
| TOP_TB_ELABORATES | The testbench elaborates against the generated `top_peppermint`, with both clocks and power-on reset driven. |
| TOP_STUB_CPU_CSR_ACCESS | With the CPU stubbed out, a CSR read and write (where possible) reaches every IP with a register interface, in both power domains, through the crossbar. Every IP left out is listed with a reason. In stub-CPU mode the testbench drives TL directly, so no firmware is needed (but a ROM image is as `rom_ctrl` gates `pwrmgr`). |
| TOP_MEM_BACKDOOR_ACCESS | Backdoor access to the ROM, the SRAMs and the OTP resolves and reads back what it wrote. |
| TOP_TESTPLAN_DRAFTED | The testplan exists and already carries the V1 and V2 testpoints. Review of its content comes at V1. |
| TOP_VPLAN_CREATED | The vPlan exists with its section structure in place. No coverage content is required at this stage. |
| TOP_CI_LINT_ELAB | Lint and elaboration of the DV tree run in CI. |

## V1 sign-off checklist

| **Item name** | **Description** |
|---------------|-----------------|
| TOP_DV_DOC_DRAFTED | DV document drafted: testbench architecture, agent topology, how firmware on Ibex provides the stimulus and how sequences coordinate with it, coverage intent, and where the SoC modelling boundary sits. |
| TOP_VPLAN_REVIEWED | vPlan substantively complete: every V1 metric item names its evidence and metric type, and carries a `Milestone`. Later-stage items may stay placeholders, so that work is not pulled into the V1 gate. Reviewed across DV, design and software. It is still expected to evolve as the specifications mature. |
| TOP_TESTPLAN_REVIEWED | Testplan substantively complete: at least one testpoint per integrated IP, plus the novel-interface testpoints (power handshake, AHB in both roles, life-cycle and debug export, DMI, noise source, retention, SoC CPU release). V2 testpoints may stay one-line placeholders. Reviewed across DV, design and software. NOTE: The noise source testpoint names the bit rate `entropy_src` has to sustain on `clk_main_i` and covers the `es_rng_enable_o`, `es_rng_valid_i` and `es_rng_fips_o` handshake, since the block environment models its own source and it carries the FIPS/CC dependency. |
| TOP_TB_COMPLETED | The DUT is instantiated with every interface connected to something that can drive or observe it. Tie-offs are permitted only for architecturally unused ports, each with a written justification, and exceptions need a waiver signed by the relevant stakeholders. |
| TOP_SOC_MODELS_IN_PLACE | Every port in the list named under [the SoC boundary constraint](#modelling-the-soc-boundary) is driven or observed by a model or agent, and exercised by at least one passing test, with tie-offs only as that constraint permits. The generic models in the open tree satisfy this item; SoC-specific models substitute for them behind the same interfaces. |
| TOP_SWDV_SIGNALLING | The software to DV log and status interfaces are confirmed working. They are the windows firmware uses to report progress and a pass or fail verdict to the testbench. |
| TOP_POWER_SVA_ENABLED | The power-handshake ordering assertions are bound and enabled in every test, not only the power tests. TODO: The rules are deferred until the power handshake specification is confirmed, tracked by [issue #30](https://github.com/lowRISC/opentitan-embargoed-peppermint/issues/30). One holds regardless: `rst_soc_cpu_no` is unaffected by a main-domain power-off. |
| TOP_ASSERT_KNOWN_BOUNDARY | Assert-known checks on every SoC-facing output, bound at the boundary so they carry into gate-level runs, and holding while the main domain is powered off. |
| TOP_LC_DEBUG_LOCKDOWN_V1 | Security item, and not waivable. In production life-cycle states, debug and test capability must be demonstrably unavailable: `DFT_EN`, `HW_DEBUG_EN` and `NVM_DEBUG_EN` deasserted, DMI access to the debug module refused, and all four of `soc_lc_dft_en_o`, `soc_lc_nvm_debug_en_o`, `soc_lc_hw_debug_en_o` and `soc_lc_cpu_en_o` driven to their off value. An SoC asserting `scanmode_i` must achieve nothing either. V1 also needs a minimum of the positive direction: in a state that allows it, the DMI reaches `rv_dm` and `scanmode_i` takes effect. The remaining states are `TOP_LC_DEBUG_LOCKDOWN_FULL`. |
| TOP_LC_FANOUT_V1 | Each life-cycle function-control signal reaches its intended internal consumer and its SoC-facing port. The exhaustive pass, including that each signal reaches nothing else, is `TOP_CONNECTIVITY_CHECKED` at V2. |
| TOP_SOC_CPU_RELEASE | Security item, and not waivable. `rst_soc_cpu_no` is released with a valid `soc_cpu_boot_addr_o` after ROM_EXT authentication succeeds, and the reset-holding case is covered too: no release when authentication fails, and none when the image version is below the minimum recorded in OTP. |
| TOP_POWER_CYCLE_V1 | Power-on reset brings both domains up, the main domain is then turned off and turned back on again, once for an internal wake-up and once for an external one over `wakeup_main_i`. Retention corner cases and the remaining reset causes are `TOP_POWER_CYCLE_FLOWS` and `TOP_RESET_PATHS` at V2. |
| TOP_DMI_ACCESS_V1 | Read and write over the TL-UL-based DMI reach both targets behind it, `rv_dm` and the `lc_ctrl` CSRs, and `lc_ctrl` stays reachable in every life-cycle state because that is the provisioning and recovery path. Both targets check command and data integrity, so the DMI agent has to generate it. |
| TOP_AHB_ACCESS_V1 | Read and write over AHB in both directions: the manager port `soc_mgr_ahb_req_o` reaching the SoC memory model, and the subordinate port `soc_mbx_ahb_req_i` reaching both mailboxes. Wait-state backpressure and simple error responses are included. Illegal accesses and malformed requests are `TOP_MEMORY_PATHS_NEGATIVE` at V2. |
| TOP_INTERRUPT_ROUTING | Machine-mode delivery to Ibex confirmed for every interrupt-capable IP by the consolidated routing test, including the SoC-driven `incoming_interrupt_soc_i` lines, and the mailbox DOE interrupts observed at the boundary. |
| TOP_KNOWN_BUGS_TRIAGED_V1 | All known bugs triaged; all must-fix bugs fixed. |
| TOP_ALL_TESTS_PASSING_V1 | All V1 testpoints in the testplan passing. |
| TOP_VPLAN_COVERAGE_V1 | All vPlan items tagged V1 achieved. |
| TOP_IP_FLOOR_RECORDED | The integrated IPs are enumerated on the stages page with their stages and a link to each checklist, alongside the top-level stage. Every IP is at or above [the IP floor](#ip-floor), and any exception carries a waiver. |
| TOP_SMOKE_REGRESSION_IN_CI | The V1 smoke suite runs in CI on every pull request and gates it. |
| TOP_WEEKLY_REGRESSION | The full suite runs weekly on the primary simulator. |
| TOP_SECOND_SIMULATOR_SMOKE | The smoke suite also builds and passes on a second simulator at least weekly. |
| TOP_INTEGRATOR_HANDOFF | The claims delegated to the integrator are recorded and countersigned by the party that owns them, with a link to the artefact in which they committed: integrating Peppermint into the host SoC and testing it, running gate-level simulation, and running the power-aware simulation that covers off-state isolation. V1 records the commitment; the evidence itself is `TOP_INTEGRATOR_EVIDENCE` at V2. |
| TOP_GLS_TB_CONSTRAINTS | The testbench is built so a gate-level run stays possible: hierarchical paths centralised in one overridable header, backdoor memory access taking its path from that header, deterministic reset and initialisation so netlist X clears, and no checking that depends on internal state a netlist does not carry. |

## V2 sign-off checklist (stretch goal)

Nothing in this list gates the first objective, and it may be refined from V1 experience.

| **Item name** | **Description** |
|---------------|-----------------|
| TOP_DV_DOC_COMPLETED | DV document fully written, including agent topology and the checking strategy. |
| TOP_VPLAN_COMPLETED | vPlan finalised: planned coverage items complete, V1 execution gaps closed, specification changes folded in. |
| TOP_TESTPLAN_COMPLETED | Testplan finalised on the same terms. |
| TOP_ADDRESS_MAP_SWEEP | An aliasing pass confirms that writing one register moves no other, and CSR access is exercised over the DMI path as well as from the CPU side. Registers of the blocks with no testbench of their own are included (`rv_plic`, `rv_core_ibex`, `otp_macro` and `ahb_bridge`). Exclusions are expected for registers that cannot be safely written at top level, and each one is documented. |
| TOP_DMI_INTEGRITY_NEGATIVE | Bad command and data integrity on the DMI is rejected. This is an SoC-facing port, so a malformed request from an untrusted SoC has to fail cleanly at both targets behind it. |
| TOP_BIT_BASH_NO_BLOCK_DV | Bit-bash over every register of those same blocks, run systematically with no random subset. Every other block is excluded, having been checked at block level. |
| TOP_INTERRUPT_BEYOND_ROUTING | PLIC behaviour beyond routing is exercised here: priority, enable and disable, and claim and complete. Triggering from a real event instead of `INTR_TEST` is required only for sources whose block-level environment does not cover their interrupt. |
| TOP_CROSS_IP_PATHS | Cross-IP paths exercised: alert source through the alert handler to escalation and the reset manager, `rom_ctrl` to KMAC at boot, `keymgr_dpe` to KMAC, the entropy chain to its consumers, `otp_ctrl` supplying the life-cycle state to `lc_ctrl` at boot, the `lc_ctrl` broadcast reaching each internal consumer, `otp_ctrl` key derivation supplying scrambling keys to `sram_ctrl` and `otbn`, `rom_ctrl` reporting its check result to `pwrmgr` so that boot is gated on it, the `lc_ctrl` clock bypass request and acknowledge with `clkmgr`, and the idle indications from the main-domain IPs reaching `clkmgr`. |
| TOP_RESET_PATHS | Software reset, NDM reset via the debug module, alert-escalation reset and main-domain power-off reset each exercised, with the `reset_info` cause confirmed after each and `rst_soc_cpu_no` independence checked. |
| TOP_POWER_CYCLE_FLOWS | The remaining power-cycle flows on top of `TOP_POWER_CYCLE_V1`: reload from non-volatile memory and retained in SRAM, retention save and restore, and repeated cycles rather than a single one. |
| TOP_CROSSING_DELAY_INJECTION | The AON to main crossing tests run with randomised delay injected on the crossing signals, since plain RTL simulation aligns them at zero delay. |
| TOP_CONNECTIVITY_CHECKED | The life-cycle function-control and debug-policy fan-out is checked exhaustively with the top-level connectivity flow, listing each intended source and destination, so every policy signal reaches its internal consumer and its boundary port, and reaches nothing else. The primary path is already covered by `TOP_LC_FANOUT_V1`. |
| TOP_FPV_TARGETED | The power finite state machine and the reset tree are proven exhaustively with formal. |
| TOP_LC_DEBUG_LOCKDOWN_FULL | Security item. All production and debug-enabled life-cycle states covered in both directions, with coverage showing no path enables DFT, debug or NVM debug in a production state. |
| TOP_MEMORY_PATHS_NEGATIVE | Negative testing on the memory egress and ingress paths, where an untrusted SoC reaches Peppermint memory: illegal or unsupported access handling, and malformed mailbox or DMA requests. The simple AHB error and backpressure cases are already at V1 under `TOP_AHB_ACCESS_V1`. |
| TOP_ALL_TESTS_PASSING_V2 | All V1 and V2 testpoints passing. |
| TOP_VPLAN_COVERAGE_V2 | All vPlan items tagged V1 and V2 achieved. |
| TOP_GLUE_CODE_COVERAGE_90 | At least 90 percent each of the following coverage metrics on top-level glue logic with block-verified IPs stubbed out: line, branch, toggle and FSM. Every exclusion carries a written justification and is reviewed. |
| TOP_KNOWN_BUGS_TRIAGED_V2 | All known bugs triaged; all must-fix bugs fixed. |
| TOP_GLS_SUPPORT_DELIVERED | Gate-level support material handed over: curated test subset, simulation target and test list, expected results, exclusions and waivers, and confirmation that the foundry macro models work with the testbench backdoor access. |
| TOP_INTEGRATOR_EVIDENCE | The evidence committed to under `TOP_INTEGRATOR_HANDOFF` has been received from the integrator and reviewed: the SoC integration tested, the gate-level runs, and the power-aware simulation covering the powered-off main domain. |

## V3

Not in scope for now.
The bar for V3 is defined at a later point, and would cover full regression with soak, 100 percent planned coverage, X-propagation clean, no tool warnings, testbench lint clean and no open issues.

## Sign-off procedure

Advancing a stage requires a pull request carrying the filled checklist as a Markdown file.
It needs to be approved by the design lead and by the verification lead, or, if the leads actively designed or verified the part to be signed off, by a similarly senior substitute.
The same pull request updates the top-level row of [the stages page](stages.md), which records the current stage of the top and of every integrated IP.
Anything touching life-cycle, OTP or countermeasure logic additionally needs security review before the stage is signed.
Testpoints marked security-critical in the testplan cannot be waived, which is how the debug and test lockdown properties are protected without restating them here.
