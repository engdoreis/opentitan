#include <stdbool.h>

#include "sw/device/silicon_creator/lib/dbg_print.h"

void bare_metal_main(void) {
  dbg_printf("DONE\r\n");
  while (true) {}
}

void interrupt_handler(void) { dbg_printf("Interrupt!\r\n"); }
