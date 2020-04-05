# Raspberry Pi buildroot system to make a networked home micro battery

A networked home battery allows many networked batteries to augment a house's power.

Get a top view of the project here : https://imgur.com/a/hNvbikY

# Hardware requirements

1. Raspberry Pi
2. [BatteryController.electronics](https://github.com/flatmax/BatteryController.electronics) to turn on and off chargers and solar micro inverters
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

Checkout the home battery branch (by default master is the [Audio Injector sound card](http://www.audioinjector.net) branch)
```
cd RaspberryPi.buildroot.external
git checkout BatteryController
```
# To make the system for the micro battery hardware

```
. RaspberryPi.buildroot.external/setupMicroBattery.sh yourPath/buildroot.raspberrypi
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

The device will show up automatically after boot as a networked battery.
ssh root@10.5.5.1 to get into the sound card - note your host IP will be different to "10.5.5.1" on your LAN, look at your router DNS records to find the buildroot system.

The master battery holds the logs, which list run level and power stats roughly every 10 seconds.

Out of the box it is setup to detect whether it is a master or slave from the GPIO settings. Look at the [init.d script](https://github.com/Audio-Injector/RaspberryPi.buildroot.external/blob/BatteryController/package/batterycontroller/S60HardwareServer) to understand how the system is started up.

If you write your own battery controller which uses a different power meter for probing consumption/production then create the required scripts in the [BatteryController software repo](https://github.com/flatmax/BatteryController) and name it in the startup script rather then the BatteryControllerEnvoyMeterNet.js script.
