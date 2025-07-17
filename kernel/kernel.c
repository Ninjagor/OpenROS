#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include "display/display.h"
#include "multiboot.h"

#if defined(__linux__)
#error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif

void kernel_main(multiboot_info_t* mb_info) {
    if (mb_info->flags & (1 << 6)) {
      multiboot_memory_map_t* mmap = (void*)mb_info->mmap_addr;
      while ((uint32_t)mmap < mb_info->mmap_addr + mb_info->mmap_length) {
          mmap = (multiboot_memory_map_t*)((uint32_t)mmap + mmap->size + sizeof(mmap->size));
      }
    }

    terminal_initialize();
    terminal_setcolor(6);
    terminal_writestring("Hello, world!!!\n");
    terminal_writestring("This is my second line :-)\n");
}
