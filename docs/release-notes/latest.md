# BLACKBOX

**BLACKBOX** is an ARM-first pluggable platform for deploying multi-chain applications. It is used as the basis for all Crypdex's Blackbox devices.

Complete documentation is available [here](https://crypdex.github.io/blackbox/docs/intro)

This is an automated release build. You can verify the checksum signature in the assets by using the GPG public key found [here.](http://pool.sks-keyservers.net/pks/lookup?search=0xE8359963&op=vindex)

## Installation

### Manual

You may download the artifacts from assets attached to this release. Doing so requires some additional setup and configuration. See the [docs](https://crypdex.github.io/blackbox/docs/blackbox-os/installation) for more details.

### Linux

There is an APT repository setup for Debian-based systems (like Ubuntu).

```bash
# Add the APT repo to your sources
echo "deb [trusted=yes] https://apt.fury.io/crypdex/ /" > /etc/apt/sources.list.d/fury.list

# Install this package
apt update && apt install blackboxd
```

### macOS

A Homebrew formula is forthcoming. Check back here soon.

### Windows

Sorry.

## General Updates

## Bug fixes

## Changelog

All commits since the last release may be viewed on GitHub [here](https://github.com/crypdex/blackbox/compare/0.1.30...0.1.31)
