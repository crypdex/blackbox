---
title: Installation
sidebar_label: Installation
---

Getting BlackboxOS setup is fairly straightforward, but does require some [preparation](device-preparation).

## Installation

The recommended way to install is by using a `.deb` package. This package manages a systemd service and places service and stack definitions in a common place. Further, it cleans up after itself and is updateable at the command line.

Assuming you are installing via package, you have a couple of choices

### Install from the `apt` Repo

Add the following to `/etc/apt/sources.list` or `/etc/apt/sources.list.d/fury.list`

```
deb [trusted=yes] https://apt.fury.io/crypdex/ /
```

and then install normally

```shell
$ apt update && apt install blackboxd
```

### Installing a Snapshot

```bash
# From project root
scp dist/blackboxd_v0.0.39-snapshot_linux_arm64v8.deb root@crypdex-0000.local:/root

# On the device
apt install ./blackboxd_v0.0.39-snapshot_linux_arm64v8.deb
blackboxd start
```

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

## Assumptions

It is worth noting that `blackboxd` makes some assumptions about the environment that is running in.

- It assumes the device has Docker installed and that it is in swarm mode. - It also assumes that it is running a single node (no clustering yet) and can monopolize resources.
