#!/usr/bin/env bash

set -e

user=dash
datadir="/home/${user}/.dash"

if [[ $(echo "$1" | cut -c1) = "-" ]]; then
  echo "$0: assuming arguments for dashd"

  set -- dashd "$@"
fi

if [[ $(echo "$1" | cut -c1) = "-" ]] || [[ "$1" = "dashd" ]]; then
  mkdir -p ${datadir}
  chmod 700 ${datadir}
  chown -R ${user} ${datadir}

  echo "$0: setting data directory to ${datadir}"

  set -- "$@" -datadir=${datadir}
fi

if [[ "$1" = "dashd" ]] || [[ "$1" = "dash-cli" ]] || [[ "$1" = "dash-tx" ]]; then
  exec su-exec dash "$@"
fi

exec "$@"
