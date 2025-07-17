AS = i686-elf-as
CC = i686-elf-gcc

INCLUDES = -Ikernel/include -Ikernel/include/tools

C_SOURCES := $(shell find kernel -name '*.c')
ASM_SOURCES := $(shell find kernel -name '*.s') $(shell find kernel -name '*.S')
BOOT_ASM_SOURCES := $(wildcard bootloader/*.s)

OBJ := \
	$(patsubst kernel/%.c, bin/%.o, $(C_SOURCES)) \
	$(patsubst kernel/%.s, bin/%.o, $(ASM_SOURCES)) \
	$(patsubst kernel/%.S, bin/%.o, $(ASM_SOURCES)) \
	$(patsubst bootloader/%.s, bin/%.o, $(BOOT_ASM_SOURCES))

all: bin/openROS.iso

bin/%.o: kernel/%.c
	@mkdir -p $(dir $@)
	${CC} ${INCLUDES} -c $< -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra

bin/%.o: kernel/%.s
	@mkdir -p $(dir $@)
	${AS} $< -o $@

bin/%.o: kernel/%.S
	@mkdir -p $(dir $@)
	${CC} -c $< -o $@ -ffreestanding -O2

bin/%.o: bootloader/%.s
	@mkdir -p $(dir $@)
	${AS} $< -o $@

bin/openROS.bin: $(OBJ)
	${CC} -T linker.ld -o $@ -ffreestanding -O2 -nostdlib $^ -lgcc

check-multiboot: bin/openROS.bin
	# grub-file --is-x86-multiboot bin/openROS.bin

bin/openROS.iso: check-multiboot
	rm -rf isodir/
	mkdir -p isodir/boot/grub
	cp bin/openROS.bin isodir/boot/openROS.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	docker run --rm --platform linux/amd64 -v "$(PWD):/mnt" -w /mnt my-grub-image grub-mkrescue -o bin/openROS.iso isodir

clean:
	rm -rf isodir/
	rm -rf bin/*.o bin/*.bin bin/*.iso
