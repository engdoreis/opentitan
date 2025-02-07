#include <stdbool.h>

#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"
#include "sw/device/lib/dif/dif_spi_device.h"
#include "sw/device/lib/testing/spi_device_testutils.h"
#include "sw/device/lib/testing/test_framework/check.h"
#include "sw/device/silicon_creator/lib/dbg_print.h"

void configure_spi_device(dif_spi_device_handle_t *spi_device) {
  mmio_region_t base_addr = mmio_region_from_addr(TOP_EARLGREY_SPI_DEVICE_BASE_ADDR);
  CHECK_DIF_OK(dif_spi_device_init_handle(base_addr, spi_device));

  dif_spi_device_config_t spi_config = {
    .clock_polarity = kDifSpiDeviceEdgePositive,
    .data_phase = kDifSpiDeviceEdgePositive,
    .tx_order = kDifSpiDeviceBitOrderMsbToLsb,
    .rx_order = kDifSpiDeviceBitOrderMsbToLsb,
    .device_mode = kDifSpiDeviceModeFlashEmulation,
  };
  CHECK_DIF_OK(dif_spi_device_configure(spi_device, spi_config));

  dif_spi_device_flash_command_t read_cmd = {
    .opcode = kSpiDeviceFlashOpReadNormal,
    .address_type = kDifSpiDeviceFlashAddr4Byte,
    .dummy_cycles = 0,
    .payload_io_type = kDifSpiDevicePayloadIoSingle,
    .payload_dir_to_host = false,
    .upload = true,
  };

  dif_spi_device_flash_command_t write_cmd = {
    .opcode = kSpiDeviceFlashOpPageProgram,
    .address_type = kDifSpiDeviceFlashAddr4Byte,
    .payload_io_type = kDifSpiDevicePayloadIoSingle,
    .payload_dir_to_host = false,
    .upload = true,
    .set_busy_status = true,
  };

  CHECK_DIF_OK(dif_spi_device_set_flash_command_slot(spi_device, kSpiDeviceReadCommandSlotBase, kDifToggleEnabled, read_cmd));
  CHECK_DIF_OK(dif_spi_device_set_flash_command_slot(spi_device, kSpiDeviceWriteCommandSlotBase, kDifToggleEnabled, write_cmd));

  uint32_t status;
  CHECK_DIF_OK(dif_spi_device_get_flash_status_registers(spi_device, &status));
  dbg_printf("status before: %x\r\n", status);
  CHECK_DIF_OK(dif_spi_device_set_flash_status_registers(spi_device, status | (1 << 1)));
  CHECK_DIF_OK(dif_spi_device_get_flash_status_registers(spi_device, &status));
  dbg_printf("status after: %x\r\n", status);

  CHECK_DIF_OK(dif_spi_device_configure_flash_wren_command(spi_device, kDifToggleEnabled, kSpiDeviceFlashOpWriteEnable));
}

void bare_metal_main(void) {
  dif_spi_device_handle_t spi_device;
  configure_spi_device(&spi_device);

  dbg_printf("CONFIGURED\r\n");

  while (true) {
    upload_info_t upload_info;
    CHECK_STATUS_OK(spi_device_testutils_wait_for_upload(&spi_device, &upload_info));

    dbg_printf("opcode: %d\r\n", upload_info.opcode);
  }
}

void interrupt_handler(void) { dbg_printf("Interrupt!\r\n"); }
