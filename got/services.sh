#!/bin/bash

# Low battery service
sudo touch /etc/systemd/system/low_battery.service
sudo echo "[Unit]
Description=Low battery service... W-we are sinking?
After=multi-user.target

[Service]
ExecStart=/bin/bash $HOME/.i3/low_battery.sh

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/low_battery.service


sudo systemctl daemon-reload
sudo systemctl enable low_battery.service
sudo systemctl reboot
