#!/usr/bin/python

import smbus
import time

ATX_WATCHDOG_ADDRESS = 0x5A        #I2C address
WATCHDOG_ENABLE_COMMAND = 0x35     #Access the watchdog Register
WATCHDOG_DISABLE = 0x00            #Disable the watchdog, reset the reboot counter

bus = smbus.SMBus(1)

bus.write_byte_data(ATX_WATCHDOG_ADDRESS, WATCHDOG_ENABLE_COMMAND, WATCHDOG_DISABLE)
bus.close()


