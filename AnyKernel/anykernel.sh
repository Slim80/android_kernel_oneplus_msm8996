# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Imperium Kernel for OnePlus 3T by Slim80
do.devicecheck=0
do.initd=0
do.modules=1
do.cleanup=1
do.cleanuponabort=1
device.name1=oneplus3t
device.name2=OnePlus3T
device.name3=OnePlus 3T
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*;
chmod 755 $ramdisk/sbin/busybox

## AnyKernel install
dump_boot;

# begin ramdisk changes

# init.rc
remove_line init.rc "import /init.imperium.rc";
insert_line init.rc "init.imperium.rc" after "import /init.usb.configfs.rc" "import /init.imperium.rc";

# end ramdisk changes

write_boot;

## end install
