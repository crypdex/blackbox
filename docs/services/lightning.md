---
title: Lightning Network
sidebar_label: Lightning (LND)
---

<img src="/blackbox/docs/assets/lnd.png"  style="width:40%;"/>

From the LND [docs](https://github.com/lightningnetwork/lnd)

> The Lightning Network Daemon (lnd) - is a complete implementation of a Lightning Network node. lnd has several pluggable back-end chain services including btcd (a full-node), bitcoind, and neutrino (a new experimental light client). The project's codebase uses the btcsuite set of Bitcoin libraries, and also exports a large set of isolated re-usable Lightning Network related libraries within it

## Summary

The Lightning Network Daemon (LND) is implemented for both Bitcoin and Litecoin chains and may be run independently or together. The LND service bundles the primary chain (Bitcoin or Litecoin) due to the specifics of configuration and the need to make sure that tracked versions are compatible.

LND offers an option to choose between `bitcoind` and `btcd` daemon implementations. This implementation currently uses `bitcoind`.

It is possible to use existing Bitcoin and Litecoin data directories from other installations with this service stack as long as the versions are compatible.

## Usage

Creating LND nodes require a backing blockchain. This is currently either Bitcoin or Litecoin. To use the stack, configure your `blackbox.yml` file as follows:

LND Bitcoin

```yaml
version: "3.7"

services:
  bitcoin:
  lnd_bitcoin:
```

LND Litecoin

```yaml
version: "3.7"

services:
  litecoin:
  lnd_litecoin:
```

Bitcoin, Litecoin, and both LND daemons

```yaml
version: "3.7"

services:
  bitcoin:
  lnd_bitcoin:
  litecoin:
  lnd_litecoin:
```

## Environment Variables

### Basic Configuration

By default, this service uses environment variables to generate configs. You may set them in your shell or in a `.env` file in the `pwd`.

```bash
# You should set this! (Not required yet)
DATA_DIR=path/to/storage

# Required (if using lnd_bitcoin)
BITCOIN_RPCUSER=
BITCOIN_RPCPASS=

# Required (if using lnd_litecoin)
LITECOIN_RPCUSER=
LITECOIN_RPCPASS=
```

You may `export` these in the shell before startup, or put them in a `.env` file at the root of the blackbox dir.

### Environment Variables

The follow table represents all variables available to this service.

| Name                  | Default             | Required |
| --------------------- | ------------------- | -------- |
| BITCOIN_RPCUSER       |                     | ✓        |
| BITCOIN_RPCPASS       |                     | ✓        |
| LND_BITCOIN_RPCLISTEN | 0.0.0.0             |
| BITCOIN_MAINNET       | 1                   |
| BITCOIN_TESTNET       | 0                   |
| BITCOIN_REGTEST       | 0                   |
| BITCOIN_RPCHOST       | bitcoin             |
| BITCOIN_ZMQPUBRAWBLOC | tcp://bitcoin:28333 |
| BITCOIN_ZMQPUBRAWTX   | tcp://bitcoin:28334 |

This listing may occasionally get out of sync with master. Check [this file](https://github.com/crypdex/blackbox/blob/master/services/lnd_bitcoin/config/lnd_bitcoin.conf.tmpl) for the implementation.

### Extended configuration

While Blackbox aims to make it simple to get a service standing for basic applications, your specific deployment might need extra configuration.

There are 2 methods for extending the basic configuration

1. Use the `command` key add additional flags to be accepted by the service.
1. Disable the configuration and manage your own config file.

The following is an example of using the `command` key to provice additional parameters the service. The config file is still written using variables you define in the environment, however any flags passed through the `command` key will also be used. These flags will override any variables set in the config file.

```yaml
version: "3.7"

services:
  bitcoin:
  lnd_bitcoin:
    command: -autopilot.active=1 -autopilot.maxchannels=10
```

## Binary Wrappers

> Binary wrappers are a relatively experimental feature but work great! If you have usage suggestions let us know.

The LND stacks have binary wrappers for `lncli`. These are simply scripts that allow you to run `lncli` just as you would if LND was running natively and save you from `docker exec`ing into the LND container to run commands.

They are particularly useful since LND requires a great deal of CLI-based interaction for the current workflow.

### Invocation

```bash
blackboxd exec lncli-bitcoin <command>
```

```bash
blackboxd exec lncli-bitcoin -- <flags>
```

### Installation

It may also be installed to `/usr/local/bin` so that you can invoke the command without `blackboxd`.

```bash
blackboxd bin install lncli-bitcoin
blackboxd bin install lncli-litecoin
```

### Removal

```bash
blackboxd bin remove lncli-bitcoin
blackboxd bin remove lncli-litecoin
```

The wrappers installed to `/usr/local/bin` are not compatible with Windows yet. Installation will not overwrite any existing binaries you may have, but removal will delete the file regardless of how it got there.

## Ports

> See the Bitcoin and Litecoin service docs for their port exposures.

### `lnd`

|              | Network Agnostic? |
| ------------ | ----------------- |
| Peer to Peer | 9735              |
| gRPC         | 10009             |
| REST         | 8080              |

> LND ports are not mapped by default. This is because multiple LND instances can run on different chains such as Bitcoin and Litecoin. If you would like them exposed, you may add the port mappings as follows to the `blackbox.yml` file.

```yaml
version: "3.7"

services:
  lnd_bitcoin:
    ports:
      - 10009:10009
      ...
```

### `bitcoin`

These ports are exposed

|                 | Mainnet | Testnet | Regtest |
| --------------- | ------- | ------- | ------- |
| Peer to Peer    | 8333    | 18333   | 18443   |
| JSON RPC Server | 8332    | 18332   | 18442   |

### `litecoin`

These ports are exposed

|                 | Mainnet | Testnet |
| --------------- | ------- | ------- |
| Peer to Peer    | 9333    | 19333   |
| JSON RPC Server | 9332    | 19332   |
