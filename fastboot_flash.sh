#!/bin/bash
IMAGE_PATH=~/server/bringup36/dailybuild/M76-l1_base/out/target/product/m76
function yes_or_no
{
    read i
    case $i in
        yes|y|Y|Yes) 
            ;;
        no|n|N|No) exit 1
            ;;
    esac
}
function fastboot_mode 
{
    echo -n "fastboot ready?(y/n)?"
    yes_or_no
    sudo fastboot devices
    if [ $? -eq 0 ]
    then
        fastboot flash ramdisk $IMAGE_PATH/ramdisk-uboot.img
        fastboot flash kernel $IMAGE_PATH/kernel
        fastboot flash system $IMAGE_PATH/system.img
        fastboot reboot
    else
        echo "Not in fastboot,please check your devices."
        fastboot_mode
    fi
}
adb devices
echo -n "ready to go?(y/n)"
yes_or_no
adb reboot bootloader
fastboot_mode
