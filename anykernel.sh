# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# EDIFY properties
kernel.string=Guyver by MEGAX91 @ xda-developers
do.devicecheck=1
do.initd=1
do.modules=0
do.cleanup=1
device.name1=kate
device.name2=kenzo
device.name3=Redmi Note 3
device.name4=
device.name5=

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel permissions
# set permissions for included ramdisk files
chmod -R 755 $ramdisk


## AnyKernel install
dump_boot;

# begin ramdisk changes

# add guyver initialization script
insert_line init.rc "import /init.guyver.rc" after "import /init.cm.rc" "import /init.guyver.rc";

#fstab lazytime support
patch_fstab fstab.qcom /system ext4 options "ro,barrier=1,discard wait" "ro,lazytime,barrier=1,discard wait"
patch_fstab fstab.qcom /data f2fs options "nosuid,nodev,noatime,inline_xattr,data_flush wait,check,encryptable=footer,formattable,length=-16384" "nosuid,nodev,lazytime,inline_xattr,data_flush wait,check,encryptable=footer,formattable,length=-16384"
patch_fstab fstab.qcom /data ext4 options "nosuid,nodev,noatime,barrier=1,noauto_da_alloc wait,check,encryptable=footer,formattable,length=-16384" "nosuid,nodev,lazytime,barrier=1,noauto_da_alloc wait,check,encryptable=footer,formattable,length=-16384"
patch_fstab fstab.qcom /cache f2fs options "nosuid,nodev,noatime,inline_xattr,flush_merge,data_flush wait,check,formattable" "nosuid,nodev,lazytime,inline_xattr,flush_merge,data_flush wait,check,formattable"
patch_fstab fstab.qcom /cache ext4 options "nosuid,nodev,noatime,barrier=1 wait,check,formattable" "nosuid,nodev,lazytime,barrier=1 wait,check,formattable"
patch_fstab fstab.qcom /persist ext4 options "nosuid,nodev,barrier=1 wait" "lazytime,nosuid,nodev,barrier=1 wait"

mount -o rw,remount -t auto /system;
rm -f /system/lib/modules/wlan.ko;
cp -f /tmp/anykernel/wlan.ko /system/lib/modules/wlan.ko;
cp -f /tmp/anykernel/wlan.ko /system/lib/modules/pronto/pronto_wlan.ko;
chmod 0644 /system/lib/modules/wlan.ko;

mount -o ro,remount -t auto /system;

# end ramdisk changes

write_boot;

## end install
