---
id: intro
title: An introduction to
sidebar_label: Intro
---

<div class="superduper">Blackbox</div>

**Blackbox** is a framework for responsive infrastructure design focused on blockchain applications. It gives developers a foundation to build out blockchain application stacks and get them deployed quickly, with minimal configuration.

Here is what the config for a Bitcoin+LND node running on `mainnet` looks like.

```yaml
# Bitcoin+LND node running on mainnet
services: lnd_bitcoin:
```

The [docs on LND](services/lightning) have more on this configuration and how to set RPC credentials.

## ARM-first Deployments

Blackbox aims to be agnostic to both chipset and scale to allow for deployments on a range of targets from ARM-based single board computers (SBCs) like the Raspberry Pi to cloud-based clusters. It is appropriate for use as a development tool as well as a production plaform.

Blackbox is new and evolving rapidly, but it already powers devices in a production context.

> Blackbox currently assumes single node operations and does not yet support clusters/replicas and load balancing. This is on the roadmap.

## Features

There are a few things that we think makes it particularly useful:

- It takes an ARM-first approach to its services. Service stacks should run reliably on both single board computers (like the RPi) as well as in the cloud.
- Built-in data management strategy. Sync your chain on super-fast machines and copy to your embedded device.
- Image maintenance. We make sure that blockchain images are updated to keep you on the right fork.
- It's really just Docker. Add your own services and images to customize your deployment.

Ready to give it a go? Great. Let's proceed.

## Getting Started

Read through the [Getting Started](getting-started) doc for installation instructions and setup. Current releases of Blackbox can be found [here](https://github.com/crypdex/blackbox/releases).

## Contributions Welcome

Like what we started here and would like to request features? Please have a look through the [Github repo](https://github.com/crypdex/blackbox) for contribution guidelines.
