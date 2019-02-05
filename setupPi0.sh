#! /bin/bash
# Setup file to turn the Pi 0w into a smart USB sound card, using the AI stereo sound card or Zero sound card.

if [ $# -lt 1 ]; then
  echo usage :
  me=`basename "$0"`
  echo "     " $me path.to.buildroot.raspberrypi
else
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

  CUSTOM_PATH=$DIR
  BR_REPO_PATH=$1

  # pi0 32 bit
  BR_STOCK_DEFCONFIG=$BR_REPO_PATH/configs/raspberrypi0w_defconfig
  BR_NEW_DEFCONFIG_FILE=raspberrypi0w_32_ai_defconfig
  BR_STOCK_POSTIMAGE=$BR_REPO_PATH/board/raspberrypi0w/post-image.sh
  BR_EXTRA_POSTIMAGE=$CUSTOM_PATH/board/raspberrypi0w/post-image-extra.sh
  BR_EXTRA_DEVICEMODE_POSTIMAGE=$CUSTOM_PATH/board/raspberrypi0w/post-image-devicemode-extra.sh
  BR_STOCK_GENIMAGE=$BR_REPO_PATH/board/raspberrypi0w/genimage-raspberrypi3.cfg

  # common target genimage file
  BR_NEW_DEFCONFIG=$CUSTOM_PATH/configs/$BR_NEW_DEFCONFIG_FILE
  BR_EXTRA_DEFCONFIG=$CUSTOM_PATH/configs/raspberrypi_ai_defconfig
  BR_DEVICEMODE_DEFCONFIG=$CUSTOM_PATH/configs/raspberrypi_ai_devicemode_defconfig
  BR_POSTIMAGE=$BR_REPO_PATH/output/build/post-image.sh
  BR_GENIMAGE=$BR_REPO_PATH/output/build/genimage-pi.cfg

  mkdir -p $BR_REPO_PATH/output/build

  if [ ! -d "$BR_REPO_PATH" ]; then
  	echo Can\'t find the directory $BR_REPO_PATH please correct the bash script.
  	return;
  fi
  if [ ! -e "$BR_STOCK_DEFCONFIG" ]; then
  	echo can\'t find the file $BR_STOCK_DEFCONFIG
  	echo please fix this script
  	return;
  fi
  if [ ! -e "$BR_STOCK_POSTIMAGE" ]; then
  	echo can\'t find the file $BR_STOCK_POSTIMAGE
  	echo please fix this script
  	return;
  fi

  if [ ! -d "$CUSTOM_PATH" ]; then
  	echo Can\'t find the directory $CUSTOM_PATH please correct the bash script.
  	return;
  fi
  if [ ! -e $BR_EXTRA_DEFCONFIG ]; then
  	echo can\'t find the file $BR_EXTRA_DEFCONFIG
  	echo please fix this script
  	return;
  fi
  if [ ! -e $BR_EXTRA_POSTIMAGE ]; then
  	echo can\'t find the file $BR_EXTRA_POSTIMAGE
  	echo please fix this script
  	return;
  fi

  # generate the buildroot config file
  echo \#autogenerated do not edit, put changes in $BR_EXTRA_DEFCONFIG > $BR_NEW_DEFCONFIG
  cat $BR_STOCK_DEFCONFIG >> $BR_NEW_DEFCONFIG
  cat $BR_EXTRA_DEFCONFIG >> $BR_NEW_DEFCONFIG
  cat $BR_DEVICEMODE_DEFCONFIG >> $BR_NEW_DEFCONFIG

  # generate the post-image file
  echo "#!/bin/bash
#autogenerated do not edit, put changes in $BR_EXTRA_POSTIMAGE" > $BR_POSTIMAGE
  echo "set -e
mkdir -p \${BINARIES_DIR}/overlays
" >> $BR_POSTIMAGE
  cat $BR_STOCK_POSTIMAGE >> $BR_POSTIMAGE
  sed -i 's/^genimage/genimage -h /;s/exit/#exit/' $BR_POSTIMAGE
  cat $BR_EXTRA_DEVICEMODE_POSTIMAGE >> $BR_POSTIMAGE
  cat $BR_EXTRA_POSTIMAGE >> $BR_POSTIMAGE
  chmod u+x $BR_POSTIMAGE

  # generate the genimage file
  cat $BR_STOCK_GENIMAGE > $BR_GENIMAGE
  sed -i '/rpi-firmware\/overlays/d' $BR_GENIMAGE   # remove rpi-firmware/overlays if present
  sed -i '/\.dtb/d' $BR_GENIMAGE  # delete dtb list - it will be wildcarded
  sed -i 's/zImage"/Image",\
      "bcm2708-rpi-0-w.dtb",\
      "overlays"/' $BR_GENIMAGE  # add the kernel's overlays
       # sed -i '/"Image"/"Image",\
       #      "overlays"/' $BR_GENIMAGE  # add the kernel's overlays

  cd $1
  make BR2_EXTERNAL=$CUSTOM_PATH $BR_NEW_DEFCONFIG_FILE
fi