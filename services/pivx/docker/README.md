# crypdex/pivx

A multiarch PIVX docker image.

[![crypdex/pivx][docker-pulls-image]][docker-hub-url] [![crypdex/pivx][docker-stars-image]][docker-hub-url]

## Tags

- `3.2`, `latest` ([3.2/Dockerfile](https://github.com/crypdex/docker-pivx/blob/master/3.2))
  <!-- - `3.1.1`, `3.1` ([3.1/Dockerfile](https://github.com/crypdex/docker-pivx/blob/master/0.15/Dockerfile)) -->

**Picking the right tag**

- `crypdex/pivx:latest`: points to the latest stable release available of PIVX. Use this only if you know what you're doing as upgrading PIVX blindly is a risky procedure.
- `crypdex/pivx:<version>`: points to a specific version branch or release of PIVX. Uses the pre-compiled binaries which are fully tested by the PIVX team.

## What is PIVX?

PIVX is an open source crypto-currency focused on fast private transactions using the Zerocoin protocol, with low transaction fees & environmental footprint. It utilizes the first ever anonymous proof of stake protocol, called zPoS, combined with regular PoS and masternodes for securing its network. Learn more about [PIVX](https://github.com/PIVX-Project/PIVX).

## Usage

### How to use this image

This image contains the main binaries from the PIVX project - `pivxd`, `pivx-cli` and `pivx-tx`. It behaves like a binary, so you can pass any arguments to the image and they will be forwarded to the `pivxd` binary:

```sh
❯ docker run --rm crypdex/pivx \
  -printtoconsole \
  -rpcallowip=172.17.0.0/16 \
  -rpcauth='foo:1e72f95158becf7170f3bac8d9224$957a46166672d61d3218c167a223ed5290389e9990cc57397d24c979b4853f8e'
```

By default, `pivxd` will run as user `pivx` for security reasons and with its default data dir (`~/.pivx`). If you'd like to customize where `pivxd` stores its data, you must use the `DATA_DIR` environment variable. The directory will be automatically created with the correct permissions for the `pivx` user and `pivxd` automatically configured to use it.

You can also mount a directory in a volume under `/home/pivx/.pivx` in case you want to access it on the host:

```sh
❯ docker run -v ${PWD}/data:/home/pivx/.pivx --rm crypdex/pivx \
  -printtoconsole \
  -regtest=1
```

You can optionally create a service using `docker-compose`:

```yml
pivx:
  image: crypdex/pivx
  command: -printtoconsole
    -regtest=1
```

#### Mainnet

- JSON-RPC/REST: 51473
- P2P: 51472

## License

The [crypdex/pivx][docker-hub-url] docker project is under MIT license.

[docker-hub-url]: https://hub.docker.com/r/crypdex/pivx
[docker-pulls-image]: https://img.shields.io/docker/pulls/crypdex/pivx.svg?style=flat-square
[docker-stars-image]: https://img.shields.io/docker/stars/crypdex/pivx.svg?style=flat-square
