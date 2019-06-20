#!/bin/bash

set -e

user=grin
datadir="/home/grin/.grin"

# Called only with flags
if [[ $(echo "$1" | cut -c1) = "-" ]]; then
  echo "$0: assuming arguments for grin"

  set -- grin server run "$@"
fi

# Called only with flags or with "litcoind"
if [[ $(echo "$1" | cut -c1) = "-" ]] || [[ "$1" = "grin" ]]; then
  mkdir -p "${datadir}"
  chmod 700 "${datadir}"
  chown -R grin "${datadir}"

  echo "$0: setting data directory to ${datadir}"

  # this is the default datadir anyway ...
  set -- "$@" -datadir="${datadir}"
fi

if [[ "$1" = "grin" ]]; then
  exec su-exec grin "$@"
fi

exec "$@"
