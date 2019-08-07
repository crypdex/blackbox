---
title: Installation
sidebar_label: Installation
---

# Prerequisites

Getting Blackbox setup is fairly straightforward, but does require a few software prerequisites.

- [Docker](https://docs.docker.com/install/linux/docker-ce/debian/)
- [Docker Compose](https://docs.docker.com/compose/install/)

If you are developing on macOS, Docker Desktop for Mac has everything you need including Docker Compose. For Linux on ARM64, Docker Compose should be [installed via `pip`](https://docs.docker.com/compose/install/#install-using-pip) because Compose does not have an ARM64 build.

### Install Docker the EZ way

```shell
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sh get-docker.sh
```

### Docker Compose ARM64 (Armbian)

Installing Docker-Compose on ARM devices should be done via python/pip

```shell
$ apt install libffi-dev libssl-dev python3-dev python3-pip
$ pip3 install wheel setuptools
$ pip3 install docker-compose
```

# Install BlackboxOS

Blackbox is distributed via APT for Linux and [Homebrew](https://brew.sh/) on macOS.

### Linux

Add the Blackbox APT repo to your sources

```bash
# Do this once
$ echo "deb [trusted=yes] https://apt.fury.io/crypdex/ /" > /etc/apt/sources.list.d/fury.list
```

Install

```bash
# Install Blackbox
$ apt update && apt install blackbox-os
```

### macOS

```shell
$ brew install crypdex/blackbox/blackbox-os
```

### Manual Package Installation

[Download the most current package](https://github.com/crypdex/blackbox/releases) from the releases and use apt to install. If it is already installed, it will be updated it.
