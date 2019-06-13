<a href="https://crypdex.io">
  <img src="https://raw.githubusercontent.com/crypdex/blackbox/master/docs/assets/logo2.png" width=300>
</a>




# Bitcoin Core 



**A clean Bitcoin Core multiarch image suitable for deployment on a range of targets from SBCs to the cloud.**

This image is maintained as part of the **[Blackbox](https://crypdex.github.com/blackbox)** framework.

![docker pulls](https://img.shields.io/docker/pulls/crypdex/bitcoin-core.svg?style=flat-square)



## Tags

- `0.17.1`, `0.17`, `latest` ([0.17/Dockerfile](https://github.com/crypdex/blackbox/blob/master/services/bitcoin/docker/0.17/Dockerfile))

**Picking the right tag**

- `crypdex/bitcoin-core:latest`: points to the latest stable release available of Bitcoin Core. Use this only if you know what you're doing as upgrading Bitcoin Core blindly is a risky procedure.
- `crypdex/bitcoin-core:<version>`: based on a slim Debian image, points to a specific version branch or release of Bitcoin Core. Uses the pre-compiled binaries which are fully tested by the Bitcoin Core team.

## Supported Architectures

- Supported architectures:<br/>
  `amd64`, `arm64v8`
  
## Basic Usage

This image contains the main binaries from the Bitcoin Core project:

- `bitcoind`
- `bitcoin-cli`
- `bitcoin-tx` 

It behaves like a binary, so you can pass any arguments to the image and they will be forwarded to `bitcoind`:

```shell
❯ docker run --rm crypdex/bitcoin-core -regtest=1 -printtoconsole
```

Or you may specify the binary to call, like `bitcoin-cli`:

```shell
❯ docker run --rm crypdex/bitcoin-core bitcoin-cli getinfo
``` 

By default, bitcoind will run as user `bitcoin` for security reasons.

## Volume Mounts

The container uses Bitcoin's default data directory, `~/.bitcoin`. As such you can mount a persistent volume like so

```shell
❯ docker run -v ${PWD}/data:/home/bitcoin/.bitcoin --rm crypdex/bitcoin-core -regtest=1 -printtoconsole
```

## Docker Compose

A minimal `docker-compose.yml` file might look like this

```yaml
bitcoin-core:
  image: crypdex/bitcoin-core
  command:
    -printtoconsole
    -regtest=1
```
## Credits

Modified from the original at [`uphold/bitcoin-core`](https://hub.docker.com/r/uphold/bitcoin-core) to accommodate multiarch deployment.