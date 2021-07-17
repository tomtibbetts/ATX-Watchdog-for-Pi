sudo systemctl stop ATX-Watchdog_startup
sudo systemctl stop ATX-Watchdog_shutdown
sudo systemctl disable ATX-Watchdog_startup
sudo systemctl disable ATX-Watchdog_shutdown
sudo rm /etc/systemd/system/ATX-Watchdog*.*
sudo rm -r /usr/local/bin/ATX-Watchdog

