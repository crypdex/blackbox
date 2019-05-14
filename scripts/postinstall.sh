#!/usr/bin/env bash

# This script is executed by the deb package post-install

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


