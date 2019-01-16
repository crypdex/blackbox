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
