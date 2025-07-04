// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

use std::fs;
use std::str::FromStr;
use std::time::Duration;

use anyhow::{Context, Result};
use clap::Parser;
use serde::Deserialize;

use pentest_commands::commands::PenetrationtestCommand;
use pentest_commands::sca_hmac_commands::HmacScaSubcommand;

use opentitanlib::app::TransportWrapper;
use opentitanlib::execute_test;
use opentitanlib::io::uart::Uart;
use opentitanlib::test_utils::init::InitializeTest;
use opentitanlib::test_utils::rpc::{ConsoleRecv, ConsoleSend};
use opentitanlib::uart::console::UartConsole;
use pentest_lib::filter_response_common;

#[derive(Debug, Parser)]
struct Opts {
    #[command(flatten)]
    init: InitializeTest,

    // Console receive timeout.
    #[arg(long, value_parser = humantime::parse_duration, default_value = "10s")]
    timeout: Duration,

    #[arg(long, num_args = 1..)]
    sca_hmac_json: Vec<String>,
}

#[derive(Debug, Deserialize)]
struct ScaHmacTestCase {
    test_case_id: usize,
    command: String,
    #[serde(default)]
    input: String,
    #[serde(default)]
    key: String,
    #[serde(default)]
    sensors: String,
    #[serde(default)]
    triggers: String,
    expected_output: Vec<String>,
}

fn run_sca_hmac_testcase(
    test_case: &ScaHmacTestCase,
    opts: &Opts,
    uart: &dyn Uart,
    fail_counter: &mut u32,
) -> Result<()> {
    log::info!(
        "test case: {}, test: {}",
        test_case.test_case_id,
        test_case.command
    );
    PenetrationtestCommand::HmacSca.send(uart)?;

    // Send test subcommand.
    HmacScaSubcommand::from_str(test_case.command.as_str())
        .context("unsupported HMAC SCA subcommand")?
        .send(uart)?;

    // Check if we need to send an input.
    if !test_case.key.is_empty() {
        let key: serde_json::Value = serde_json::from_str(test_case.key.as_str()).unwrap();
        key.send(uart)?;
    }

    if !test_case.input.is_empty() {
        let input: serde_json::Value = serde_json::from_str(test_case.input.as_str()).unwrap();
        input.send(uart)?;
    }

    // Check if we need to send sensor info.
    if !test_case.sensors.is_empty() {
        let sensors: serde_json::Value = serde_json::from_str(test_case.sensors.as_str()).unwrap();
        sensors.send(uart)?;
    }

    if !test_case.triggers.is_empty() {
        let triggers: serde_json::Value =
            serde_json::from_str(test_case.triggers.as_str()).unwrap();
        triggers.send(uart)?;
    }

    // Check test outputs
    if !test_case.expected_output.is_empty() {
        for exp_output in test_case.expected_output.iter() {
            // Get test output & filter.
            let output = serde_json::Value::recv(uart, opts.timeout, false)?;
            // Only check non empty JSON responses.
            if output.as_object().is_some() {
                let output_received = filter_response_common(output.clone());

                // Filter expected output.
                let exp_output: serde_json::Value =
                    serde_json::from_str(exp_output.as_str()).unwrap();
                let output_expected = filter_response_common(exp_output.clone());

                // Check received with expected output.
                if output_expected != output_received {
                    log::info!(
                        "FAILED {} test #{}: expected = '{}', actual = '{}'",
                        test_case.command,
                        test_case.test_case_id,
                        exp_output,
                        output
                    );
                    *fail_counter += 1;
                }
            }
        }
    }

    Ok(())
}

fn test_sca_hmac(opts: &Opts, transport: &TransportWrapper) -> Result<()> {
    let uart = transport.uart("console")?;
    uart.set_flow_control(true)?;
    let _ = UartConsole::wait_for(&*uart, r"Running [^\r\n]*", opts.timeout)?;

    let mut test_counter = 0u32;
    let mut fail_counter = 0u32;
    let test_vector_files = &opts.sca_hmac_json;
    for file in test_vector_files {
        let raw_json = fs::read_to_string(file)?;
        let sca_hmac_tests: Vec<ScaHmacTestCase> = serde_json::from_str(&raw_json)?;
        for sca_hmac_test in &sca_hmac_tests {
            test_counter += 1;
            log::info!("Test counter: {}", test_counter);
            run_sca_hmac_testcase(sca_hmac_test, opts, &*uart, &mut fail_counter)?;
        }
    }
    assert_eq!(
        0, fail_counter,
        "Failed {} out of {} tests.",
        fail_counter, test_counter
    );
    Ok(())
}

fn main() -> Result<()> {
    let opts = Opts::parse();
    opts.init.init_logging();

    let transport = opts.init.init_target()?;
    execute_test!(test_sca_hmac, &opts, &transport);
    Ok(())
}
