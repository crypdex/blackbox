# crypdex/bitcoin-core

A Bitcoin Core docker multiarch image. Suitable for `arm64v8` and `amd64` deployments.

[![uphold/litecoin-core][docker-pulls-image]][docker-hub-url] [![uphold/litecoin-core][docker-stars-image]][docker-hub-url] [![uphold/litecoin-core][docker-size-image]][docker-hub-url] [![uphold/litecoin-core][docker-layers-image]][docker-hub-url]

## Tags

- `0.17.1`, `0.17`, `latest` ([0.17/Dockerfile](https://github.com/crypdex/blackbox/blob/master/services/bitcoin/docker/0.17/Dockerfile))

**Picking the right tag**

- `crypdex/bitcoin-core:latest`: points to the latest stable release available of Bitcoin Core. Use this only if you know what you're doing as upgrading Bitcoin Core blindly is a risky procedure.
- `crypdex/bitcoin-core:<version>`: based on a slim Debian image, points to a specific version branch or release of Bitcoin Core. Uses the pre-compiled binaries which are fully tested by the Bitcoin Core team.

## Supported Architectures

- Supported architectures: (more info)<br/>
  `amd64`, `arm64v8`
