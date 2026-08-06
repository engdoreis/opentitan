# Peppermint Top-Level Checklist

This checklist tracks the maturity of the Peppermint top level.
Every item is defined in the [top-level sign-off definitions](signoff.md), and the section it appears in is the stage it gates.
The current stage of the top level and of every integrated IP is recorded on [the stages page](stages.md), which also tracks design stages.
Top-level DV does not define the design items, so this page has a verification section only.

## Verification Checklist

### V0

Type | Item | Resolution | Note/Collaterals
--------------|----------------------------------|-------------|------------------
Testbench     | TOP_TB_ELABORATES                | Not started |
Testbench     | TOP_STUB_CPU_CSR_ACCESS          | Not started |
Testbench     | TOP_MEM_BACKDOOR_ACCESS          | Not started |
Documentation | TOP_TESTPLAN_DRAFTED             | Not started |
Documentation | TOP_VPLAN_CREATED                | Not started |
Regression    | TOP_CI_LINT_ELAB                 | Not started |

### V1

Type | Item | Resolution | Note/Collaterals
--------------|----------------------------------|-------------|------------------
Documentation | TOP_DV_DOC_DRAFTED               | Not started |
Documentation | TOP_VPLAN_REVIEWED               | Not started |
Documentation | TOP_TESTPLAN_REVIEWED            | Not started |
Testbench     | TOP_TB_COMPLETED                 | Not started |
Testbench     | TOP_SOC_MODELS_IN_PLACE          | Not started |
Testbench     | TOP_SWDV_SIGNALLING              | Not started |
Assertions    | TOP_POWER_SVA_ENABLED            | Not started | Rules pending the power handshake specification
Assertions    | TOP_ASSERT_KNOWN_BOUNDARY        | Not started |
Security      | TOP_LC_DEBUG_LOCKDOWN_V1         | Not started | Not waivable
Security      | TOP_SOC_CPU_RELEASE              | Not started | Not waivable
Tests         | TOP_LC_FANOUT_V1                 | Not started |
Tests         | TOP_POWER_CYCLE_V1               | Not started |
Tests         | TOP_DMI_ACCESS_V1                | Not started |
Tests         | TOP_AHB_ACCESS_V1                | Not started |
Tests         | TOP_INTERRUPT_ROUTING            | Not started |
Review        | TOP_KNOWN_BUGS_TRIAGED_V1        | Not started |
Tests         | TOP_ALL_TESTS_PASSING_V1         | Not started |
Documentation | TOP_VPLAN_COVERAGE_V1            | Not started |
Integration   | TOP_IP_FLOOR_RECORDED            | Not started |
Regression    | TOP_SMOKE_REGRESSION_IN_CI       | Not started |
Regression    | TOP_WEEKLY_REGRESSION            | Not started |
Regression    | TOP_SECOND_SIMULATOR_SMOKE       | Not started |
Integration   | TOP_INTEGRATOR_HANDOFF           | Not started | Countersignature and link to the integrator commitment required
Testbench     | TOP_GLS_TB_CONSTRAINTS           | Not started |

### V2

Type | Item | Resolution | Note/Collaterals
--------------|----------------------------------|-------------|------------------
Documentation | TOP_DV_DOC_COMPLETED             | Not started |
Documentation | TOP_VPLAN_COMPLETED              | Not started |
Documentation | TOP_TESTPLAN_COMPLETED           | Not started |
Tests         | TOP_ADDRESS_MAP_SWEEP            | Not started |
Tests         | TOP_DMI_INTEGRITY_NEGATIVE       | Not started |
Tests         | TOP_BIT_BASH_NO_BLOCK_DV         | Not started |
Tests         | TOP_INTERRUPT_BEYOND_ROUTING     | Not started |
Tests         | TOP_CROSS_IP_PATHS               | Not started |
Tests         | TOP_RESET_PATHS                  | Not started |
Tests         | TOP_POWER_CYCLE_FLOWS            | Not started |
Testbench     | TOP_CROSSING_DELAY_INJECTION     | Not started |
Formal        | TOP_CONNECTIVITY_CHECKED         | Not started |
Formal        | TOP_FPV_TARGETED                 | Not started |
Security      | TOP_LC_DEBUG_LOCKDOWN_FULL       | Not started |
Tests         | TOP_MEMORY_PATHS_NEGATIVE        | Not started |
Tests         | TOP_ALL_TESTS_PASSING_V2         | Not started |
Documentation | TOP_VPLAN_COVERAGE_V2            | Not started |
Coverage      | TOP_GLUE_CODE_COVERAGE_90        | Not started |
Review        | TOP_KNOWN_BUGS_TRIAGED_V2        | Not started |
Integration   | TOP_GLS_SUPPORT_DELIVERED        | Not started |
Integration   | TOP_INTEGRATOR_EVIDENCE          | Not started | Evidence from the integrator, committed to under TOP_INTEGRATOR_HANDOFF
