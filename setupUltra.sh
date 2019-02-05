#! /bin/bash
# setup file for Audio Injector Ultra 2 sound card

# generate the standard setup
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
. $DIR/setup.sh $1
cd $DIR
# alter post script args
BR2_ROOTFS_POST_SCRIPT_ARGS=`grep BR2_ROOTFS_POST_SCRIPT_ARGS $BR_NEW_DEFCONFIG | sed 's/BR2_ROOTFS_POST_SCRIPT_ARGS\=//;s/\"//g'`
BR2_ROOTFS_POST_SCRIPT_ARGS+=' --audio-injector-ultra2'
sed -i "s/BR2_ROOTFS_POST_SCRIPT_ARGS=.*$/BR2_ROOTFS_POST_SCRIPT_ARGS=\"$BR2_ROOTFS_POST_SCRIPT_ARGS\"/" $BR_NEW_DEFCONFIG

cd $1
make BR2_EXTERNAL=$CUSTOM_PATH $BR_NEW_DEFCONFIG_FILE
