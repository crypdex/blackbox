#!/usr/bin/env bash

set -e

datadir="/home/${user}/.bitcoin"

if [[ $(echo "$1" | cut -c1) = "-" ]]; then
  echo "$0: assuming arguments for bitcoind"

  set -- bitcoind "$@"
fi

if [[ $(echo "$1" | cut -c1) = "-" ]] || [[ "$1" = "bitcoind" ]]; then
  mkdir -p ${datadir}
  chmod 700 ${datadir}
  chown -R bitcoin ${datadir}

  echo "$0: setting data directory to ${datadir}"

  set -- "$@" -datadir=${datadir}
fi

if [[ "$1" = "bitcoind" ]] || [[ "$1" = "bitcoin-cli" ]] || [[ "$1" = "bitcoin-tx" ]]; then
  exec su-exec bitcoin "$@"
fi

exec "$@"
