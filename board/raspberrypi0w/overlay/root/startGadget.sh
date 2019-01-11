#!/bin/sh
# Copyright (C) 2018 Flatmax Pty. Ltd. Audio Injector

#mount -o remount, rw /

modprobe libcomposite

mkdir /config

if grep -qs '/config ' /proc/mounts; then
    echo "/config is mounted."
else
    echo "Mounting /config"
    mount none /config -t configfs
fi

mkdir /config/usb_gadget/g1
cd /config/usb_gadget/g1

echo 0x1d6b > idVendor  # Linux Foundation
echo 0x0104 > idProduct # Multifunction Composite Gadget
#echo 0x0100 > bcdDevice # v1.0.0
#echo 0x0200 > bcdUSB    # USB 2.0

mkdir strings/0x409
echo "Audio Injector.net" > strings/0x409/manufacturer
echo "Ethernet/audio" > strings/0x409/product

# configure the ethernet
CDIR1=configs/c.1
mkdir $CDIR1
echo 100 > $CDIR1/MaxPower
mkdir $CDIR1/strings/0x409
echo "RNDIS" > $CDIR1/strings/0x409/configuration

#CDIR2=configs/c.2
#mkdir $CDIR2
#echo 100 > $CDIR2/MaxPower
#mkdir $CDIR2/strings/0x409
#echo "EEM" > $CDIR2/strings/0x409/configuration

mkdir functions/rndis.usb0 # use default parameters
#mkdir functions/eem.usb1   # use default parameters

ln -s functions/rndis.usb0 $CDIR1
#ln -s functions/eem.usb1 $CDIR2

# configure the audio
ADIR1=configs/c.1
mkdir $ADIR1
echo 100 > $ADIR1/MaxPower
mkdir $ADIR1/strings/0x409

mkdir functions/uac2.0
echo '48000' > functions/uac2.0/c_srate
echo '48000' > functions/uac2.0/p_srate
echo '4' > functions/uac2.0/c_ssize
echo '4' > functions/uac2.0/p_ssize
echo '3' > functions/uac2.0/c_chmask
echo '3' > functions/uac2.0/p_chmask

ln -s functions/uac2.0 $ADIR1

udevadm settle -t 5 || true
ls /sys/class/udc/ > UDC
