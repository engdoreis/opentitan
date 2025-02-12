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
    // .device_mode = kDifSpiDeviceModeGeneric,
    // .mode_cfg = {
    //   .generic = {
    //     .rx_fifo_commit_wait = 63,
    //     .rx_fifo_len = 8,
    //     .tx_fifo_len = 8,
    //   },
    // },
  };
  CHECK_DIF_OK(dif_spi_device_configure(spi_device, spi_config));

  dif_spi_device_flash_command_t read_status1_cmd = {
    .opcode = kSpiDeviceFlashOpReadStatus1,
    .address_type = kDifSpiDeviceFlashAddrDisabled,
    .dummy_cycles = 0,
    .payload_io_type = kDifSpiDevicePayloadIoSingle,
    .payload_dir_to_host = true,
  };

  dif_spi_device_flash_command_t read_cmd = {
    .opcode = kSpiDeviceFlashOpReadNormal,
    .address_type = kDifSpiDeviceFlashAddrCfg,
    .dummy_cycles = 0,
    .payload_io_type = kDifSpiDevicePayloadIoSingle,
    .payload_dir_to_host = true,
    .upload = true,
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
  CHECK_DIF_OK(dif_spi_device_set_flash_command_slot(spi_device, kSpiDeviceWriteCommandSlotBase + 1, kDifToggleEnabled, read_cmd));
  CHECK_DIF_OK(dif_spi_device_set_flash_command_slot(spi_device, kSpiDeviceWriteCommandSlotBase, kDifToggleEnabled, write_cmd));

  CHECK_DIF_OK(dif_spi_device_configure_flash_wren_command(spi_device, kDifToggleEnabled, kSpiDeviceFlashOpWriteEnable));
  CHECK_DIF_OK(dif_spi_device_configure_flash_en4b_command(spi_device, kDifToggleEnabled, kSpiDeviceFlashOpEnter4bAddr));
}

void bare_metal_main(void) {
  dif_spi_device_handle_t spi_device;
  configure_spi_device(&spi_device);

  dbg_printf("CONFIGURED\r\n");

  uint8_t magic = 'X';
  dbg_printf("magic addr 0x%p\r\n", &magic);

  while (true) {
    upload_info_t upload_info;
    CHECK_STATUS_OK(spi_device_testutils_wait_for_upload(&spi_device, &upload_info));

    if (!upload_info.has_address) {
      dbg_printf("cmd had no address\r\n");
      break;
    }
    mmio_region_t base_addr = mmio_region_from_addr(upload_info.address);

    uint8_t data;
    uint16_t occupancy;
    uint32_t fifo_start;

    switch (upload_info.opcode) {
      case kSpiDeviceFlashOpReadNormal:
        CHECK_DIF_OK(dif_spi_device_get_flash_payload_fifo_occupancy(&spi_device, &occupancy, &fifo_start));
        dbg_printf("before occupancy %d, %d\r\n", occupancy, fifo_start);

        data = mmio_region_read8(base_addr, 0);
        CHECK_DIF_OK(
          dif_spi_device_write_flash_buffer(&spi_device, kDifSpiDeviceFlashBufferTypeEFlash, 0, 1, &data)
        );

        CHECK_DIF_OK(dif_spi_device_get_flash_payload_fifo_occupancy(&spi_device, &occupancy, &fifo_start));
        dbg_printf("after occupancy %d, %d\r\n", occupancy, fifo_start);
        break;
      case kSpiDeviceFlashOpPageProgram:
        if (upload_info.data_len == 0) {
          dbg_printf("program cmd to addr %p had no data\r\n", base_addr.base);
        } else if (upload_info.data_len == 1) {
          mmio_region_write8(base_addr, 0, upload_info.data[0]);
        } else {
          dbg_printf("TODO: multi-byte program\r\n");
        }
        break;
      default:
        dbg_printf("unknown opcode: %d\r\n", upload_info.opcode);
    }

    CHECK_DIF_OK(dif_spi_device_clear_flash_busy_bit(&spi_device));
    
    // uint8_t buf[1];
    // size_t bytes_received = 0;
    // CHECK_DIF_OK(dif_spi_device_recv(&spi_device, buf, sizeof(buf), &bytes_received));
    // if (bytes_received > 0) {
    //   dbg_printf("received: %x\r\n", buf[0]);
    // }
  }
}

void interrupt_handler(void) { dbg_printf("Interrupt!\r\n"); }
