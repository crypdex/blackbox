#!/bin/bash
set -e

datadir="/home/pivx/.pivx"

if [[ $(echo "$1" | cut -c1) = "-" ]]; then
  echo "$0: assuming arguments for pivxd"

  set -- pivxd "$@"
fi

if [[ $(echo "$1" | cut -c1) = "-" ]] || [[ "$1" = "pivxd" ]]; then
  echo "Creating data directory ..."
  mkdir -p "$datadir"
  chmod 700 "$datadir"
  chown -R pivx "$datadir"

  echo "$0: setting data directory to $datadir"

  set -- "$@" -datadir="$datadir"
fi

if [[ "$1" = "pivxd" ]] || [[ "$1" = "pivx-cli" ]] || [[ "$1" = "pivx-tx" ]]; then
  echo "$@"
  exec su-exec pivx "$@"
fi

echo
exec "$@"