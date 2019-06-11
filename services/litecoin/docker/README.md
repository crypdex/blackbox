<a href="https://crypdex.io">
  <img src="https://raw.githubusercontent.com/crypdex/blackbox/master/docs/assets/logo2.png" width=300>
</a>




# Litecoin Core 



**A clean Litecoin Core multiarch image suitable for deployment on a range of targets from SBCs to the cloud.**

This image is maintained as part of the **[Blackbox](https://github.com/crypdex/blackbox)** framework.

![docker pulls](https://img.shields.io/docker/pulls/crypdex/litecoin-core.svg?style=flat-square)



## Tags

- `0.17.1`, `0.17`, `latest` ([0.17/Dockerfile](https://github.com/crypdex/blackbox/blob/master/services/litecoin/docker/0.17/Dockerfile))

**Picking the right tag**

- `crypdex/litecoin-core:latest`: points to the latest stable release available of Litecoin Core. Use this only if you know what you're doing as upgrading Litecoin Core blindly is a risky procedure.
- `crypdex/litecoin-core:<version>`: based on a slim Debian image, points to a specific version branch or release of Litecoin Core. Uses the pre-compiled binaries which are fully tested by the Litecoin Core team.

## Supported Architectures

- Supported architectures:<br/>
  `amd64`, `arm64v8`
  
## Basic Usage

This image contains the main binaries from the Litecoin Core project:

- `litecoind`
- `litecoin-cli`
- `litecoin-tx` 

It behaves like a binary, so you can pass any arguments to the image and they will be forwarded to `litecoind`:

```shell
❯ docker run --rm crypdex/litecoin-core -regtest=1 -printtoconsole
```

Or you may specify the binary to call, like `litecoin-cli`:

```shell
❯ docker run --rm crypdex/litecoin-core litecoin-cli getinfo
``` 

By default, litecoind will run as user `litecoin` for security reasons.

## Volume Mounts

The container uses Litecoin's default data directory, `~/.litecoin`. As such you can mount a persistent volume like so

```shell
❯ docker run -v ${PWD}/data:/home/litecoin/.litecoin --rm crypdex/litecoin-core -regtest=1 -printtoconsole
```

## Docker Compose

A minimal `docker-compose.yml` file might look like this

```yaml
litecoin-core:
  image: crypdex/litecoin-core
  command:
    -printtoconsole
    -regtest=1
```
## Credits

Modified from the original at [`uphold/litecoin-core`](https://hub.docker.com/r/uphold/litecoin-core) to accomidate multiarch deployment.