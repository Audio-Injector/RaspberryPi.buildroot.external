
if grep -q audioinjector ${BINARIES_DIR}/rpi-firmware/config.txt; then
  echo audioinjector already setup
else
  echo 'dtoverlay=audioinjector-wm8731-audio' >> ${BINARIES_DIR}/rpi-firmware/config.txt
fi

if grep -q enable_uart ${BINARIES_DIR}/rpi-firmware/config.txt; then
  echo uart already setup
else
  echo 'enable_uart=1' >> ${BINARIES_DIR}/rpi-firmware/config.txt
fi

sed -i 's/zImage/Image/' ${BINARIES_DIR}/rpi-firmware/config.txt

# for 64bit v8 cores
# if grep -q arm_control ${BINARIES_DIR}/rpi-firmware/config.txt; then
#   echo arm_control already setup
# else
#   echo 'arm_control=0x200' >> ${BINARIES_DIR}/rpi-firmware/config.txt
# fi

echo gather dtbo files
DTBO_FILES=`find ${BUILD_DIR} -type f -name '*.dtbo' | grep dts`
mkdir -p ${BINARIES_DIR}/overlays
cp $DTBO_FILES ${BINARIES_DIR}/overlays

GENIMAGE_CFG=${BUILD_DIR}/genimage-pi.cfg
echo genimage 2
rm -rf "${GENIMAGE_TMP}"
genimage                           \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

exit $?
