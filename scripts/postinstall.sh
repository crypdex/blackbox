#!/usr/bin/env bash
echo "enabling the systemd service"
cp /var/lib/blackbox/blackbox.service /etc/systemd/system/blackbox.service
#systemctl enable /etc/systemd/system/blackbox.service
#systemctl daemon-reload
#systemctl start blackbox.service