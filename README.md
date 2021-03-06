# Raspberry Pi buildroot system to make a smart USB sound card

A smart USB sound card is a USB sound card which provides other functionality, such as networking over USB. You can also alter your buildroot configuration to enable WiFi and add various other software, such as DLNA, shairPlay, etc. A network enabled USB sound card. NOTE: Some of these features require your own DIY efforts, however out of the box it provides the USB sound card and USB network.

# Hardware requirements

1. Raspberry Pi 0, probably a zero W
2. Sound card, probably an Audio Injector sound card ( [Audio Injector original Pi sound card](https://shop.audioinjector.net/detail/Sound_Cards/Original+Pi+Sound+Card) OR [Audio Injector zero sound card](https://shop.audioinjector.net/detail/Sound_Cards/Zero+Form+Factor+Sound+Card))
3. Either a set of 40 pin headers to connect the boards OR an [Audio Injector quick connect clip](https://shop.audioinjector.net/detail/DIY_Electronics/PCB+quick+connect+clip) if you like adaptability and don't want to solder.

# Initial setup

Clone buildroot. For example :

```
cd yourPath
git clone git://git.busybox.net/buildroot buildroot.raspberrypi
```

Make sure you have requirements :
```
sudo apt-get install -y build-essential gcc g++ autoconf automake libtool bison flex gettext
sudo apt-get install -y patch texinfo wget git gawk curl lzma bc quilt
```

Clone the RaspberryPi external buildroot tree :
```
git clone git@github.com:Audio-Injector/RaspberryPi.buildroot.external.git
```

# To make the system for the Audio Injector stereo or Zero sound cards

```
. RaspberryPi.buildroot.external/setup.sh yourPath/buildroot.raspberrypi
```

# To make the system for the Audio Injector ultra 2 sound card

```
. RaspberryPi.buildroot.external/setupUltra.sh yourPath/buildroot.raspberrypi
```

# ensure you have your buildroot net downloads directory setup

```
mkdir yourPath/buildroot.dl
```

# build the system

```
make
```

# installing

Insert your sdcard into your drive and make sure it isn't mounted. Write the image to the disk.

NOTE: The following command will overwrite any disk attached to /dev/sdg
NOTE: Be super careful here!

```
sudo dd if=output/images/sdcard.img of=/dev/sdg

```

# using

The device will show up automatically after boot as a USB audio device.
ssh root@10.5.5.1 to get into the sound card

Out of the box it is setup for a stereo 48 kHZ sample rate with 32 bit word sizes. You can alter its default state by editing the overlay/root/startGadget.sh file and then make, or edit the /root/startGedget.sh file on the device.
