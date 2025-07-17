#include "display/display.h"
#include "tools/str.h"

size_t terminal_row;
size_t terminal_column;
uint8_t terminal_color;
uint16_t *terminal_buffer;


void terminal_initialize(void) {
    terminal_row = 0;
    terminal_column = 0;
    terminal_color = vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
    terminal_buffer = (uint16_t*) 0xb8000;
    for (size_t y=0; y < VGA_HEIGHT; y++) {
        for (size_t x=0; x < VGA_WIDTH; x++) {
            const size_t index = y * VGA_WIDTH + x;
            terminal_buffer[index] = vga_entry(' ', terminal_color);
        }
    }
}


void terminal_setcolor(uint8_t color) {
    terminal_color = color;
}


void terminal_putentryat(char c, uint8_t color, size_t x, size_t y) {
    const size_t index = y * VGA_WIDTH + x;
    terminal_buffer[index] = vga_entry(c, color);
}

void terminal_putchar(char c) {
    if (c == '\n') {
        terminal_column = 0;
        if (++terminal_row >= VGA_HEIGHT) {
            terminal_row = 0;
        }
    } else {
        terminal_putentryat(c, terminal_color, terminal_column, terminal_row);
        if (++terminal_column >= VGA_WIDTH) {
            terminal_column = 0;
            if (++terminal_row >= VGA_HEIGHT) {
                terminal_row = 0;
            }
        }
    }
}


void terminal_write(const char* data, size_t size) {
    for (size_t ii=0; ii < size; ii++) {
        terminal_putchar(data[ii]);
    }
}


void terminal_writestring(const char* data) {
    terminal_write(data, strlen(data));
}

void terminal_write_dec(uint32_t num) {
    char buf[11];
    int i = 10;
    buf[i--] = '\0';
    if (num == 0) {
        buf[i] = '0';
        terminal_writestring(&buf[i]);
        return;
    }

    while (num > 0 && i >= 0) {
        buf[i--] = '0' + (num % 10);
        num /= 10;
    }

    terminal_writestring(&buf[i + 1]);
}
