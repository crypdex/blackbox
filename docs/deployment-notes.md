## Multi-arch and Docker Manifests

All images are developed to be multi-architecture using Docker's manifest files. This means that the `docker-compose.yml` files can point to generic images like `crypdex/pivx:latest` and the manifest will point it to the right file.

- [Docker Multi-Architecture Images](https://medium.com/@mauridb/docker-multi-architecture-images-365a44c26be6)
- [Docker manifest reference](https://docs.docker.com/engine/reference/commandline/manifest/)

## Docker Compose

At the moment, Docker Compose is the most reliable way to get a multi-container docker scenario working predictably across both Mac development and arm64 deployments.

## Docker Swarm

As of Feb 23 2019, Docker Swarm has been tested for use in SBC deployments and has been found to be unsuitable.

Docker Swarm seems to work ok, but has 2 major quicks that prevent usage in this context

- In the postgres image (and maybe others), if the data directory does not exist, the container silently fails to start. I have been unable to locate logging that informs of this error.
- **Show stopper:** Port mappings cannot be restricted to localhost. Swarm exposes all ports publically on purpose with no remove. The `host` variable in ports long syntax does not seem to help this situation.
- Images created for `arm64v8` are supported on Docker for Mac, but they do not seem to work properly on Docker Swarm using a `docker stack deploy`. The replicas just never come up.
- Generally I have found it hard to determine why a service fails to start in Swarm

## K8s

I did some experimentation with [microk8s](https://github.com/ubuntu/microk8s) on the ODROID-C2 and just ended up with kernel panics. Will try again as the project matures (ours and theirs).

This is likely the thing to use moving forward. Might be worth looking at this article:

https://itnext.io/building-an-arm-kubernetes-cluster-ef31032636f9
