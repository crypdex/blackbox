#!/usr/bin/env bash

deb-systemd-invoke stop blackbox.service
deb-systemd-invoke disable blackbox.service
rm /etc/systemd/system/blackbox.service