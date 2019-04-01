#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for zcoind"

  set -- zcoind "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "zcoind" ]; then
  echo "Creating data directory ..."
  mkdir -p "$DATA_DIR"
  chmod 700 "$DATA_DIR"
  chown -R zcoin "$DATA_DIR"

  echo "$0: setting data directory to $DATA_DIR"

  set -- "$@" -datadir="$DATA_DIR"
fi

if [ "$1" = "zcoind" ] || [ "$1" = "zcoin-cli" ] || [ "$1" = "zcoin-tx" ]; then
  echo "$@"
  exec gosu zcoin "$@"
fi

echo
exec "$@"
