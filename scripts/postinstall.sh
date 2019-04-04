#!/usr/bin/env bash
echo "enabling the systemd service"
#cp /var/lib/blackbox/blackbox.service /etc/systemd/system/blackbox.service
deb-systemd-invoke enable blackbox.service
deb-systemd-helper daemon-reload
deb-systemd-invoke start blackbox.service