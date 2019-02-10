#!/bin/sh
export KERNELDIR=`readlink -f .`
export PARENT_DIR=`readlink -f ..`
export ARCH=arm64
export SUBARCH=arm64
export PATH=/home/slim80/Scrivania/Kernel/Compilatori/aarch64-linux-android-4.9/bin:$PATH
#export PATH=/home/slim80/Scrivania/Kernel/Compilatori/DespairFactor-aarch64-linux-android-4.9/bin:$PATH
export CROSS_COMPILE=aarch64-linux-android-
export KCONFIG_NOTIMESTAMP=true

IMPERIUM="/home/slim80/Scrivania/Kernel/oneplus/Imperium"
KERNELDIR="/home/slim80/Scrivania/Kernel/oneplus/Imperium/Imperium_Kernel_O"
BUILDKERNEL="/home/slim80/Scrivania/Kernel/oneplus/Imperium/Build_Kernel"
FINALKERNEL="/home/slim80/Scrivania/Kernel/oneplus/Imperium/Final_Kernel"
IMAGE="/home/slim80/Scrivania/Kernel/oneplus/Imperium/Imperium_Kernel_O/arch/arm64/boot"
ANYKERNEL="/home/slim80/Scrivania/Kernel/oneplus/Imperium/Imperium_Kernel_O/AnyKernel"
SIGNAPK="/home/slim80/Scrivania/Kernel/oneplus/Imperium/SignApk"
NUM_CPUS=`grep -c ^processor /proc/cpuinfo`
VERSION=1.0-R32

find -name '*.gz*' -exec rm -rf {} \;
find -name '*.dtb' -exec rm -rf {} \;
find -name '*.ko' -exec rm -rf {} \;
rm -rf $ANYKERNEL/zImage
rm -rf $BUILDKERNEL/Slim80/kernel/*

rm -rf ~/.ccache
ccache -C

make ARCH=arm64 imperium_defconfig || exit 1

make -j$NUM_CPUS || exit 1

cp arch/arm64/boot/Image.gz-dtb $ANYKERNEL/Image.gz-dtb

rm -rf imperium_install
mkdir -p imperium_install
make ARCH=arm64 CROSS_COMPILE=${CROSS_COMPILE} -j4 INSTALL_MOD_PATH=imperium_install INSTALL_MOD_STRIP=1 modules_install
find imperium_install/ -name '*.ko' -type f -exec cp '{}' $ANYKERNEL/modules/ \;

cd $ANYKERNEL
rm -rf version
touch version
echo Version $VERSION $(date +"[%d-%m-%y]")>> version
zip -r9 Imperium_Kernel.zip *

cd $SIGNAPK
java -jar signapk.jar testkey.x509.pem testkey.pk8 $ANYKERNEL/Imperium_Kernel.zip $BUILDKERNEL/Slim80/kernel/Imperium_Kernel.zip
rm -rf $ANYKERNEL/Imperium_Kernel.zip

cd $BUILDKERNEL
zip -r9 Imperium_Kernel_OP3T_OSS_Oreo_v$VERSION.zip .

cd $SIGNAPK
java -jar signapk.jar testkey.x509.pem testkey.pk8 $BUILDKERNEL/Imperium_Kernel_OP3T_OSS_Oreo_v$VERSION.zip $FINALKERNEL/Imperium_Kernel_OP3T_OSS_Oreo_v$VERSION.zip
rm -rf $BUILDKERNEL/Imperium_Kernel_OP3T_OSS_Oreo_v*

echo "* Done! *"
echo "* Imperium Kernel v$VERSION is ready to be flashed *"
