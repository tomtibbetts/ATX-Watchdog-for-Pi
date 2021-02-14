#!/usr/bin/python

import smbus
import time

bus = smbus.SMBus(1)


DEVICE_ADDRESS = 0x5A
bus.write_byte_data(DEVICE_ADDRESS, 0x34, 0x00)
bus.close()


