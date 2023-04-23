#!/bin/bash

# Low battery service
sudo touch /etc/systemd/system/low_battery.service
sudo echo "[Unit]
Description=Low battery... W-we are sinking?

[Service]
Type=simple
User=$USER
ExecStart=/bin/bash $HOME/.i3/low_battery.sh

[Install]
WantedBy=default.target
" > /etc/systemd/system/low_battery.service


sudo systemctl daemon-reload
sudo systemctl enable low_battery.service
sudo systemctl reboot
