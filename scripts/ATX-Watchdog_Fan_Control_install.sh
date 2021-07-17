echo 'import smbus
import time
import signal
import sys
import os

# Configuration
WAIT_TIME = 1           # [s] Time to wait between each refresh

# Configurable temperature and fan speed
ATX_WATCHDOG_ADDRESS = 0x5A #I2C address
CHANGE_FAN_SPEED = 0x84     #Fan speed register
MIN_TEMP = 40
MAX_TEMP = 70
FAN_LOW = 40
FAN_HIGH = 100
FAN_OFF = 0
FAN_MAX = 100

# Get CPU'"'"'s temperature
def getCpuTemperature():
    res = os.popen('"'"vcgencmd measure_temp"'"').readline()
    temp = float((res.replace("temp=","").replace("'"'"'C\n","")))
#    print("temp is {0}".format(temp)) # Uncomment for testing
    return int(temp)

# Set fan speed
def setFanSpeed(speed):
    bus = smbus.SMBus(1)
    bus.write_byte_data(ATX_WATCHDOG_ADDRESS, CHANGE_FAN_SPEED, speed)
    bus.close()

    return()

# Handle fan speed
def handleFanSpeed():
    temp = getCpuTemperature()

    # Turn off the fan if temperature is below MIN_TEMP
    if temp < MIN_TEMP:
        setFanSpeed(FAN_OFF)
#        print("Fan OFF") # Uncomment for testing
    # Set fan speed to MAXIMUM if the temperature is above MAX_TEMP
    elif temp > MAX_TEMP:
        setFanSpeed(FAN_MAX)
#        print("Fan MAX") # Uncomment for testing
    # Caculate dynamic fan speed
    else:
        step = int((FAN_HIGH - FAN_LOW)/(MAX_TEMP - MIN_TEMP))
        temp -= MIN_TEMP
        setFanSpeed(FAN_LOW + (temp * step ))
#        print(FAN_LOW + ( temp * step )) # Uncomment for testing
    return ()

try:
    setFanSpeed(FAN_OFF)
    # Handle fan speed every WAIT_TIME sec
    while True:
        handleFanSpeed()
        time.sleep(WAIT_TIME)

except KeyboardInterrupt: # trap a CTRL+C keyboard interrupt
    setFanSpeed(FAN_HIGH)' > /usr/local/bin/ATX-Watchdog/ATX-Watchdog_fanControl.py
sudo chmod 755 /usr/local/bin/ATX-Watchdog/ATX-Watchdog_fanControl.py
sudo echo '[Unit]
Description=Start the fan contoller

[Service]
Type=simple
RemainAfterExit=true
Restart=on-failure
ExecStart=/usr/bin/python3 /usr/local/bin/ATX-Watchdog/ATX-Watchdog_fanControl.py

[Install]
WantedBy=multi-user.target
' > /etc/systemd/system/ATX-Watchdog_fanControl.service
sudo systemctl enable ATX-Watchdog_fanControl
sudo systemctl start ATX-Watchdog_fanControl





        
