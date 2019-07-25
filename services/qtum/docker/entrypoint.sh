#!/bin/sh
set -e

datadir="/home/qtum/.qtum"

if [[ $(echo "$1" | cut -c1) = "-" ]]; then
  echo "$0: assuming arguments for qtumd"

  set -- qtumd "$@"
fi

if [[ $(echo "$1" | cut -c1) = "-" ]] || [[ "$1" = "qtumd" ]]; then
  echo "Creating data directory ..."
  mkdir -p "$datadir"
  chmod 700 "$datadir"
  chown -R qtum "$datadir"

  echo "$0: setting data directory to $datadir"

  set -- "$@" -datadir="$datadir"
fi

if [[ "$1" = "qtumd" ]] || [[ "$1" = "qtum-cli" ]] || [[ "$1" = "qtum-tx" ]]; then
  echo "$@"
  exec su-exec qtum "$@"
fi

echo
exec "$@"
