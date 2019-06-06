#!/bin/bash

set -e

datadir="/home/litecoin/.litecoin"

args=()

NETWORK=${NETWORK:-mainnet}

if [[ ${NETWORK} == "regtest" ]]; then
  args+=("-regtest")
fi

if [[ ${NETWORK} == "testnet" ]]; then
  args+=("-testnet")
fi

# Called only with flags
if [[ $(echo "$1" | cut -c1) = "-" ]]; then
  echo "$0: assuming arguments for litecoind"

  set -- litecoind ${args[@]} "$@"
fi

# Called only with flags or with "litcoind"
if [[ $(echo "$1" | cut -c1) = "-" ]] || [[ "$1" = "litecoind" ]]; then
  mkdir -p "${datadir}"
  chmod 700 "${datadir}"
  chown -R litecoin "${datadir}"

  echo "$0: setting data directory to ${datadir}"

  # this is the default datadir anyway ...
  set -- "$@" -datadir="${datadir}"
fi

if [[ "$1" = "litecoind" ]] || [[ "$1" = "litecoin-cli" ]] || [[ "$1" = "litecoin-tx" ]]; then
  echo "$@"
  exec su-exec litecoin "$@"
fi

echo "$@"
exec "$@"
