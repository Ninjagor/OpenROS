CC := x86_64-elf-gcc
LD := x86_64-elf-ld

CFLAGS := -Wall -Wextra -nostdlib -nostartfiles -ffreestanding -m32 -Ikernel/include
LDFLAGS := -m elf_i386 -T kernel/kernel.ld

NASM := nasm
NASMFLAGS := -f bin

BOOT_SRC := bootloader/boot.asm
BOOT_BIN := bin/bootloader/boot.bin

KERNEL_SRC := $(shell find kernel -name '*.c')
KERNEL_OBJ := $(patsubst kernel/%.c, bin/out/%.o, $(KERNEL_SRC))
KERNEL_BIN := bin/out/kernel.bin

.PHONY: all clean

all: $(BOOT_BIN) $(KERNEL_BIN)

$(BOOT_BIN): $(BOOT_SRC)
	mkdir -p $(dir $@)
	$(NASM) $(NASMFLAGS) $< -o $@

bin/out/%.o: kernel/%.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(KERNEL_BIN): $(KERNEL_OBJ)
	mkdir -p $(dir $@)
	$(LD) $(LDFLAGS) -o $@ $(KERNEL_OBJ)

clean:
	rm -rf bin
