# put the following in /etc/inittab to make this work
## battery controller
#::respawn:/root/runBatteryController.sh

echo `date` restarting >> /root/BatteryController.txt
cd /usr/share/BatteryController; NODE_PATH=/usr/lib/node_modules ./BatteryControllerEnvoyMeterNet.js
