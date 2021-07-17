echo 'import smbus
import time

ATX_WATCHDOG_ADDRESS = 0x5A #I2C address
WATCHDOG_KEEP_ALIVE = 0x82  #Ping ATX Watchdog command

while 1:
    bus = smbus.SMBus(1)
    bus.write_byte_data(ATX_WATCHDOG_ADDRESS, WATCHDOG_KEEP_ALIVE, 0x00)
    bus.close()
    time.sleep(30)
' > /usr/local/bin/ATX-Watchdog/ATX-Watchdog_keepAlive.py
sudo chmod 755 /usr/local/bin/ATX-Watchdog/ATX-Watchdog_keepAlive.py
sudo echo '[Unit]
Description=Signal the ATX-Watchdog keep alive

[Service]
Type=simple
RemainAfterExit=true
Restart=on-failure
ExecStart=/usr/bin/python3 /usr/local/bin/ATX-Watchdog/ATX-Watchdog_keepAlive.py

[Install]
WantedBy=multi-user.target
' > /etc/systemd/system/ATX-Watchdog_keepAlive.service
sudo systemctl enable ATX-Watchdog_keepAlive
sudo systemctl start ATX-Watchdog_keepAlive





        
