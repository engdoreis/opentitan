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
    .data_phase = kDifSpiDeviceEdgeNegative,
    .tx_order = kDifSpiDeviceBitOrderMsbToLsb,
    .rx_order = kDifSpiDeviceBitOrderMsbToLsb,
    .device_mode = kDifSpiDeviceModeFlashEmulation,
  };
  CHECK_DIF_OK(dif_spi_device_configure(spi_device, spi_config));

  dif_spi_device_flash_command_t read_status1_cmd = {
    .opcode = kSpiDeviceFlashOpReadStatus1,
    .address_type = kDifSpiDeviceFlashAddrDisabled,
    .dummy_cycles = 0,
    .payload_io_type = kDifSpiDevicePayloadIoSingle,
    .payload_dir_to_host = true,
  };

  dif_spi_device_flash_command_t read_4b_cmd = {
    .opcode = kSpiDeviceFlashOpRead4b,
    .address_type = kDifSpiDeviceFlashAddrCfg,
    .dummy_cycles = 0,
    .payload_io_type = kDifSpiDevicePayloadIoSingle,
    .upload = true,
    .set_busy_status = true,
  };

  dif_spi_device_flash_command_t read_normal_cmd = {
    .opcode = kSpiDeviceFlashOpReadNormal,
    .address_type = kDifSpiDeviceFlashAddrCfg,
    .dummy_cycles = 0,
    .payload_io_type = kDifSpiDevicePayloadIoSingle,
    .payload_dir_to_host = true,
  };

  dif_spi_device_flash_command_t write_cmd = {
    .opcode = kSpiDeviceFlashOpPageProgram,
    .address_type = kDifSpiDeviceFlashAddrCfg,
    .dummy_cycles = 0,
    .payload_io_type = kDifSpiDevicePayloadIoSingle,
    .payload_dir_to_host = false,
    .upload = true,
    .set_busy_status = true,
  };

  CHECK_DIF_OK(dif_spi_device_set_flash_command_slot(spi_device, kSpiDeviceReadCommandSlotBase, kDifToggleEnabled, read_status1_cmd));
  CHECK_DIF_OK(dif_spi_device_set_flash_command_slot(spi_device, kSpiDeviceReadCommandSlotBase + 5, kDifToggleEnabled, read_normal_cmd));
  CHECK_DIF_OK(dif_spi_device_set_flash_command_slot(spi_device, kSpiDeviceWriteCommandSlotBase, kDifToggleEnabled, write_cmd));
  CHECK_DIF_OK(dif_spi_device_set_flash_command_slot(spi_device, kSpiDeviceWriteCommandSlotBase + 1, kDifToggleEnabled, read_4b_cmd));

  CHECK_DIF_OK(dif_spi_device_configure_flash_wren_command(spi_device, kDifToggleEnabled, kSpiDeviceFlashOpWriteEnable));
  CHECK_DIF_OK(dif_spi_device_configure_flash_en4b_command(spi_device, kDifToggleEnabled, kSpiDeviceFlashOpEnter4bAddr));
}

void bare_metal_main(void) {
  dif_spi_device_handle_t spi_device;
  configure_spi_device(&spi_device);

  dbg_printf("CONFIGURED\r\n");

  uint32_t magic = 0xdeadbeef;
  dbg_printf("magic addr 0x%p\r\n", &magic);

  while (true) {
    upload_info_t upload_info;
    CHECK_STATUS_OK(spi_device_testutils_wait_for_upload(&spi_device, &upload_info));

    if (!upload_info.has_address) {
      dbg_printf("cmd had no address\r\n");
      break;
    }

    // Variables cannot be declared within a switch:
    mmio_region_t base_addr;
    // 8-bit and 32-bit data read from OpenTitan memory:
    uint8_t data8;
    uint32_t data32;

    switch (upload_info.opcode) {
      case kSpiDeviceFlashOpRead4b:
        base_addr = mmio_region_from_addr(upload_info.address);

        if (upload_info.data_len == 0) {
          data8 = mmio_region_read8(base_addr, 0);
          CHECK_DIF_OK(dif_spi_device_write_flash_buffer(&spi_device, kDifSpiDeviceFlashBufferTypeEFlash, 0, 1, &data8));
          break;
        }

        for (uint16_t i = 0; i < upload_info.data[0] i += 4) {
          data32 = mmio_region_read32(base_addr, i);
          CHECK_DIF_OK(dif_spi_device_write_flash_buffer(&spi_device, kDifSpiDeviceFlashBufferTypeEFlash, i, sizeof(data32), (uint8_t*)&data32));
        }

        break;
      case kSpiDeviceFlashOpPageProgram:
        base_addr = mmio_region_from_addr(upload_info.address);
        if (upload_info.data_len == 0) {
          dbg_printf("program cmd to addr %p had no data\r\n", base_addr.base);
        } else if (upload_info.data_len == 1) {
            mmio_region_write8(base_addr, 0, upload_info.data[0]);
        } else {
          dbg_printf("TODO: multi-byte program\r\n");
        }
        break;
      default:
        dbg_printf("unknown opcode: %x\r\n", upload_info.opcode);
    }

    CHECK_DIF_OK(dif_spi_device_clear_flash_busy_bit(&spi_device));
  }
}

void interrupt_handler(void) { dbg_printf("Interrupt!\r\n"); }
