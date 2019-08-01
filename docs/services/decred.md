---
title: Decred
sidebar_label: Decred
---

<img src="/blackbox/docs/assets/dcr.svg" style="width:60%;"/>

## Introduction

The `decred` service makes it simple to setup and run a full Decred node. If you have a **[Decred Solo](https://crypdex.io/decred-solo)**, then this service is pre-configured and you may skip to the [setup](https://crypdex.github.io/blackbox/docs/services/decred#setup).

There are a couple of reasons you would want run a Decred node:

1. **Automatically buy tickets**
2. **Run a "solo voting" node**

## Use Cases

### Automated Ticket Buying

Stakeholders who participate in Decred’s decision-making are rewarded for their efforts with DCR, Decred’s native currency. To participate, DCR holders purchase “tickets” to register their vote. The actual vote is cast by an always-on node. The process of purchasing tickets is a variation on "staking" and locks up the collateral used for a certain period of time.

Once a ticket is purchased, it remains "live" until a proposal comes up for a vote. Successful votes pay a block reward to ticket holders and the staked collateral that was used to purchase the ticket is unlocked. At this point new tickets may be purchased.

The ticket buying process (staking) can be automated, but in order to do so, a node needs to be online to process transactions. The Decredition application is simple to use, but must be monitored for "liveness" of tickets so that new ones may be purchased.

### Solo Voting

The actual casting of votes on proposals is done by nodes that are online continuously. Decred allows ticket holders to delegate their votes to Voting Service Providers (VSPs) or you may run your own [Solo Voting Node](https://docs.decred.org/advanced/solo-proof-of-stake-voting/).

VPSs typically take a fee for providing services that can sometimes be as high as 5%. Solo voting bypasses these fees at the risk of missing votes (and block rewards).

## Quickstart

**The `decred` service requires manual setup.** This process generates unique credentials and initializes your wallet. Compared to other services, it is more involved, but most of the work has been scripted out for you.

### Config

First, define the `decred` service in the [BlackboxOS config file](https://crypdex.github.io/blackbox/docs/configuration).

```shell
$ nano ~/.blackbox/blackbox.yaml
```

```yaml
version: '3.7'
services:
  decred: {}
```

### Setup

With the `decred` service defined in the config, start `blackbox` and follow the prompts to continue with Decred initialization. Decred has some very specific things it needs and you will be prompted for input.

```shell
$ blackbox start
```

Your session should go something like this:

```shell
root@blackbox:~# blackbox start

❯ Registering services in /var/lib/blackbox/services
❯ BLACKBOX starting ...
❯ Running prestart script for decred
[decred] Configuring Decred ...
[decred] Creating directory: /root/.blackbox/data/decred
[decred] Creating directory: /root/.blackbox/data/decred/dcrd
[decred] Creating directory: /root/.blackbox/data/decred/dcrwallet
[decred] Generating dcrd TLS certs
[decred] Generating dcrwallet TLS certs
[decred] ATTENTION: You need to create a wallet ...

Enter the private passphrase for your new wallet:
Confirm passphrase:
```

If you have not already created a `~/.env` file, the initialization script will make one for you with some securely generated credentials and a few variables you can use to customize your node.

### Environment

You will now give the service a few variables.

```shell
$ nano ~/.env
```

The `decred` service uses the following variables in its operation. If the file did not exist prior to the first run setup detailed above, the following will be generated for you.

> **Auto ticket buying and solo voting are enabled by default.** If you would like to purchase tickets manually and setup a VSP, please adjust the environment variables.

```.env
# Default data directory. Change if desired
DATA_DIR=$HOME/.blackbox/data

# These are required
DECRED_RPCUSER=<random>
DECRED_RPCPASS=<random>
DECRED_WALLET_PASSWORD=

# Solo Voting
# ------------
DECRED_ENABLEVOTING=1

# Ticket Buyer
# -------------
DECRED_ENABLETICKETBUYER=1
# DECRED_BALANCETOMAINTAINABSOLUTE=0
# DECRED_MAXPRICEABSOLUTE=150
```

To get going, you will need to fill in the following variables (assuming the others were generated):

```.env
DECRED_WALLET_PASSWORD=<the passphrase you entered during setup>
DECRED_VOTINGADDRESS=<the voting node delegate address>
```

## `dcrctl`

With everything setup, you may now use the node with the command line client, `dcrctl`. Because `decred` is running in Docker, the BlackboxOS provides a binary wrapper for easy access.

Log into your device and type

```shell
$ blackbox exec dcrctl -- --wallet walletinfo
```

You may also install the binary wrapper so that you do not have to prefix the command

```shell
$ blackbox bin install dcrctl
```

You may now access `dcrctl` normally

```shell
$ dcrctl --wallet getinfo
```

## Vote Delegation

Because this service runs a full node, you can delegate your votes to a VSP as well. However, delegation is a work in progress for BlackboxOS and Decredition is simpler to use.

Please refer to this documentation for the commands necessary for delegating
https://docs.decred.org/wallets/cli/dcrwallet-tickets

### Finding a Voting Service Provider

To delegate your votes to a Voting Service Provider (VSP) you will need to find one and setup an account. A list of providers can be found at https://decred.org/vsp/. All things being equal, you are looking for a provider that has the lowest fee and the least number of missed votes. https://stakey.net/ is one such provider.

### Configuration

To support vote delegation, BlackboxOS will pick up the following variables to configure the service.

```.env
... your other vars ...

DECRED_VOTINGADDRESS=
DECRED_POOLADDRESS=<check vsp>
DECRED_POOLFEES=<check vsp>
```

## Ports

See the [Decred docs](https://docs.decred.org/faq/configuration/) for more information.

### dcrd

https://docs.decred.org/wallets/cli/dcrd-and-dcrwallet-cli-arguments/

|              | Mainnet | Testnet | Simnet |
| ------------ | ------- | ------- | ------ |
| Peer to Peer | 9108    | 19108   | 18555  |
| RPC Server   | 9109    | 19109   | 19556  |

### dcrwallet

|          | Mainnet | Testnet | Simnet |
| -------- | ------- | ------- | ------ |
| JSON-RPC | 9110    | 19110   | 19557  |
| gRPC     | 9111    | 19111   | 19558  |

By default, these ports are exposed.

## TLS Certs

Decred is pretty serious about security and verification in its communications. As such, it uses TLS certs for its RPC connections. The daemons generate their own certs if left alone, but the daemon generated certs are not compatible with this Docker network. This is due to the way that the domains are registered in the cert.

This project generates certs that can be used to get Decred working in its default case. This happens at service boot (see the prestart script). If you would like to heighten your own security, you may generate new certs manually.

[This article](https://stakey.club/en/digital-certificates-for-rpc-connections/) gives a nice tutorial.
