#!/bin/bash

set -e

user=zcoin
datadir="/home/zcoin/.zcoin"

# Called only with flags
if [[ $(echo "$1" | cut -c1) = "-" ]]; then
  echo "$0: assuming arguments for zcoind"

  set -- zcoind ${args[@]} "$@"
fi

# Called only with flags or with "litcoind"
if [[ $(echo "$1" | cut -c1) = "-" ]] || [[ "$1" = "zcoind" ]]; then
  mkdir -p "${datadir}"
  chmod 700 "${datadir}"
  chown -R zcoin "${datadir}"

  echo "$0: setting data directory to ${datadir}"

  # this is the default datadir anyway ...
  set -- "$@" -datadir="${datadir}"
fi

if [[ "$1" = "zcoind" ]] || [[ "$1" = "zcoin-cli" ]] || [[ "$1" = "zcoin-tx" ]]; then
  exec su-exec zcoin "$@"
fi

exec "$@"