---
id: security
title: Security
sidebar_label: Security
---

> **This page is not considered optional reading**.<br/>Docker leaves us in a funky security position and its important to patch it up.

This document addresses Debian-based systems. If you have installed Blackbox on a non-Debian system, please seek out similar tools to restrict external access to ports exposed by Docker services. If you are running in a cloud deployment, you should use VPCs or similar network-level isolation.

## Install and Setup a Firewall

To secure the device, we **must** setup some firewall rules. We will do this with `ufw`.

```shell
apt-get install ufw
```

### Define Policies

To begin, we set some broad default access policies

```shell
ufw default deny incoming
ufw default allow outgoing
```

Now, you may select the ports you would like open. The following are the defaults used by Crypdex - we open the SSH (`22`), API (`80`), mDNS (`5353`) , admin (`8888`) and Portainer (`9000`) ports, leaving the rest closed to outside access.

```shell
ufw allow 22 80 8888 9000 5353
```

You will also notice that we closed off blockchain RPC access. If you feel comfortable opening this up, you may do so by adding the port (PIVX is `51473` and `51472`).

Finally, let's enable `ufw`

```shell
ufw enable
```

### Adjust Rules

Without intervention, Docker and UFW do not play well together. In fact if left alone, the setup you did in the previous step will be completely ineffective.

Edit the following file

```shell
nano /etc/ufw/after.rules
```

Append the following at the end

```text
# Put Docker behind UFW
*filter
:DOCKER-USER - [0:0]
:ufw-user-input - [0:0]

-A DOCKER-USER -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A DOCKER-USER -m conntrack --ctstate INVALID -j DROP
-A DOCKER-USER -i eth0 -j ufw-user-input
-A DOCKER-USER -i eth0 -j DROP
COMMIT
```

This is the simple solution and it is not without trade offs. The one to be aware of is that it should only be done with Docker containers that map ports 1:1, that is, they are not remapped. This is the case with Blackbox. For more, see the links in the references section.

### Reboot and Test

Finally, `reboot` your device and do a quick port scan to assure that your setting are copacetic. YOu can use the Mac's Network Utility. [LanScan](https://itunes.apple.com/us/app/lanscan-pro/id562184107?mt=12) for macOS is nice and has a duck face as a logo.

### References

Discussions on setting up UFW and similar with Docker are extensive. It is our opinion that Docker's default networking rules should be considered dangerous.

- https://github.com/moby/moby/issues/4737#issuecomment-419705925
- https://gist.github.com/rubot/418ecbcef49425339528233b24654a7d
- https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-18-04

## Root access and Portainer

All of this firewall preparation is for nothing if your root password is left as its default value (if you bought a device from Crypdex), or your Portainer password is weak.

### Change the root password

Change your root password by ssh'ing into the device and running

```shell
passwd
```

ez.

### Portainer

Portainer is sick. You should be able to access it at http://crypdex.local:9000. Its database is uninitialized when first booted, so you must secure it with a password. Just visit its address and choose a password that is secure. And use a password manager if you can.
