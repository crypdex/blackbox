This repository contains code and instructions for the deployment of Crypdex local systems. It may likely also be used for hosted deployments as well.

<hr />
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Summary](#summary)
- [<a name="prepare"></a>Prepare the Device](#a-nameprepareaprepare-the-device)
  - [Make directories and update the system](#make-directories-and-update-the-system)
  - [Install Docker](#install-docker)
  - [Install Docker Compose](#install-docker-compose)
    - [Build docker-compose for arm4 (from your Mac)](#build-docker-compose-for-arm4-from-your-mac)
  - [<a name="configure-ssh"></a>Configure SSH Identity](#a-nameconfigure-sshaconfigure-ssh-identity)
    - [1. Copy the `id_rsa_blackbox` and default ssh config files to the device:](#1-copy-the-id_rsa_blackbox-and-default-ssh-config-files-to-the-device)
    - [2. Set the correct file permissions for the keys](#2-set-the-correct-file-permissions-for-the-keys)
  - [Copy the blockchain](#copy-the-blockchain)
  - [Clone this Repo](#clone-this-repo)
- [Bootstrap the App](#bootstrap-the-app)
  - [Install a swapfile](#install-a-swapfile)
  - [Install the `systemd` service](#install-the-systemd-service)
  - [Configure the blockchain](#configure-the-blockchain)
- [References](#references)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

<hr />

# Summary

1. Flash the SD card with the [manufacturer provided Ubuntu minimal image](https://wiki.odroid.com/odroid-c2/os_images/ubuntu/v3.0) for Odroid C2. This can be done with Etcher. Images are maintained on Google Drive: `Technology > Black Box Images`
1. [Prepare the device](#prepare)
1. [Configure the SSH identity](#configure-ssh)
1. Clone the [blackbox repository](https://github.com/crypdex/blackbox).

You will

Regardless of the deployent environment, the following setup should be followed to assure that the box can get this repository and update itself.

The update strategy is a simple `git pull`, but to do so on a private repository (like this one), requires that this repository has a common "deploy key" set, which it does.

**If you remove the deploy key or rename the repo then remote updates will break.** There currently is no strategy for rotating the deploy keys on remote machines.

# <a name="prepare"></a>Prepare the Device

SSH into the device as root and prepare it

* Make directories
* Install [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
* Install [`docker-compose`](https://github.com/ubiquiti/docker-compose-aarch64)

## 1. Make directories and update the system
Login to the device and run the following

```
mkdir -p /root/.ssh /root/data/postgres
```

```bash
apt-get update && apt-get upgrade -y && apt-get install git htop bmon -y && reboot
```


## 2. <a name="configure-ssh"></a>Copy default files

From the HOST MACHINE

### Copy the `id_rsa_blackbox` and default ssh config files to the device:

```shell
$ cd config/ssh
$ scp config/ssh/config config/ssh/id_rsa_blackbox config/ssh/id_rsa_blackbox.pub root@$odroid:~/.ssh/
# Pre-compiled Docker Compose
$ scp arm64/tools/docker-compose-aarch64/docker-compose-Linux-aarch64 root@$odroid:/usr/local/bin/docker-compose
```

### A note about Docker Compose

The easiest technique I have found thus far to installing `docker-compose` is to cross compile it and `scp` it over to the unit. There is a compiled bin already checked into the repo.

### (OPTONAL) Build docker-compose for arm4 from your Mac

```shell
$ cd arm64/tools
$ git clone https://github.com/ubiquiti/docker-compose-aarch64.git && \
cd docker-compose-aarch64 && \
docker build . -t docker-compose-aarch64-builder && \
docker run --rm -v "$(pwd)":/dist docker-compose-aarch64-builder
```


## 3. Copy the blockchain

```shell
$ ssh crypdex@chains1.local
$ sudo su 
$ cd && scp -r chaindata/pivx root@$odroid:~/data/
```


## 4. Login to the Device


### Set the correct file permissions for the keys

```bash
$ chmod 600 ~/.ssh/id_rsa_blackbox ~/.ssh/id_rsa_blackbox.pub
```

### Clone this Repo

```shell
$ cd; git clone git@blackbox.github.com:crypdex/blackbox.git
```



# Bootstrap the App

The following part of the setup is run from the root of the app

## Install Docker

```bash
# DEVICE
$ cd ~/blackbox/arm64 && make install-docker
```

## Install a swapfile

```
$ make install-swapfile
```

## Configure the blockchain

```
$ cp config/pivx.conf ~/data/pivx/pivx.conf
```

## Boot the system manually to test

This is a really important step. Before installing the systemd service, it is worthwhile to boot the services. This will pull the docker images, and let the blockchain load up and get comfortable.


```bash
$ make start
```

# Finalizing for Customer Delivery

- Change the root password
- Install the systemd service

## Install the `systemd` service

```
$ make systemd-install
```


# References

- ARM64 docker cross-builds
  - https://www.balena.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/
