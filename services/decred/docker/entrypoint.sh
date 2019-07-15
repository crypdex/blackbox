#!/bin/bash
set -e

user=decred
# This is the default data dir
datadir="/home/${user}/.dcrd"

if [[ $(echo "$1" | cut -c1) = "-" ]]; then
  echo "$0: assuming arguments for dcrd"

  set -- dcrd "$@"
fi

if [[ $(echo "$1" | cut -c1) = "-" ]] || [[ "$1" = "dcrd" ]]; then
  echo "Creating data directory ..."
  mkdir -p "$datadir"
  chmod 700 "$datadir"
  chown -R ${user} "$datadir"

  echo "$0: setting data directory to $datadir"

  set -- "$@" --datadir="$datadir"
fi

if [[ "$1" = "dcrd" ]] || [[ "$1" = "dcrwallet" ]] || [[ "$1" = "dcrctl" ]]; then
  exec su-exec ${user} "$@"
fi

exec "$@"
