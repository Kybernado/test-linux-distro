#!/bin/bash

KERNEL_PATH="../kernel/arch/x86_64/boot/bzImage"
DISK_PATH="./disk.img"

qemu-system-x86_64 \
	-kernel $KERNEL_PATH \
	-drive file=$DISK_PATH,format=raw \
	-append "console=ttyS0 nokaslr root=/dev/sda rw" \
	-cpu host \
	-m 512 \
	-enable-kvm \
	-vga none \
	-gdb tcp::9000

