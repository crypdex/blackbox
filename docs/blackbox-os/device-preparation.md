---
title: Device Preparation
sidebar_label: Device Preparation
---

This guide focuses on the preparation of ARM64-based Linux devices for the BlackboxOS, though it should also be relevant for x86 machines. If you know your way around a command line, it should be fairly straighforward.

In addition to some general Linux housekeeping and setup, you will be installing these things

- Docker
- Docker Compose
- Blackbox


## The Basics


The following sequence is followed to prepare a device for delivery. It is assumed that you have a Linux OS installed and configured with enough RAM or swap. Armbian is a good place to start as it has zram already allocated.

### Swap

Many SBCs do not have enough RAM to run blockchain applications reliably. Even boards with 2GB RAM still need some overhead to keep processes from running out of memory. Enabling a swap disk can prevent applications from running out of memory at the expense of performance and disk longevity since it will use the storage volume to offload the contents of RAM.

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

## Software Installation

### System Software

We need to install some required software in order to continue setup. Among the packages are:

- System utilties for monitoring
- Avahi zeroconf libs for discoverability
- Python build tooling for Docker Compose

```bash
# Install requirements
apt update && apt install -y \
# APT tooling
apt-transport-https ca-certificates curl gnupg-agent software-properties-common \
# System utilities
htop iotop bmon \
# Zeroconf
avahi-daemon avahi-discover avahi-utils libnss-mdns mdns-scan \
# Needed to install Docker Compose
python python-pip python-setuptools python-dev libffi-dev
```


### APT Sources

We now need to add a couple of additional package sources so that APT can find all the software we need. These are added after the primary installations because they rely on software installed during that step.

<!--DOCUSAURUS_CODE_TABS-->
<!--arm64-->

```bash
# DOCKER (Debian)
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
apt-key fingerprint 0EBFCD88 && \
add-apt-repository \
   "deb [arch=arm64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable" && \
# BLACKBOX
echo "deb [trusted=yes] https://apt.fury.io/crypdex/ /" >> /etc/apt/sources.list.d/fury.list
```

<!--x86_64-->

```bash
# DOCKER (Debian)
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
apt-key fingerprint 0EBFCD88 && \
add-apt-repository \
   "deb [arch=arm64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable" && \
# BLACKBOX
echo "deb [trusted=yes] https://apt.fury.io/crypdex/ /" >> /etc/apt/sources.list.d/fury.list
```

<!--END_DOCUSAURUS_CODE_TABS-->




### Install Packages

Finally we are ready to install the softare that runs Blackbox

```bash
# Docker and Blacboxd
apt update && \
apt install -y docker-ce docker-ce-cli containerd.io blackboxd && \
pip install wheel docker-compose
```

Now is a good time to

```bash
reboot
```


## Mount Disk

One strategy for maintaining system and data sanity is to keep the blockchain data on a separate disk from the operating system. This allows for smaller cloneable discs to be used to format the OS and isolates potential disk failures from affecting wallets and chaindata.

Digital Ocean has a great tutorial on this which I will link to rather than copy here.

https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux


## Seed Data

Dependent upon the speed of you system overall, you may choose to pre-seed your data. For small SBCs using eMMC or microSD cards (yikes) chain sync may take a very very long time.

`blackboxd` expects that data is stored at `~/.blackbox/data/${service-name}`. You may change this using `DATA_DIR=` set in your shell or stored in `~/.env`

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
