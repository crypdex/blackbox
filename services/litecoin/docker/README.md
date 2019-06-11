# crypdex/litecoin-core

A Litecoin Core docker multiarch image. Suitable for `arm64v8` and `amd64` deployments.

![docker pulls](https://img.shields.io/docker/pulls/crypdex/litecoin-core.svg?style=flat-square)

## Tags

- `0.17.1`, `0.17`, `latest` ([0.17/Dockerfile](https://github.com/crypdex/blackbox/blob/master/services/litecoin/docker/0.17/Dockerfile))

**Picking the right tag**

- `crypdex/litecoin-core:latest`: points to the latest stable release available of Litecoin Core. Use this only if you know what you're doing as upgrading Litecoin Core blindly is a risky procedure.
- `crypdex/litecoin-core:<version>`: based on a slim Debian image, points to a specific version branch or release of Litecoin Core. Uses the pre-compiled binaries which are fully tested by the Litecoin Core team.

## Supported Architectures

- Supported architectures:<br/>
  `amd64`, `arm64v8`
  
## Usage

### How to use this image

This image contains the main binaries from the Litecoin Core project:

- `litecoind`
- `litecoin-cli`
- `litecoin-tx` 

It behaves like a binary, so you can pass any arguments to the image and they will be forwarded to the  `litecoind`  binary:

```
❯ docker run --rm crypdex/litecoin-core -regtest=1 -printtoconsole
```

Or you may specify the binary to call, like `litecoin-cli`:

```
❯ docker run --rm crypdex/litecoin-core litecoin-cli getinfo
``` 

By default, litecoind will run as user `litecoin` for security reasons and with its default data dir (~/.litecoin). 

#### Mount Volumes
#### Docker Compose