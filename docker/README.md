# Chains

A repository for Crypdex's Docker images

Create a `.env` file in the root of this project with at least the following variables defined:

```bash
# These paths are shared conventionally with all chains
DATA_DIR=/path/to/chaindata
CONF_DIR=/path/to/configs
```

### Check the docker-compose config

```
make config-all
```

## Local Development

When using the Black Box for local development (for the main system), you should set these in a `.env` file in `docker/` so that Docker Compose will pick them up.

```
BLOCKNETDX_PORTS=41414:41414
DASH_PORTS=9998:9998
PIVX_PORTS=51473:51473
ZCOIN_PORTS=8888:8888
```
