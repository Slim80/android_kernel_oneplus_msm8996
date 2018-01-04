#!/bin/sh
export KERNELDIR=`readlink -f .`
export PARENT_DIR=`readlink -f ..`
export ARCH=arm64
export SUBARCH=arm64
export PATH=/home/slim80/Scrivania/Kernel/Compilatori/aarch64-linux-android-4.9/bin:$PATH
export CROSS_COMPILE=aarch64-linux-android-
export KCONFIG_NOTIMESTAMP=true

IMPERIUM="/home/slim80/Scrivania/Kernel/oneplus/Imperium"
KERNELDIR="/home/slim80/Scrivania/Kernel/oneplus/Imperium/Imperium_Kernel_O"
BUILDKERNEL="/home/slim80/Scrivania/Kernel/oneplus/Imperium/Build_Kernel"
FINALKERNEL="/home/slim80/Scrivania/Kernel/oneplus/Imperium/Final_Kernel"
IMAGE="/home/slim80/Scrivania/Kernel/oneplus/Imperium/Imperium_Kernel_O/arch/arm64/boot"
ANYKERNEL="/home/slim80/Scrivania/Kernel/oneplus/Imperium/Imperium_Kernel_O/AnyKernel"

rm -f arch/arm64/boot/*.cmd
rm -f arch/arm64/boot/dts/*.cmd
rm -f arch/arm64/boot/Image*.*
rm -f arch/arm64/boot/.Image*.*
find -name '*.gz*' -exec rm -rf {} \;
find -name '*.dtb' -exec rm -rf {} \;
find -name '*.ko' -exec rm -rf {} \;
rm -rf $ANYKERNEL/zImage
rm -rf $BUILDKERNEL/Slim80/kernel/*

make clean
make distclean
rm -rf ~/.ccache
ccache -C
