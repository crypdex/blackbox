---
title: Conventions
sidebar_label: Conventions
---

The BlackboxOS is really just some conventions wrapped around Docker and `docker-compose` files. These conventions were arrived at through the development of Crypdex's devices and supporting systems.

## Data

One of the biggest challenges of working with blockchain-oriented systems is the management of large amounts of data. The goal of the conventions around data management in BlackboxOS is to ease the seeding of blockchain data from trusted sources (or your own) as you develop new stacks.

Because data is so central to these systems, a global environment variable, `DATA_DIR` is injected into all composed service definitions. Further, for all services, a service namespaced environment variable is also made available in the form of `${SERVICE}_DATA_DIR`.

For example, given the following `blackbox.yml` file

```yml
services: pivx:
```

The following environment variables will be be conventionally available to the service definition - which is just a `docker-compose.yml` file.

```properties
DATA_DIR=~/.crypdex/data
PIVX_DATA_DIR=~/.crypdex/data/pivx
```

Thus, the example `blackbox.yml` file defined above completely satisfies the parameterization requirements of the pivx service definition:

```yaml
version: '3.7'

services:
  pivx:
    image: crypdex/pivx:${PIVX_VERSION:-3.2}
    ports:
      - '51472:51472'
      - '51473:51473'
    volumes:
      - ${PIVX_DATA_DIR:?PIVX_DATA_DIR required}:/home/pivx/.pivx
    command: ${PIVX_COMMAND:--printtoconsole}
```
