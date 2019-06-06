#!/usr/bin/env bash

set -e

args=()

BITCOIN_NETWORK=${BITCOIN_NETWORK:-mainnet}

if [[ ${BITCOIN_NETWORK} == "regtest" ]]; then
  args+=("-regtest")
fi

if [[ ${BITCOIN_NETWORK} == "testnet" ]]; then
  args+=("-testnet")
fi

if [[ $(echo "$1" | cut -c1) = "-" ]]; then
  echo "$0: assuming arguments for bitcoind"

  set -- bitcoind ${args[@]} "$@"
fi

if [[ $(echo "$1" | cut -c1) = "-" ]] || [[ "$1" = "bitcoind" ]]; then
  mkdir -p "$BITCOIN_DATA"
  chmod 700 "$BITCOIN_DATA"
  chown -R bitcoin "$BITCOIN_DATA"

  echo "$0: setting data directory to $BITCOIN_DATA"

  set -- "$@" -datadir="$BITCOIN_DATA"
fi

if [[ "$1" = "bitcoind" ]] || [[ "$1" = "bitcoin-cli" ]] || [[ "$1" = "bitcoin-tx" ]]; then
  echo su-exec bitcoin "$@"
  exec su-exec bitcoin "$@"
fi

exec "$@"
