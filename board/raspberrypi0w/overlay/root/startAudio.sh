#!/bin/sh
# Copyright (C) 2019 Flatmax Pty. Ltd. Audio Injector

echo restoring mixer settings
alsactl restore

FS=`cat /config/usb_gadget/g1/functions/uac2.0/c_srate`
CCNT=`cat /config/usb_gadget/g1/functions/uac2.0/c_chmask`
FORMAT=`cat /config/usb_gadget/g1/functions/uac2.0/c_ssize`

echo starting UAC2 audio pipe

case "$CCNT" in
        "3")
            CCNT=2
            ;;
        *)
            echo unknown channel mask $CCNT
            exit 1
esac

case "$FORMAT" in
      "4")
          FORMAT=S32_LE
          ;;
      "3")
          FORMAT=S24_LE
          ;;
      "2")
          FORMAT=S16_LE
          ;;
      *)
          echo unknown format $FORMAT bytes
          exit 1
esac

gadgetDevice=`cat /proc/asound/cards | grep adget | grep \: | awk '{print $1}'`
physicalDevice=`cat /proc/asound/cards | grep udio | grep \: | awk '{print $1}'`

if [ -z "$gadgetDevice" ]; then
  echo couldn\'t find the gadget audio device.
  echo Known cards :
  cat /proc/asound/cards
  exit 1
fi

if [ -z "$physicalDevice" ]; then
  echo couldn\'t find the physical audio device.
  echo Known cards :
  cat /proc/asound/cards
  exit 1
fi

echo starting the audio pipe with the following properties :
echo UAC2 gadget  : device $gadgetDevice
echo physical dev : device $physicalDevice
echo sample rate  : $FS Hz
echo channel cnt  : $CCNT
echo format       : $FORMAT

arecord -D hw:$gadgetDevice -N -c $CCNT -r $FS -f $FORMAT | aplay -D hw:$physicalDevice -N  -c $CCNT -r $FS -f $FORMAT &
