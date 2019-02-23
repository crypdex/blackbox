#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for blocknetdxd"

  set -- blocknetdxd "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "blocknetdxd" ]; then
  echo "Creating data directory ..."
  mkdir -p "$DATA_DIR"
  chmod 700 "$DATA_DIR"
  chown -R blocknetdx "$DATA_DIR"

  echo "$0: setting data directory to $DATA_DIR"

  set -- "$@" -datadir="$DATA_DIR"
fi

if [ "$1" = "blocknetdxd" ] || [ "$1" = "blocknetdx-cli" ] || [ "$1" = "blocknetdx-tx" ]; then
  echo "$@"
  exec gosu blocknetdx "$@"
fi

echo
exec "$@"
