#!/usr/bin/python

import smbus


bus = smbus.SMBus(1)


DEVICE_ADDRESS = 0x5A
bus.write_byte_data(DEVICE_ADDRESS, 0x83, 1)
bus.close()

