// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Manually select FSM states exclusions in UNR generated exclusion file.
//==================================================
// This file contains the Excluded objects
// Generated By User: chencindy
// Format Version: 2
// Date: Thu Feb  3 12:42:14 2022
// ExclMode: default
//==================================================
CHECKSUM: "979204326 3647041052"
INSTANCE: tb.dut.gen_fsm_scramble_enabled.u_checker_fsm
Fsm state_d "1410404563"
ANNOTATION: "VC_COV_UNR"
Transition Checking->KmacAhead "341->629"
Fsm state_d "1410404563"
ANNOTATION: "VC_COV_UNR"
Transition Checking->ReadingHigh "341->181"
Fsm state_d "1410404563"
ANNOTATION: "VC_COV_UNR"
Transition Done->Checking "522->341"
Fsm state_d "1410404563"
ANNOTATION: "VC_COV_UNR"
Transition Done->KmacAhead "522->629"
Fsm state_d "1410404563"
ANNOTATION: "VC_COV_UNR"
Transition Done->ReadingHigh "522->181"
Fsm state_d "1410404563"
ANNOTATION: "VC_COV_UNR"
Transition Done->RomAhead "522->917"
Fsm state_d "1410404563"
ANNOTATION: "VC_COV_UNR"
Transition Invalid->RomAhead "293->917"
Fsm state_d "1410404563"
ANNOTATION: "VC_COV_UNR"
Transition KmacAhead->Done "629->522"
Fsm state_d "1410404563"
ANNOTATION: "VC_COV_UNR"
Transition KmacAhead->RomAhead "629->917"
Fsm state_d "1410404563"
ANNOTATION: "VC_COV_UNR"
Transition ReadingHigh->Done "181->522"
Fsm state_d "1410404563"
ANNOTATION: "VC_COV_UNR"
Transition RomAhead->Done "917->522"
Fsm state_d "1410404563"
ANNOTATION: "VC_COV_UNR"
Transition RomAhead->Invalid "917->293"
Fsm state_d "1410404563"
ANNOTATION: "VC_COV_UNR"
Transition RomAhead->KmacAhead "917->629"
Fsm state_d "1410404563"
ANNOTATION: "VC_COV_UNR"
Transition RomAhead->ReadingHigh "917->181"
