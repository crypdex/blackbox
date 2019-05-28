# Decred

The `decred` service is composed of 2 individual services: `dcrd` and `dcrwallet`. These sub-services are not currently separable from the main `decred` service since they function together.

To use the recipe, configure you `blackbox.yml` file as follows:

```yaml
version: '3.7'

x-blackbox:
  data_dir: /Volumes/T5/data
  recipe: decred
```

## Setup Summary

1. Add the decred service or recipe to your `blackbox.yaml` file.
1. Run `blackboxd start` and initialize the wallet, following the prompts.
1. Add `DECRED_WALLET_PASSWORD` to `.env` or to the shell's environment.

## Initial Boot

When Decred first boots in `blackboxd`, you will be prompted to initialize a wallet manually. Once this is done, you should be able to reliably boot `blackboxd` unattended. 

## Environment Variables

The following environment variables should be set. 

```.env
DECRED_WALLET_PASSWORD=<somethinggoodnstrong>
```

You may `export` these in the shell before startup, or put them in a `.env` file at the root of the blackbox dir.

