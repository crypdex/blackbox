---
title: Hardware Requirements
sidebar_label: Hardware
---

The BlackboxOS currently supports arm64v8 and x86_64 architectures so assuming you have enough RAM, CPU, and disc space to accomidate all the services you want to run, it should work on everything from a RaspberryPi 3 to a cloud image.

However, here are some suggestions that might help:

- At least 1GB RAM. Some chains like PIVX require more.
- On RAM restricted devices, you should enable swap. This is done for you on distros like [Armbian](https://www.armbian.com/).
- At least 64GB disc space. Probably less than 1TB. Depends on your chain(s).
- A reasonably fast data volume. MicroSD cards are painfully slow for data access at the moment. You will get better results and performance from eMMC or USB 3.x drives. Drives connected via USB 2 will typically be as slow as MicroSD cards.

The CPU clock speed is almost never the bottleneck and even the cheapest lowest-end SBC's now have quad-core configurations.
