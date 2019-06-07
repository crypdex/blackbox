<img src="https://raw.githubusercontent.com/crypdex/blackbox/master/docs/assets/logo2.png" width=300>

# BlackboxOS

[![CircleCI](https://circleci.com/gh/crypdex/blackbox/tree/master.svg?style=svg)](https://circleci.com/gh/crypdex/blackbox/tree/master)

The Blackbox is an ARM-first pluggable platform for deploying multi-chain applications. It is used as the basis for all [Crypdex's](https://crypdex.io) Blackbox devices. Basic info and getting started stuff is on this page. 

All documentation is available [here](https://crypdex.github.io/blackbox).

## Why?

The Blackbox builds on Docker container and orchestration tooling to address the specific needs of running blockchain-centric networks including security, data management, and inter-process communication. The goal is to make creating blockchain stacks simple.

## What sort of stuff can you do?

Here are a few examples of what you can do with the Blackbox.

- Spin up a Bitcoin+Lightning node on `regtest` for local development
- Create a "seedbox" that keeps a bunch of chains up to date
- Create a [multi-chain staking node](https://crypdex.io/products/multichain-staking-node) with all the classic Proof of Stake chains
- Run a [Sparkswap Broker](https://crypdex.io)

More examples are in the documentation.

## Features

- **Multiarch All The Things!** Runs on `x86` and `arm` chipsets.
- Portable, Docker-based service stack.
- Optimized for running multiple full nodes.
- Expandable with new chains. Dynamically.
- Binary wrappers for easy CLI and RPC access
- **Maintenance!** Service definitions, recipes, and images are maintained and kept up-to-date ensuring that your project is always running the right fork.

## Documentation

All documentation is now at https://crypdex.github.io/blackbox.
There you will find installation instructions and well as hardware and software requirements


## Alternatives

There are other projects which overlap with this one. If you have a project you would like to include in this list, lemme know.

- [Casa Node](https://keys.casa/)
- BitBot OS
