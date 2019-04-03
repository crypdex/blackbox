#!/usr/bin/env bash

systemctl enable /etc/systemd/system/blackbox.service
systemctl start blackbox.service