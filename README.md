<img src="https://raw.githubusercontent.com/crypdex/blackbox/blob/master/docs/assets/logo2.png" width=300>

# BlackboxOS
 
An ARM-first, pluggable framework for multi-chain deployments.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Intro](#intro)
  - [Why?](#why)
  - [What sort of stuff can you do?](#what-sort-of-stuff-can-you-do)
  - [Features](#features)
- [Getting Started](#getting-started)
  - [Get started in 3 easy steps](#get-started-in-3-easy-steps)
  - [System Requirements](#system-requirements)
  - [Hardware Requirements](#hardware-requirements)
  - [Data Management Strategies](#data-management-strategies)
  - [Supported Services](#supported-services)
- [Development](#development)
  - [Alternatives](#alternatives)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Intro

The BlackboxOS is a pluggable platform for deploying multi-chain applications. It is used as the basis for all [Crypdex's](https://crypdex.io) Blackbox devices. Basic info and getting started stuff is on this page. 

**[Read the Docs](https://crypdex.github.io/blackbox/)**.

There are a few things that we think makes it particularly useful:

1. **It takes an ARM-first approach to its services.** Service stacks should run reliably on both single board computers (like the RPi) as well as in the cloud.
1. **Built-in data management strategy.** Sync your chain on super-fast machines and copy to your embedded device.
1. **Image maintenance.** We make sure that blockchain images are updated to keep you on the right fork.
1. **It's just Docker.** Add your own services and images to customize your deployment.

## Why?

The BlackboxOS builds on Docker container and orchestration tooling to address the specific needs of running blockchain-centric networks including security, data management, and inter-process communication. The goal is to make creating blockchain stacks simple.

## What sort of stuff can you do?

Here are a few examples of what you can do with the BlackboxOS.

- **SeedBox**: Create a device that keeps fresh copies of multiple blockchains always up to date.
- **Staking Node**: Crypdex uses the BlackboxOS to configure, run, and maintain it's [PIVX Staking Node](https://crypdex.io/products/pivx-node).

There are some preconfigured recipes in the [`/recipes`](https://github.com/crypdex/blackbox/tree/master/recipes) directory.

## Features

- 🐳Portable, Docker-based service stack.
- 👾**Multiarch All The Things!** Runs on `x86` and `arm` chipsets.
- Optimized for running multiple full nodes.
- Unified multi-chain deterministic wallet available.
- Expandable with new chains. Dynamically.
- Accessible via CLI, HTTP API, native RPCs, and GUI (under development)
- **🎗Maintenance.** Service definitions, recipes, and images are maintained and kept up-to-date ensuring that your project is always running the right fork.

# Getting Started

A CLI mediates all interaction with the BlackboxOS.

## Get started in 3 easy steps

0. Download a [release](https://github.com/crypdex/blackbox/releases) for your platform. There is an `apt` repo available soon for Debian variants.

1) Initialize your system with a recipe

```shell
$ blackbox init -r crypdex/pivx-stakebox
```

2. Start er up

```shell
$ blackbox start
```

3. Profit! 🎉

Configuration is kept in a `yaml` config file that you might want to edit.

## System Requirements

- Docker

BlackboxOS makes some assumptions about your deployment environment.

- The device is running a single node (no clustering yet) and can monopolize resources.
- It's Linux or macOS.

## Hardware Requirements

The BlackboxOS currently supports `arm64v8` and `x86_64` architectures so assuming you have enough RAM, CPU, and disc space to accomidate all the services you want to run, it should work on everything from a RaspberryPi 3 or Odroid C2 to an Intel NUC or cloud image.

Here are some suggestions

- **\>= 2GB RAM**. You can get away with 1GB RAM with swap enabled, but its gonna be a little slow. You may want to add swap anyway when running on a SBC.
- **\>= 64GB disc space**. Probably less than 1TB. Depends on your chain(s).
- `x86_64` or `arm64v8` chipsets.

Disc space requirements are entirely dependent on which services you are running. Chains like PIVX on the smaller end consume about 18GB of space while Bitcoin needs upwards of 250GB. This of course changes gradually to the upside.

We have had great success with Odroid C2's and Intel NUC. We have found the RaspberryPi to have insufficient RAM. The CPU clock speed is almost never the bottleneck and even the cheapest lowest-end SBC's now have quad-core configurations.

## Data Management Strategies

Managing blockchain data is one of the biggest pain points in working with multi-chain applications. The need for data management strategies becomes even more accute when using SD cards whose R/W speeds are typically pretty bad (though this is likely to improve very soon).

The BlackboxOS treats the data directory as a core object. A `DATA_DIR` is made available to all service definitions as well as an namespaced variable like `${SERVICE_NAME}_DATA_DIR`

that a data volume is mounted for each service. For the moment, this is in a common place, but work is being done on configuration per service if desired. This gives developers the option to "pre-seed" chains by downloading the chain elsewhere and copying the entire directory over to the device running the BlackboxOS.

This strategy is what Crypdex uses. We run a SeedBox that keeps fresh copies of each chain we support (configured with BlackboxOS of course), so that we can copy it to our other projects.

## Supported Services

While you are free to add your own services to the BlackboxOS, the following are maintained and supported by Crypdex. Because this project is under active development, the following table can give you some idea if whats up.

|                                            | service | wallet | features            |
| ------------------------------------------ | ------- | ------ | ------------------- |
| PIVX                                       | ✓       | ✓      | Masternode, staking |
| Dash                                       | ✓       | ✓      | Masternode          |
| ZCoin                                      | ✓       | ✓      | Masternode          |
| Blocknet                                   | ✓       | ✓      | Masternode, staking |
| Bitcoin                                    |         |        |                     |
| Litecoin                                   | ✓       |        |                     |
| [Sparkswap Broker](https://sparkswap.com/) |         |        | Under development   |

# Development

BlackboxOS is a mix of Go, Docker, and a sprinkling of Bash scripts. It is developed with Go 1.12+, modules enabled.

If you'd like to build from source

```shell
$ go get github.com/crypdex/blackbox
$ go build .
```

This section deserves alot more attention.

## Alternatives

There are other projects which overlap with this one. If you have a project you would like to include in this list, lemme know.

- [Casa Node](https://keys.casa/)
- BitBot OS
