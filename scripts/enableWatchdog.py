#!/usr/bin/python

import smbus
import time

ATX_WATCHDOG_ADDRESS = 0x5A        #I2C address
WATCHDOG_ENABLE_COMMAND = 0x35     #Access the watchdog Register
WATCHDOG_ENABLE = 0x82             #Enable the watchdog, Reboot up to two times

bus = smbus.SMBus(1)

bus.write_byte_data(ATX_WATCHDOG_ADDRESS, WATCHDOG_ENABLE_COMMAND, WATCHDOG_ENABLE)
bus.close()


