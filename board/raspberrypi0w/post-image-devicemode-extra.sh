
if grep -q dwc2 ${BINARIES_DIR}/rpi-firmware/config.txt; then
  echo dwc2 already setup
else
  echo 'dtoverlay=dwc2' >> ${BINARIES_DIR}/rpi-firmware/config.txt
fi
