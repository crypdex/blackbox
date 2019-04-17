---
title: PIVX Staking Node
sidebar_label: PIVX Staking Node
---

![pivx-product-shot](assets/pivx-product-shot.jpg)

## What's this?

The PIVX Staking Node is a small hardware device that makes earning interest on your PIV simple. Get one at [crypdex.io](https://crypdex.io/products/pivx-node).


## Getting Started

### Power Up and Get Synced

Connect the provided A/C adapter and ethernet cable to your device and power it on. It will take about 20 minutes for it to load the blockchain's index, do some sanity checks and start syncing the chain.

Once booted, you may safely leave the device powered on and operating continuously. You should be able to turn it off without any particular ceremony - just click the button on the A/C adapter.

### Initialize the Wallet

PIVX Staking Nodes arrive with a pre-seeded PIVX blockchain, but the wallet will be uninitialized.

Follow these steps to get your wallet initialized:

1. [Download the CLI for you platform](https://github.com/crypdex/blackbox-cli/releases).
1. Run the following command

<!--DOCUSAURUS_CODE_TABS-->
<!--CLI-->

```shell
$ blackbox-cli init
```

<!--cURL-->

```bash
curl -XPOST http://crypdex.local/initialize -d "{
    \"mnemonic\": \"{{mnemonic}}\",
    \"password": \"{{password}}\",
}"
```

<!--END_DOCUSAURUS_CODE_TABS-->

It is worth understanding that the PIVX Staking Node uses Crypdex's multiwallet to provide unified wallet functionality across a number of chains. Its features include:

- Multichain HD wallet
- Mnemonic and password
- HTTP API
- Built-in coin exchange (coming soon)
- Programmable (coming soon)
  

## Talking to your node

> While all services are password protected, you should operate this device in a relatively isolated network environment. While a residence is typically fine, don't plug it directly into a WeWork socket. A cheap consumer-grade router can create a no-frills subnet in a pinch.

You have several options for communicating with your device.

| Access Method                          | Device Link                                     | Uses                         |
| -------------------------------------- | ----------------------------------------------- | ---------------------------- |
| [Portainer](https://www.portainer.io/) | [crypdex.local:9000](http://crypdex.local:9000) | RPC access, log monitoring   |
| Multiwallet HTTP API                   | [crypdex.local](http://crypdex.local)           | Wallet-focused functionality |
| Command Line (CLI)                     |                                                 | Gettin 💩done                |
| PIVX RPC                               |                                                 | Chain verification           |
| SSH                                    |                                                 | Ninja shit                   |

The hostname has been set to `crypdex.local` by default. You may change this if you'd like at `/etc/hostname`. If you have multiple devices, they will be named sequentially.

### Portainer

The stack running inside the PIVX Staking Node includes [Portainer](https://portainer.io), a Docker management GUI. It is really nice. Portainer will give you a complete view into the software on the device including volume mounts, ports, and running containers.

> **Portainer can be a sharp knife.** Because you can manage the entire Docker deployment, you can potentiaally

Your device should arrive with fresh Portainer installation, so you will create a user and password when you first hit it's address.

![alt-text](assets/portainer-init.png)

Choose the option on the far left to manage the "Local" Docker environment and click "connect".

![alt-text](assets/portainer-local.png)

Finally, if you click on the "services" menu item on the left, you will see the running containers and can get at some interesting things like the logs, which can show you blockchain progress, as well as a console into any of the running containers.

![alt-text](assets/portainer-services.png)

### Multiwallet HTTP API

The HTTP API for Crypdex's multiwallet is the subject of it's own documentation.

### PIVX RPC

You may choose to not use the multiwallet and instead call PIVX RPC commands directly. Actually its not a binary choice, as you may use both.

The PIVX RPC may be accessed through a console lauched via Portainer (see below) or using a local `pivx-cli` client. The `rpcuser` and `rpcpassword` are generated uniquely per device and are only available by logging into the device and viewing the blockchain config file at

```shell
$ cat /root/.blackbox/data/pivx/pivx.conf
```

### SSH

And finally the section you have all been waiting for.

The PIVX Staking Node has been given a default SSH user/password combination. You can find this information on a small sticker on the device. You should login and change your password.

```shell
$ ssh root@crypdex.local
> passwd
```

The device runs BlackboxOS. You can find more documentation about using `blackboxd` in these pages.

## Updating

Updating the device currently requires that you connect via SSH and run the following:

```
$ apt update && apt upgrade blackboxd
```

This will pull and install the latest BlackboxOS package which includes the recipe for the PIVX Staking Node.

## Releases

| Date       | Batch Number   | Hardware                                               | PIVX Version |
| ---------- | -------------- | ------------------------------------------------------ | ------------ |
| April 2019 | 1 (prototypes) | Odroid C2, 64GB eMMC, black case w/ off-center sticker | 3.2          |
