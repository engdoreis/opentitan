import sys
from tqdm import tqdm
from OTDatabase import OTSqliteDB
from E2ENightlies import E2ENightlies
from DVRegressions import DVRegressions
from MasterCI import MasterCI

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print(f"""Usage: {sys.argv[0]} <path/to/database_path.db> <path/to/e2e_nightly.json> <path/to/ci_master.json>""")
        exit(0)

    database = OTSqliteDB(sys.argv[1])

    E2ENightlies(database).run(sys.argv[2])
    MasterCI(database).run(sys.argv[3])

    block_list = [
        "https://reports.opentitan.org/hw/ip/adc_ctrl/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/aes_masked/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/aes_unmasked/dv/{}/report.json",
        "https://reports.opentitan.org/hw/top_earlgrey/ip_autogen/alert_handler/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/aon_timer/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/clkmgr/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/csrng/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/edn/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/entropy_src/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/flash_ctrl/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/gpio/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/hmac/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/i2c/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/keymgr/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/kmac_masked/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/kmac_unmasked/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/lc_ctrl/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/otbn/dv/uvm/{}/report.json",
        "https://reports.opentitan.org/hw/ip/otp_ctrl/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/pattgen/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/prim/dv/prim_alert/{}/report.json",
        "https://reports.opentitan.org/hw/ip/prim/dv/prim_esc/{}/report.json",
        "https://reports.opentitan.org/hw/ip/prim/dv/prim_lfsr/{}/report.json",
        "https://reports.opentitan.org/hw/ip/prim/dv/prim_present/{}/report.json",
        "https://reports.opentitan.org/hw/ip/prim/dv/prim_prince/{}/report.json",
        "https://reports.opentitan.org/hw/ip/pwm/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/pwrmgr/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/rom_ctrl/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/rstmgr/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/rstmgr/dv/rstmgr_cnsty_chk/{}/report.json",
        "https://reports.opentitan.org/hw/ip/rv_dm/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/rv_timer/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/spi_device/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/spi_host/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/sram_ctrl_main/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/sram_ctrl_ret/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/sysrst_ctrl/dv/{}/report.json",
        "https://reports.opentitan.org/hw/dv/sv/tl_agent/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/uart/dv/{}/report.json",
        "https://reports.opentitan.org/hw/ip/usbdev/dv/{}/report.json",
        "https://reports.opentitan.org/hw/top_earlgrey/ip/xbar_main/dv/autogen/{}/report.json",
        "https://reports.opentitan.org/hw/top_earlgrey/ip/xbar_peri/dv/autogen/{}/report.json",
        "https://reports.opentitan.org/hw/top_earlgrey/dv/{}/report.json",
    ]

    dv = DVRegressions(database)
    for home_url in tqdm(block_list, desc="Report"):
        dv.run(home_url)