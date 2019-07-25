#!/bin/bash
set -e

datadir="/home/blocknetdx/.blocknetdx"

if [[ $(echo "$1" | cut -c1) = "-" ]]; then
  echo "$0: assuming arguments for blocknetdxd"

  set -- blocknetdxd "$@"
fi

if [[ $(echo "$1" | cut -c1) = "-" ]] || [[ "$1" = "blocknetdxd" ]]; then
  echo "Creating data directory ..."
  mkdir -p "$datadir"
  chmod 700 "$datadir"
  chown -R blocknetdx "$datadir"

  echo "$0: setting data directory to $datadir"

  set -- "$@" -datadir="$datadir"
fi

if [[ "$1" = "blocknetdxd" ]] || [[ "$1" = "blocknetdx-cli" ]] || [[ "$1" = "blocknetdx-tx" ]]; then
  echo "$@"
  exec su-exec blocknetdx "$@"
fi

echo
exec "$@"