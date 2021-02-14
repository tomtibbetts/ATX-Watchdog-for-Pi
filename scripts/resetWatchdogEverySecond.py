#!/usr/bin/python

import smbus
import time



DEVICE_ADDRESS = 0x5A

while 1:
    print("Resetting Watchdog")
    bus = smbus.SMBus(1)
    bus.write_byte_data(DEVICE_ADDRESS, 0x82, 0)
    bus.close()
    time.sleep(100)
    
    


