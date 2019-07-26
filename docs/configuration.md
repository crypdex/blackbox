---
title: Configuration
sidebar_label: Configuration
---

Now that you have `blackbox` installed we can configure our network. We will use a Bitcoin+Lightning stack as an example to illustrate the process.

There are 2 primary things you will need to get going
1. A YAML config file
2. Environment variables for sensative config data


## Config File
Blackbox stacks are configured with YAML files. 

A YAML config file is conventionally located at `~/.blackbox/blackbox.yml`

The format is a small subset of [Compose version 3](https://docs.docker.com/compose/compose-file/). Blackbox pre-defines [`services`](https://github.com/crypdex/blackbox/tree/master/services) with reasonable defaults that you can use by simply writing something like:

```yaml
# A Bitcoin+LND nodeset
version: "3.7"
services:
  bitcoin:
  lnd_bitcoin:
```



Because it's just Docker Compose, anything you add here that is a valid Compose config will be added to the network as it is pulled up.

Documentation on individual services provide specifics on configuration.

## Environment Variables and Service Params

Just like Compose, environment variables are the primary way to parameterize services. Each service exposes a set of variables you can use which are conventionally `SCREAMING_SNAKE_CASE` with the service name as a prefix. Documentation on individual services provide specifics on which environment variables it expects.

Variables for services can also be set in a `~/.env` file. Since Docker Compose is currently the core orchestration, [this documentation](https://docs.docker.com/compose/environment-variables/) should given some extra detail on the various ways variables can be set. 

## `DATA_DIR`

> You must at least set `DATA_DIR` in your environment

**The `DATA_DIR` environment variable is really important.** This is the only variable required by `blackbox`. It specifies the root data directory location for all service data. With just this var, every service knows where it's data should live.

In practice for many networks you will need large storage volumes. Most services allow for overriding this `DATA_DIR` if you need to have a separate volume for a service.

### Variables Example: Bitcoin+Lightning

#### Mainnet

The Bitcoin+LND node can be parameterized with these variables

```.env
# Required by Blackbox
DATA_DIR=

# bitcoin: required
BITCOIN_RPCUSER=
BITCOIN_RPCPASS=
```

#### Regtest

To run this network on `regtest` instead, just add the following

```.env
BITCOIN_REGTEST=1
BITCOIN_MAINNET=0
```

There are more examples in the **[Services](services/lightning)** section.

## Start it up!

Now everything should be setup. You can start your network with the following command

```shell
$ blackbox info
```

```shell
$ blackbox start
```

If you want to see whats happening

```shell
$ blackbox logs
```
