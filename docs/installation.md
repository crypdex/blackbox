---
title: Installation
sidebar_label: Installation
---

## Prerequisites

Getting Blackbox setup is fairly straightforward, but does require a few software prerequisites.

- [Docker](https://docs.docker.com/docker-for-mac/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)

If you are developing on macOS, Docker Desktop for Mac has everything you need including Docker Compose. For Linux on ARM64, Docker Compose should be [installed via `pip`](https://docs.docker.com/compose/install/#install-using-pip) because Compose does not have an ARM64 build.

## Install

Blackbox is distributed via APT for Linux and [Homebrew](https://brew.sh/) on macOS.

### macOS

```shell
$ brew install crypdex/blackbox/blackboxd
```

### Linux

Add the Blackbox APT repo to your sources

```bash
# Do this once
$ echo "deb [trusted=yes] https://apt.fury.io/crypdex/ /" > /etc/apt/sources.list.d/fury.list
```

Install

```bash
# Install Blackbox
$ apt update && apt install blackboxd
```

### Manual Package Installation

[Download the most current package](https://github.com/crypdex/blackbox/releases) from the releases and use apt to install. If it is already installed, it will be updated it.

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
