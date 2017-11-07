#!/bin/bash

sudo cp avahi/mpdSync.service /etc/avahi/services/mpdSync.service
sudo cp systemd/mpdSync.service /usr/lib/systemd/system/mpdSync.service
sudo systemctl daemon-reload
sudo systemctl restart mpdSync
#sudo systemctl enable mpdSync
#sudo systemctl status mpdSync
sudo systemctl restart avahi-daemon.service
