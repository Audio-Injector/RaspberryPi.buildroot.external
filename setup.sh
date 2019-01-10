#! /bin/bash
# Author : Matt Flax <flatmax@flatmax.org>
# Date : Nov 2017

if [ $# -lt 1 ]; then
  echo usage :
  me=`basename "$0"`
  echo "     " $me path.to.buildroot.raspberrypi
else
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

  CUSTOM_PATH=$DIR
  BR_REPO_PATH=$1

  # pi3 64 bit
  BR_STOCK_DEFCONFIG=$BR_REPO_PATH/configs/raspberrypi3_64_defconfig
  BR_NEW_DEFCONFIG_FILE=raspberrypi3_64_ai_defconfig
  BR_STOCK_POSTIMAGE=$BR_REPO_PATH/board/raspberrypi3-64/post-image.sh
  BR_EXTRA_POSTIMAGE=$CUSTOM_PATH/board/raspberrypi3-64/post-image-extra.sh
  BR_STOCK_GENIMAGE=$BR_REPO_PATH/board/raspberrypi3-64/genimage-raspberrypi3-64.cfg

  # pi3 32 bit
  BR_STOCK_DEFCONFIG=$BR_REPO_PATH/configs/raspberrypi3_defconfig
  BR_NEW_DEFCONFIG_FILE=raspberrypi3_32_ai_defconfig
  BR_STOCK_POSTIMAGE=$BR_REPO_PATH/board/raspberrypi3/post-image.sh
  BR_EXTRA_POSTIMAGE=$CUSTOM_PATH/board/raspberrypi3/post-image-extra.sh
  BR_STOCK_GENIMAGE=$BR_REPO_PATH/board/raspberrypi3/genimage-raspberrypi3.cfg

  # common target genimage file
  BR_NEW_DEFCONFIG=$CUSTOM_PATH/configs/$BR_NEW_DEFCONFIG_FILE
  BR_EXTRA_DEFCONFIG=$CUSTOM_PATH/configs/raspberrypi_ai_defconfig
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

  # generate the post-image file
  echo "#!/bin/bash
#autogenerated do not edit, put changes in $BR_EXTRA_POSTIMAGE" > $BR_POSTIMAGE
  echo "set -e
mkdir -p \${BINARIES_DIR}/overlays
" >> $BR_POSTIMAGE
  cat $BR_STOCK_POSTIMAGE >> $BR_POSTIMAGE
  sed -i 's/^genimage/genimage -h /;s/exit/#exit/' $BR_POSTIMAGE
  cat $BR_EXTRA_POSTIMAGE >> $BR_POSTIMAGE
  chmod u+x $BR_POSTIMAGE

  # generate the genimage file
  cat $BR_STOCK_GENIMAGE > $BR_GENIMAGE
  sed -i '/rpi-firmware\/overlays/d' $BR_GENIMAGE   # remove rpi-firmware/overlays if present
  sed -i 's/zImage"/Image",\
      "overlays"/' $BR_GENIMAGE  # add the kernel's overlays
       # sed -i '/"Image"/"Image",\
       #      "overlays"/' $BR_GENIMAGE  # add the kernel's overlays

  cd $1
  make BR2_EXTERNAL=$CUSTOM_PATH $BR_NEW_DEFCONFIG_FILE
fi
