#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for dashd"

  set -- dashd "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "dashd" ]; then
  echo "Creating data directory ..."
  mkdir -p "$DATA_DIR"
  chmod 700 "$DATA_DIR"
  chown -R dash "$DATA_DIR"

  echo "$0: setting data directory to $DATA_DIR"

  set -- "$@" -datadir="$DATA_DIR"
fi

if [ "$1" = "dashd" ] || [ "$1" = "dash-cli" ] || [ "$1" = "dash-tx" ]; then
  echo "$@"
  exec su-exec dash "$@"
fi

echo
exec "$@"
