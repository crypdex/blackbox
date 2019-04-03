#!/usr/bin/env bash

systemctl enable /etc/systemd/system/blackbox.service
systemctl daemon-reload
systemctl start blackbox.service