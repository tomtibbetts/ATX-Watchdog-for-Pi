echo 'import RPi.GPIO as GPIO
import os
import sys
import symbus
import time

GPIO.setmode(GPIO.BCM)

pulseStart = 0.0
SHUTDOWN = 24               #pin 18
ATX_WATCHDOG_ADDRESS = 0x5A	#I2C address
BOOT_OK_COMMAND = 0x83		#Set Boot Ok process
BOOT_OK = 0x01				#Signal that we booted up okay
REBOOTPULSEMINIMUM = 0.2    #reboot pulse signal should be at least this long
REBOOTPULSEMAXIMUM = 0.6    #reboot pulse signal should be at most this long

print ("\n=====================================\n")
print ("== ATX-PSU_startup: Initializing GPIO")
GPIO.setup(SHUTDOWN, GPIO.IN, pull_up_down = GPIO.PUD_DOWN)

try:
    print ("\n== Signalling Boot Ok\n")
	bus = smbus.SMBus(1)
	bus.write_byte_data(ATX_WATCHDOG_ADDRESS, BOOT_OK_COMMAND, BOOT_OK)
	bus.close()
	
    while True:
        print ("\n== Waiting for shutdown pulse\n")
        GPIO.wait_for_edge(SHUTDOWN, GPIO.RISING)

        print ("\nshutdown pulse received\n")
        pulseValue = GPIO.input(SHUTDOWN)
        pulseStart = time.time()

        pinResult = GPIO.wait_for_edge(SHUTDOWN, GPIO.FALLING, timeout = 600)

        if pinResult == None:
            os.system("sudo poweroff")
            sys.exit()
        elif time.time() - pulseStart >= REBOOTPULSEMINIMUM:
            os.system("sudo reboot")
            sys.exit()

        if GPIO.input(SHUTDOWN):
            GPIO.wait_for_edge(SHUTDOWN, GPIO.FALLING)

except:
    pass
finally:
    GPIO.cleanup()
' > /etc/ATX-Watchdog_startup
sudo chmod 755 /etc/ATX-Watchdog_startup.py
sudo sed -i '$ i python /etc/ATX-Watchdog_startup.py &' /etc/rc.local
echo '#!/usr/bin/python

import smbus

ATX_WATCHDOG_ADDRESS = 0x5A	#I2C address
BOOT_OK_COMMAND = 0x83		#Set Boot Ok process
BOOT_NOT_OK = 0x00			#Signal that we are shutting down

bus = smbus.SMBus(1)
bus.write_byte_data(ATX_WATCHDOG_ADDRESS, BOOT_OK_COMMAND, BOOT_NOT_OK)
bus.close()
' > /usr/lib/systemd/ATX-Watchdog_shutdown.py
echo '[Unit]
Description=Signal the ATX-Watchdog that we are shutting down

[Service]
Type=oneshot
RemainAfterExit=true
ExecStop=/usr/lib/systemd/ATX-Watchdog_shutdown.py

[Install]
WantedBy=multi-user.target
' > /etc/systemd/system/ATX-Watchdog_shutdown.service
sudo systemctl start ATX-Watchdog_shutdown
sudo systemctl enable ATX-Watchdog_shutdown





        
