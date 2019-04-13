---
title: Installation
sidebar_label: Installation
---

Getting BlackboxOS setup is fairly straightforward, but does require some preparation.

## System Requirements

- Linux or macOS
- Docker
- Docker Compose (optional)

## System Preparation

Put Docker in swarm mode. We could do this for you but want to be respectful of you system's environment. For some cloud servers you will need to give it an `--advertise-addr`

```shell
$ docker swarm init
```

## Installation

The recommended way to install is by using a `.deb` package. This package manages a systemd service and places service and stack definitions in a common place. Further, it cleans up after itself and is updateable at the command line.

Assuming you are installing via package, you have a couple of choices

### Install from the `apt` Repo

Sike! There is no `apt` repo at the moment. Don't worry though, this is getting set up now.

### Manual Package Installation

[Download the most current package](https://github.com/crypdex/blackbox/releases) from the releases and use apt to install. If it is already installed, it will just update it.

Here is a little installer script that should do all the right things.

```bash
#!/bin/bash

version=${VERSION:-0.1.0}
arch=${ARCH:-arm64v8}

wget https://github.com/crypdex/blackbox/releases/download/v${version}/blackboxd_${version}_linux_${arch}.deb
apt install ./blackboxd_${version}_linux_${arch}.deb
```

You can use it like so

```shell
$ ARCH=x86_64 ./install-blackboxd.sh
```

## Hardware Requirements

The BlackboxOS currently supports arm64v8 and x86_64 architectures so assuming you have enough RAM, CPU, and disc space to accomidate all the services you want to run, it should work on everything from a RaspberryPi 3 to a cloud image.

However, here are some suggestions that might help:

- At least 1GB RAM. Some chains like PIVX require more.
- On RAM restricted devices, you should enable swap. This is done for you on distros like [Armbian](https://www.armbian.com/).
- At least 64GB disc space. Probably less than 1TB. Depends on your chain(s).
- A reasonably fast data volume. MicroSD cards are painfully slow for data access at the moment. You will get better results and performance from eMMC or USB-connected drives.

The CPU clock speed is almost never the bottleneck and even the cheapest lowest-end SBC's now have quad-core configurations.

## Assumptions

It is worth noting that `blackboxd` makes some assumptions about the environment that is running in.

- It assumes the device has Docker installed and that it is in swarm mode. - It also assumes that it is running a single node (no clustering yet) and can monopolize resources.
