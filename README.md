# Raspberry Pi buildroot system

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

# To make the system

```
. RaspberryPi.buildroot.external/setup.sh yourPath/buildroot.raspberrypi
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

ssh root@host where host is the raspberrypi
