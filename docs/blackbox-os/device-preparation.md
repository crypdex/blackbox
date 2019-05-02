---
title: Device Preparation
sidebar_label: Device Preparation
---

This guide shows how to prepare an ARM64-based Linux device for the BlackboxOS. If you know your way around a command line, it should be fairly straighforward.

In addition to some general Linux housekeeping and setup, you will be installing these things

- Docker
- `blackboxd`


The following sequence is followed to prepare a device for delivery. It is assumed that you have a Linux OS installed and configured with enough RAM or swap. Armbian is a good place to start as it has zram already allocated.

If you have an OS flashed that needs a swap disk setup, try this

```bash
# Creates a swapfile and adds it to fstab

fallocate -l 2G /swapfile && \
chmod 600 /swapfile && \
mkswap /swapfile && \
swapon /swapfile && \
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab && \
swapon --show
```

## Create the Defaults

- Change the root password to `crypdex` default
  - `passwd`
- Change the hostname: `nano /etc/hostname`
- Create the default directory: `mkdir ~/.blackbox`

## Install Required Software

### Add APT sources
<!--DOCUSAURUS_CODE_TABS-->
<!--arm64-->


```bash
# DOCKER

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
apt-key fingerprint 0EBFCD88 && \
add-apt-repository \
   "deb [arch=arm64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   
# BLACKBOX

echo "deb [trusted=yes] https://apt.fury.io/crypdex/ /" >> /etc/apt/sources.list.d/fury.list
```

<!--x86_64-->

```bash
# DOCKER

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
apt-key fingerprint 0EBFCD88 && \
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   
# BLACKBOX

echo "deb [trusted=yes] https://apt.fury.io/crypdex/ /" >> /etc/apt/sources.list.d/fury.list
```


<!--END_DOCUSAURUS_CODE_TABS-->


### Install Packages

```bash
# Docker, then Avahi and utils
apt-get update && \
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common \
htop iotop bmon avahi-daemon avahi-discover avahi-utils libnss-mdns mdns-scan \
blackboxd && \
apt-get upgrade -y
```

Finally, lets get Docker into swarm mode

```shell
docker swarm init
```


Now is a good time to 

```bash
reboot
```


### Optional but Recommended

Install Docker Compose

```
scp tools/docker-compose-Linux-aarch64 root@crypdex.local:/usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

## Seed Data

- Copy the blockchain data
```bash
scp -r root@seedbox.local:~/.blackbox/data/pivx ~/.blackbox/data
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
