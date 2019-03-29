<img src="https://raw.githubusercontent.com/crypdex/blackbox/master/resources/images/logo-black.png" width=300>

This repository contains code and instructions for the deployment of Crypdex local systems. It may likely also be used for hosted deployments as well.

<hr />
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Migrating](#migrating)
    - [Pre-release to 0.0.x](#pre-release-to-00x)
- [Summary](#summary)
- [<a name="prepare"></a>Prepare the Device](#a-nameprepareaprepare-the-device)
  - [1. Make directories and update the system](#1-make-directories-and-update-the-system)
  - [2. <a name="configure-ssh"></a>Copy default files](#2-a-nameconfigure-sshacopy-default-files)
    - [A note about Docker Compose](#a-note-about-docker-compose)
    - [(OPTONAL) Build docker-compose for arm4 from your Mac](#optonal-build-docker-compose-for-arm4-from-your-mac)
  - [3. Copy the blockchain](#3-copy-the-blockchain)
  - [4. Login to the Device](#4-login-to-the-device)
    - [Clone this Repo](#clone-this-repo)
- [Bootstrap the App](#bootstrap-the-app)
  - [Add configuration](#add-configuration)
  - [Install Docker](#install-docker)
  - [Install a swapfile](#install-a-swapfile)
  - [Copy necessary files](#copy-necessary-files)
  - [Boot the system manually to test](#boot-the-system-manually-to-test)
- [Finalizing for Customer Delivery](#finalizing-for-customer-delivery)
- [References](#references)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

<hr />

# Migrating

### Pre-release => 0.0.x

The `0.0.x` releases have the following changes.
- Use of a `.env` file at the root instead of `.blackbox.env` for default configurations.
- Update mechanism that uses tagged git commits allowing for user-controlled updates.
- This repo is now public and does not require a deploy key  
- The file `.encryption_key` is no longer used. Owner's password encrypts everything.
- Removed manual file copies
    - `.conf` files for chains are generated on first run.
    - `walletnotify.sh` is generated at first run for defined chains.

NOTE: There is only one device in pre-release state besides those in the studio. It is probable that you do not need to migrate anything.

```bash
export TAG=v0.0.x

# Remove the existing system
rm -rf blackbox
git clone https://github.com/crypdex/blackbox.git && cd blackbox

# Set the needed env vars and checkout the latest tag
echo "CHAINS=pivx" >> .env 
git checkout $TAG

make update
```


# Summary

1. Flash the SD card with the [manufacturer provided Ubuntu minimal image](https://wiki.odroid.com/odroid-c2/os_images/ubuntu/v3.0) for Odroid C2. This can be done with Etcher. Images are maintained on Google Drive: `Technology > Black Box Images`
1. [Prepare the device](#prepare)
1. [Configure](#configure-ssh)
1. Clone the [blackbox repository](https://github.com/crypdex/blackbox).

You will

Regardless of the deployent environment, the following setup should be followed to assure that the box can get this repository and update itself.

The update strategy is a simple `git pull`, but to do so on a private repository (like this one), requires that this repository has a common "deploy key" set, which it does.

**If you remove the deploy key or rename the repo then remote updates will break.** There currently is no strategy for rotating the deploy keys on remote machines.

# <a name="prepare"></a>Prepare the Device

SSH into the device as root and prepare it

- Make directories
- Install [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
- Install [`docker-compose`](https://github.com/ubiquiti/docker-compose-aarch64)

## 1. Make directories and update the system

Login to the device and run the following

```
mkdir -p /root/.ssh /root/data/postgres
```

```bash
apt-get update && apt-get install git htop bmon avahi-daemon avahi-discover avahi-utils libnss-mdns mdns-scan -y && apt-get upgrade -y && reboot
```

## 2. <a name="configure-ssh"></a>Copy default files

From the HOST MACHINE

```shell
# Pre-compiled Docker Compose
$ scp tools/docker-compose-Linux-aarch64 root@$odroid:/usr/local/bin/docker-compose
```

### A note about Docker Compose

The easiest technique I have found thus far to installing `docker-compose` is to cross compile it and `scp` it over to the unit. There is a compiled bin already checked into the repo.

### (OPTONAL) Build docker-compose for arm4 from your Mac

```shell
$ cd tools
$ git clone https://github.com/ubiquiti/docker-compose-aarch64.git && \
cd docker-compose-aarch64 && \
docker build . -t docker-compose-aarch64-builder && \
docker run --rm -v "$(pwd)":/dist docker-compose-aarch64-builder
```

## 3. Copy the blockchain

```shell
$ ssh crypdex@chains1.local
$ sudo su
$ systemctl stop chains.service
$ cd && scp -r chaindata/pivx root@$odroid:~/data/
```

## 4. Login to the Device

```shell
$ ssh root@$odroid
```


### Clone this Repo

```shell
$ cd; git clone git@blackbox.github.com:crypdex/blackbox.git
```

# Bootstrap the App

The following part of the setup is run from the root of the app

## Add configuration

These variables are the only non-configurable aspect right now. This can be changed in the future.

```
$ cd ~/blackbox && echo CHAINS=pivx > /.env
```

## Install Docker

```bash
# DEVICE
$ make install-docker
```

## Install a swapfile

```
$ make install-swapfile
```

## Boot the system manually to test

This is a really important step. Before installing the systemd service, it is worthwhile to boot the services. This will pull the docker images, and let the blockchain load up and get comfortable.

```bash
$ make start
```

# Finalizing for Customer Delivery

Now that you have verified that the device is functional, there is some cleanup to be done

- Change the root password, and log it someplace or you will never get back in.
- `rm /root/data/pivx/pivx.conf`: Make sure that each device has its own.
- Install the systemd service:

```
$ make install-services
```

# References

- ARM64 docker cross-builds
  - https://www.balena.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/
