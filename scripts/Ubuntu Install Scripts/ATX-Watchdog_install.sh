sudo mkdir /usr/local/bin/ATX-Watchdog
echo 'import RPi.GPIO as GPIO
import os
import sys
import smbus
import time

GPIO.setmode(GPIO.BCM)

pulseStart = 0.0
SHUTDOWN = 24               #pin 18
ATX_WATCHDOG_ADDRESS = 0x5A #I2C address
BOOT_OK_COMMAND = 0x83      #Set Boot Ok process
BOOT_OK = 0x01              #Signal that we booted up okay
REBOOTPULSEMINIMUM = 0.2    #reboot pulse signal should be at least this long
REBOOTPULSEMAXIMUM = 0.6    #reboot pulse signal should be at most this long

print ("\n=====================================\n")
print ("== ATX-PSU_startup: Initializing GPIO")
GPIO.setup(SHUTDOWN, GPIO.IN, pull_up_down = GPIO.PUD_DOWN)

try:
    print ("\n== Signalling Boot Ok\n")
    bus = smbus.SMBus(1)
    time.sleep(0.1)
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
' > /usr/local/bin/ATX-Watchdog/ATX-Watchdog_startup.py
sudo chmod 755 /usr/local/bin/ATX-Watchdog/ATX-Watchdog_startup.py
echo 'import smbus
import time

ATX_WATCHDOG_ADDRESS = 0x5A #I2C address
BOOT_OK_COMMAND = 0x83      #Set Boot Ok process
BOOT_NOT_OK = 0x00          #Signal that we are shutting down

bus = smbus.SMBus(1)
time.sleep(0.1)
bus.write_byte_data(ATX_WATCHDOG_ADDRESS, BOOT_OK_COMMAND, BOOT_NOT_OK)
bus.close()
' > /usr/local/bin/ATX-Watchdog/ATX-Watchdog_shutdown.py
sudo chmod 755 /usr/local/bin/ATX-Watchdog/ATX-Watchdog_shutdown.py
sudo echo '[Unit]
Description=ATX-Watchdog Shut Down

[Service]
Type=oneshot
RemainAfterExit=true
Restart=on-failure
ExecStop=/usr/bin/python3 /usr/local/bin/ATX-Watchdog/ATX-Watchdog_shutdown.py

[Install]
WantedBy=multi-user.target
' > /etc/systemd/system/ATX-Watchdog_shutdown.service
sudo echo '[Unit]
Description=ATX-Watchdog Start up

[Service]
Type=simple
RemainAfterExit=true
Restart=on-failure
ExecStart=/usr/bin/python3 /usr/local/bin/ATX-Watchdog/ATX-Watchdog_startup.py

[Install]
WantedBy=multi-user.target
' > /etc/systemd/system/ATX-Watchdog_startup.service
sudo systemctl enable ATX-Watchdog_shutdown
sudo systemctl start ATX-Watchdog_shutdown
sudo systemctl enable ATX-Watchdog_startup
sudo systemctl start ATX-Watchdog_startup





        
