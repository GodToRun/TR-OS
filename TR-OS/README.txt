-- Introduction --
Welcome to TR-OS project!
TR-OS is an x86 assembly operating system project.
-- Folders and Files --
/source: source codes (assembly)
/source/bootsector.asm: source from mikeos. special thanks!
/make.bat: build source code (only windows)
/tros.flp: floppy disk file
-- How to Build --
it's simple. just click make.bat.
-- run on QEMU --
run cmd and enter TR-OS project folder and
input 'make.bat' or 'qemu-system-i386 tros.flp'
-- run on VMware --
build tr-os and add vmware virtual machine (no hard disks, 4MB memory, other vm type, floppy drive)
and inception tros.flp file to floppy drive. and run.
-- Special Thanks --
mikeos: thanks for supporting our bootloader!
osdev wiki
and more...
