---
title: Device Preparation
sidebar_label: Device Preparation
---

This document details how to prepare a Linux-based device for a BlackboxOS deployment.

The following sequence is followed to prepare a device for delivery. It is assumed that you have a Linux OS installed and configured with enough RAM or swap.

## Create the Defaults

- Change the hostname: `nano /etc/hostname`
- Create the default directory: `mkdir ~/.blackbox`
- Copy the blockchain data
  - `scp -r root@seedbox.local:~/.blackbox/data/pivx ~/.blackbox/data`
- Change the root password to `crypdex` default
  - `passwd`

## Install Required Software

### Docker

Install [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/) ant put it in swarm mode.

We could do this for you but want to be respectful of you system's environment. For some cloud servers you will need to give it an `--advertise-addr`

```shell
$ docker swarm init
```

### Dependencies

```
$ apt install -y htop iotop bmon avahi-daemon avahi-discover avahi-utils libnss-mdns mdns-scan
$ apt upgrade -y
```

### Optional but Recommended

Install Docker Compose

```
scp tools/docker-compose-Linux-aarch64 root@crypdex.local:/usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

## Customer Delivery Considerations

- Remove the Portainer directory
  - `rm -rf ~/.blackbox/data/portainer`
- Remove the blockchain conf (it will be regenerated)
  - `rm -rf ~/.blackbox/data/pivx/pivx.conf`
- Change the hostname to match the serial.

## Platform Specific Notes

### Odroid C2

- Install the [image](https://wiki.odroid.com/odroid-c2/os_images/ubuntu/ubuntu) from Odroid. Armbian does not work as well.
- Swap must be enabled.
