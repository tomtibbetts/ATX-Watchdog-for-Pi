#!/usr/bin/python

import smbus

ATX_WATCHDOG_ADDRESS = 0x5A #I2C address
BOOT_OK_COMMAND = 0x83      #Set Boot Ok process
BOOT_OK = 0x01              #Signal that we are shutting down


bus = smbus.SMBus(1)

bus.write_byte_data(ATX_WATCHDOG_ADDRESS, BOOT_OK_COMMAND, BOOT_OK)
bus.close()

