#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for pivxd"

  set -- pivxd "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "pivxd" ]; then
  echo "Creating data directory ..."
  mkdir -p "$DATA_DIR"
  chmod 700 "$DATA_DIR"
  chown -R pivx "$DATA_DIR"

  echo "$0: setting data directory to $DATA_DIR"

  set -- "$@" -datadir="$DATA_DIR"
fi

if [ "$1" = "pivxd" ] || [ "$1" = "pivx-cli" ] || [ "$1" = "pivx-tx" ]; then
  echo "$@"
  exec su-exec pivx "$@"
fi

echo
exec "$@"
