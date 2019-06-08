---
title: Configuration
sidebar_label: Configuration
---

## Config File

Now that you have the `blackboxd` installed we can configure our network.

Blackbox networks are configured with YAML files. The format is a small subset of [Compose version 3](https://docs.docker.com/compose/compose-file/). Blackbox pre-defines [`services`](https://github.com/crypdex/blackbox/tree/master/services) with reasonable defaults that you can use by simply writing something like:

```yaml
# A Bitcoin+LND nodeset
version: "3.7"
services:
  lnd_bitcoin: {}
```

This file is conventionally located at `~/.blackbox/blackbox.yml`

> Config file location will be moved to the `DATA_DIR` in version 0.2 release

Because it's just Docker Compose, anything you add here that is a valid Compose config will be added to the network as it is pulled up.

## Variables and Service Params

Just like Compose, environment variables are the primary way to parameterize services. Each service exposes a set of variables you can use which are conventionally `SCREAMING_SNAKE_CASE` with the service name as a prefix.

[Variables are sourced by Docker Compose](https://docs.docker.com/compose/environment-variables/). Please see the Compose [documentation](https://docs.docker.com/compose/environment-variables/) for specific details.

Generally, I have been creating a file at `~/.env` when running services.

### `DATA_DIR`

The `DATA_DIR` environment variable is really important. This is the only variable required by `blackboxd`. It specifies the root data directory location for all service data. With just this var, every service knows where it's stuff should live.

In practice for many networks you will need large storage volumes. We recommend using an externally attached SSD - be that a cloud provisioned one, or a USB3/C connected device.

### Example: Bitcoin+LND

#### Mainnet

The Bitcoin+LND node can be parameterized with these variables

```.env
# Required by Blackbox
DATA_DIR=

# bitcoin: required
BITCOIN_RPCUSER=
BITCOIN_RPCPASS=

# bitcoin: available with defaults
BITCOIN_NETWORK=mainnet
```

#### Regtest

To run this network on `regtest` instead, just change the last line to

```.env
BITCOIN_NETWORK=regtest
```

There are more examples in the **[Services](services/lightning)** section.

## Start it up!

Now everything should be setup. You can start your network with the following command

```shell
$ blackboxd start
```

If you want to see whats happening

```shell
$ blackboxd logs
```
