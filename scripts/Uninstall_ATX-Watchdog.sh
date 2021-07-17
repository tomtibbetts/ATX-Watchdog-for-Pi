sudo rm -r /usr/local/bin/ATX-Watchdog
sudo rm /etc/systemd/system/ATX-Watchdog*.*
sudo systemctl stop /etc/systemd/system/ATX-Watchdog_startup.service
sudo systemctl stop /etc/systemd/system/ATX-Watchdog_shutdown.service
sudo systemctl disable /etc/systemd/system/ATX-Watchdog_startup.service
sudo systemctl disable /etc/systemd/system/ATX-Watchdog_shutdown.service
