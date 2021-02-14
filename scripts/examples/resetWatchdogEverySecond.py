#!/usr/bin/python

import smbus
import time

ATX_WATCHDOG_ADDRESS = 0x5A #I2C address
WATCHDOG_KEEP_ALIVE = 0x82  #Ping ATX Watchdog command

while 1:
    print("Resetting Watchdog")
    bus = smbus.SMBus(1)
    bus.write_byte_data(ATX_WATCHDOG_ADDRESS, WATCHDOG_KEEP_ALIVE, 0)
    bus.close()
    time.sleep(100)
    
    


