#!/usr/bin/env bash
echo "[postinstall] Enabling the admmin systemd service"

deb-systemd-invoke enable blackbox-admin.service
deb-systemd-helper daemon-reload

echo "[postinstall] Cleaning up Docker ..."
blackboxd cleanup

#sleep 5
#
#blackboxd start

echo "[postinstall] Starting the admin systemd service"
deb-systemd-invoke start blackbox-admin.service


