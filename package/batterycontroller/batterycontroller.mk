################################################################################
#
# BATTERYCONTROLLER
#
################################################################################
BATTERYCONTROLLER_VERSION = HEAD
#BATTERYCONTROLLER_SITE = $(call github,flatmax,gtkiostream,$(BATTERYCONTROLLER_VERSION))
BATTERYCONTROLLER_SITE = /home/flatmax/flatmax/work/Flatmax/repos/BatteryMicroInverter/BatteryController
BATTERYCONTROLLER_SITE_METHOD = local
BATTERYCONTROLLER_LICENSE = free
BATTERYCONTROLLER_INSTALL_TARGET = YES
BATTERYCONTROLLER_DEPENDENCIES = nodejs

define BATTERYCONTROLLER_INSTALL_TARGET_CMDS
  $(INSTALL) -d $(TARGET_DIR)/usr/share/BatteryController/src
  $(INSTALL) -d $(TARGET_DIR)/usr/share/BatteryController/src/bash
  $(INSTALL) -D -m 0644 $(@D)/src/*.js $(TARGET_DIR)/usr/share/BatteryController/
  $(INSTALL) -D -m 0744 $(@D)/src/bash/*.sh $(TARGET_DIR)/usr/share/BatteryController/bash
  $(INSTALL) -D -m 0644 $(@D)/src/*.json $(TARGET_DIR)/usr/share/BatteryController/
  $(INSTALL) -D -m 0755 $(@D)/src/BatteryController*.js $(TARGET_DIR)/usr/share/BatteryController/
  $(INSTALL) -D -m 0755 $(@D)/src/HardwareServer.js $(TARGET_DIR)/usr/share/BatteryController/
endef

define BATTERYCONTROLLER_INSTALL_INIT_SYSV
  $(INSTALL) -D -m 755 $(BATTERYCONTROLLER_PKGDIR)/S60HardwareServer $(TARGET_DIR)/etc/init.d/S60HardwareServer
  $(INSTALL) -D -m 755 $(BATTERYCONTROLLER_PKGDIR)/runBatteryController.sh $(TARGET_DIR)/root/runBatteryController.sh
endef

$(eval $(generic-package))
