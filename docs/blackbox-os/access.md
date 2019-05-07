---
title: Access
sidebar_label: Access
---

## Talking to your node

> Upon receiving your device, you should change SSH passwords and Portainer login credentials before proceeding with setup.

> While all services are password protected, you should operate this device in a relatively isolated network environment. While a residence is typically fine, don't plug it directly into a WeWork socket. A cheap consumer-grade router can create a no-frills subnet in a pinch.

You have several options for communicating with your device.

- Portainer
- Command Line Interface (CLI)
- SSH

The hostname has been set to `crypdex.local` by default using mDNS. Specific editions may have a different hostname. See the documentation for your specific edition for details. If you have multiple devices with the same hostname, they will be named sequentially.

## Portainer

> The Portainer instance is unconfigured. You should immediately configure it with a really strong user/pass.

BlackboxOS stacks typically include [Portainer](https://portainer.io), a Docker management GUI. It is really nice. Portainer will give you a complete view into the software on the device including volume mounts, ports, and running containers.

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
