---
title: Deployment
sidebar_label: Deployment
---

Blackbox aims to be fairly agnostic about where you deploy your networks. It supports ARM64 and x86 architectures making it compatible with small single board computers (SBCs), physical servers, or cloud-based virtualized servers.

## Security

> By default, Blackbox networks have their service's network ports exposed. In future releases this will be an option.

One design choice made currently is that by default, service ports are exposed from the host. This leaves the developer to decide how a firewall should be configured (if at all).

### Cloud Providers

For deployments on cloud providers, each firewall implementation is slightly different. See the cloud providers firewall docs for specific details. Generally, it should be straightforward to put the blackbox network in its own VPC.

### SBCs and Hardware

For local hardware deployments there are alot of options. If you are running this on an SBC, using `ufw` is a good option.

[This article on security](security) might be useful.

## Hardware

### Small Systems

The BlackboxOS currently supports arm64v8 and x86_64 architectures so assuming you have enough RAM, CPU, and disc space to accomidate all the services you want to run, it should work on everything from a RaspberryPi 3 to a cloud image.

However, here are some suggestions that might help:

- At least 1GB RAM. Some chains like PIVX require more.
- On RAM restricted devices, you should enable swap. This is done for you on distros like [Armbian](https://www.armbian.com/).
- At least 64GB disc space. Probably less than 1TB. Depends on your chain(s).
- A reasonably fast data volume. MicroSD cards are painfully slow for data access at the moment. You will get better results and performance from eMMC or USB 3.x drives. Drives connected via USB 2 will typically be as slow as MicroSD cards.

The CPU clock speed is almost never the bottleneck and even the cheapest lowest-end SBC's now have quad-core configurations.

### Large Systems

## Cloud
