#!/usr/bin/env bash
echo "[postinstall] Enabling the admin systemd service"

deb-systemd-invoke enable blackbox-admin.service

echo "[postinstall] Enabling the systemd service"

deb-systemd-invoke enable blackbox.service

deb-systemd-helper daemon-reload

echo "[postinstall] Starting the services ..."

deb-systemd-invoke start blackbox-admin.service
deb-systemd-invoke start blackbox.service

echo "[postinstall] Cleaning up Docker ..."
blackboxd cleanup

#sleep 5
#
#blackboxd start

#echo "[postinstall] Starting the admin systemd service"
#deb-systemd-invoke restart blackbox-admin.service


