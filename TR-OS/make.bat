@echo off
echo Build script for Windows
echo.

echo Assembling bootloader...
cd source
nasm -O0 -f bin -o bootload.bin bootsector.asm

echo Assembling TR-OS kernel...
nasm -O0 -f bin -o kernel.bin kernel.asm

echo Adding bootsector to disk image...
cd ..
dd if=source\bootload.bin of=tros.flp
echo Mounting disk image...
imdisk -a -f tros.flp -s 1440K -m B:

echo Copying kernel to disk image...
copy source\kernel.bin b:\

echo Dismounting disk image...
imdisk -D -m B:

echo Build Done
echo Running qemu...
qemu-system-i386 tros.flp