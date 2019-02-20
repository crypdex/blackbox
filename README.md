This repository contains code and instructions for the deployment of Crypdex local systems. It may likely also be used for hosted deployments as well.

<hr />
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Common Setup](#common-setup)
  - [1. SSH Identity](#1-ssh-identity)
    - [2. Clone this Repo](#2-clone-this-repo)
- [Little Black Box](#little-black-box)
- [Big Black Box (x86)](#big-black-box-x86)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

<hr />

# From Scratch

1. Flash the SD card with the [manufacturer provided Ubuntu minimal image](https://wiki.odroid.com/odroid-c2/os_images/ubuntu/v3.0) for Odroid C2. This can be done with Etcher. Images are maintained on Google Drive: `Technology > Black Box Images`
1. [Prepare the device](#prepare)
1. [Configure the SSH identity](#configure-ssh)
1. Clone the [blackbox repository](https://github.com/crypdex/blackbox).

You will

Regardless of the deployent environment, the following setup should be followed to assure that the box can get this repository and update itself.

The update strategy is a simple `git pull`, but to do so on a private repository (like this one), requires that this repository has a common "deploy key" set, which it does.

**If you remove the deploy key or rename the repo then remote updates will break.** There currently is no strategy for rotating the deploy keys on remote machines.

## <a name="prepare"></a>Prepare the Device

SSH into the device as root and prepare it

* Make directories
* Install [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
* Install [`docker-compose`](https://github.com/ubiquiti/docker-compose-aarch64)

### Make directories and update the system

```
mkdir -p /root/.ssh /root/data
```

```bash
apt-get update && apt-get upgrade -y && reboot
```

### Install Docker

```bash
# Install Docker

apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
apt-key fingerprint 0EBFCD88 && \
add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
apt-get update && \
apt-get install -y docker-ce docker-ce-cli containerd.io
```

### Install Docker Compose

```bash
# Install Docker Compose

git clone https://github.com/ubiquiti/docker-compose-aarch64.git && \
cd docker-compose-aarch64 && \
docker build . -t docker-compose-aarch64-builder && \
docker run --rm -v "$(pwd)":/dist docker-compose-aarch64-builder
```

### Install other prerequisites
```
apt-get update && apt-get upgrade -y && apt-get install git
```

## <a name="configure-ssh"></a>Configure SSH Identity

#### 1. Copy the `id_rsa_blackbox` and default ssh config files to the device:

```shell
cd config/ssh && \
scp id_rsa_blackbox config id_rsa_blackbox.pub root@192.168.1.45:~/.ssh/
```
Copy the blockchain
```shell
$ ssh crypdex@chains1.local
$ sudo su && cd && scp -r chaindata/pivx root@odroid.local:~/data/
```
Now login to the device

```shell
$ ssh root@odroid.local
```

#### 2. Set the correct file permissions for the keys

```bash
$ chmod 600 ~/.ssh/id_rsa_blackbox ~/.ssh/id_rsa_blackbox.pub
```

#### 2. Add following to `~/.ssh/config`

```config
# ~/.ssh/config

Host blackbox.github.com
HostName github.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/id_rsa_blackbox
```



## Clone this Repo

```shell
$ cd; git clone git@blackbox.github.com:crypdex/blackbox.git
```

## References

- ARM64 docker cross-builds
  - https://www.balena.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/
