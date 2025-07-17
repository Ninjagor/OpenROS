#include "display/display.h"

struct regs {
    uint32_t edi;
    uint32_t esi;
    uint32_t ebp;
    uint32_t esp;
    uint32_t ebx;
    uint32_t edx;
    uint32_t ecx;
    uint32_t eax;
    uint32_t int_no;
    uint32_t err_code;
};

void isr_handler_c(struct regs* r) {
    terminal_setcolor(4);
    terminal_writestring("Exception: ");
    terminal_write_dec(r->int_no);
    terminal_writestring("\nSystem Halted.");
    for (;;);
}
