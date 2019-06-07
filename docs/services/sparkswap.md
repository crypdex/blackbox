## Environment Variables

```.env
SPARKSWAP_RPC_USER
SPARKSWAP_RPC_PASSWORD


BITCOIN_RPCUSER
BITCOIN_RPCPASS
# Defaults
BITCOIN_RPCHOST=bitcoin
```

## Changes

Tried to consolidate all Sparkswap related filed to the DATA_DIR

Trying to make it more configurable

These environment variables were changed/converted

- `SPARKSWAP_SECURE_PATH` => `SPARKSWAP_DATA_DIR`
- `SPARKSWAP_BROKER_RPC_USER` => `SPARKSWAP_RPC_USER`
- `SPARKSWAP_BROKER_RPC_ADDRESS` => `SPARKSWAP_RPC_ADDRESS`
- `SPARKSWAP_PRC_PASSWORD` => `SPARKSWAP_RPC_PASS`
