---
title: Configuration
sidebar_label: Configuration
---

BlackboxOS stacks are configured with `yml` files. These configuration files look very similar to `docker-compose.yml` files, but they are not a superset. Rather they are used to parameterize services, which _are_ in fact `docker-compose.yml` files.

## Defaults

## Services

Services are defined at the key `services`. Each sub-key names the service you would like in your stack. The executable `blackboxd` uses these keys to look for the service definition files.

Take this simple definition which runs a stack with only PIVX in it and leaves it's defaults untouched.

```
services:
  pivx:
```

Parameters available in the service definition can be given values like so.

```yaml
services:
  pivx:
    data_dir: /mnt/bigassdrive1/pivx
```
