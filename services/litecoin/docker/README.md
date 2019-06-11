# crypdex/litecoin-core

A Bitcoin Core docker multiarch image. Suitable for `arm64v8` and `amd64` deployments.

[![crypdex/litecoin-core][docker-pulls-image]][docker-hub-url] 
[![crypdex/litecoin-core][docker-stars-image]][docker-hub-url] 

## Tags

- `0.17.1`, `0.17`, `latest` ([0.17/Dockerfile](https://github.com/crypdex/blackbox/blob/master/services/litecoin/docker/0.17/Dockerfile))

**Picking the right tag**

- `crypdex/litecoin-core:latest`: points to the latest stable release available of Litecoin Core. Use this only if you know what you're doing as upgrading Litecoin Core blindly is a risky procedure.
- `crypdex/litecoin-core:<version>`: based on a slim Debian image, points to a specific version branch or release of Litecoin Core. Uses the pre-compiled binaries which are fully tested by the Litecoin Core team.

## Supported Architectures

- Supported architectures:<br/>
  `amd64`, `arm64v8`