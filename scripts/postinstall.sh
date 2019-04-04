#!/usr/bin/env bash
echo "[postinstall] Enabling the systemd service"
#cp /var/lib/blackbox/blackbox.service /etc/systemd/system/blackbox.service
deb-systemd-invoke enable blackbox.service
deb-systemd-helper daemon-reload

echo "[postinstall] Cleaning up Docker ..."
blackbox cleanup
sleep 1

echo "[postinstall] Starting the systemd service ..."
deb-systemd-invoke start blackbox.service

sleep 5
blackbox start