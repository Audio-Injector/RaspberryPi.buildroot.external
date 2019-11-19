#! /bin/bash
# setup file for Audio Injector Ultra 2 sound card

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
BR_EXTRA_DEFCONFIG=$DIR/configs/raspberrypi_batterycontroller_defconfig

# generate the standard setup
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
. $DIR/setup.sh $1
cd $DIR

cd $1
make BR2_EXTERNAL=$CUSTOM_PATH $BR_NEW_DEFCONFIG_FILE
