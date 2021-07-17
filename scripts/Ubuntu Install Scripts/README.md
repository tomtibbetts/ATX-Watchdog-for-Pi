# ATX-Watchdog-for-Pi
## Ubuntu Install Scripts

The install scripts here are very similar to the install scripts for Raspbian.  The only difference
is that the services in these scripts call python3 instead of python.

Before running these scripts you will need to install additional items:
1. sudo apt install i2c-tools
1. sudo apt-get install python3-rpi.gpio
1. sudo apt install python3-smbus
1. sudo apt install libraspberrypi-bin

Next, you may need to adjust the Shutdown Delay (register 0x31) and Remote Shutdown Delay (register 0x32) in order to
allow plenty of time for the PI to properly shutdown from a command line reboot or shutdown.  I chose 15 seconds for
the Shutdown Delay and 60 seconds for the Remote Shutdown Delay.  Your mileage may vary.


