<img src="https://raw.githubusercontent.com/crypdex/blackbox/master/docs/assets/logo2.png" width=300>

# BlackboxOS



The BlackboxOS is an ARM-first pluggable platform for deploying multi-chain applications. It is used as the basis for all [Crypdex's](https://crypdex.io) Blackbox devices. Basic info and getting started stuff is on this page. 

Deeper dive documentation is available [here](https://crypdex.github.io/blackbox).

## Why?

The BlackboxOS builds on Docker container and orchestration tooling to address the specific needs of running blockchain-centric networks including security, data management, and inter-process communication. The goal is to make creating blockchain stacks simple.

## What sort of stuff can you do?

Here are a few examples of what you can do with the BlackboxOS.

- **SeedBox**: Create a device that keeps fresh copies of multiple blockchains always up to date.
- **Staking Node**: Crypdex uses the BlackboxOS to configure, run, and maintain it's [PIVX Staking Node](https://crypdex.io/products/pivx-staking-node).

There are some preconfigured recipes in the [`/recipes`](https://github.com/crypdex/blackbox/tree/master/recipes) directory.

## Features

- 🐳 Portable, Docker-based service stack.
- 👾 **Multiarch All The Things!** Runs on `x86` and `arm` chipsets.
- Optimized for running multiple full nodes.
- Unified multi-chain deterministic wallet available.
- Expandable with new chains. Dynamically.
- Accessible via CLI, HTTP API, native RPCs, and GUI (under development)
- **🎗Maintenance.** Service definitions, recipes, and images are maintained and kept up-to-date ensuring that your project is always running the right fork.

## Documentation

All documentation is now at https://crypdex.github.io/blackbox.
There you will find installation instructions and well as hardware and software requirements


## Alternatives

There are other projects which overlap with this one. If you have a project you would like to include in this list, lemme know.

- [Casa Node](https://keys.casa/)
- BitBot OS
