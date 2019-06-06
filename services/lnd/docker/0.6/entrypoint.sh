#!/bin/bash

set -e

# CHAIN: bitcoin or litecoin



# This is the default datadir, assuming user "lnd"
# We likely do not have to create this as it is managed by the daemon
datadir=/home/lnd/.lnd

# If this script is called only with flags,
# We default to just using the lnd binary and pass it all the args
if [[ $(echo "$1" | cut -c1) = "-" ]]; then
  echo "$0: Executing with arguments for lnd"
  set -- lnd "$@"
fi

if [[ $(echo "$1" | cut -c1) = "-" ]] || [[ "$1" = "lnd" ]]; then
  echo "$0: Creating data directory ..."
  mkdir -p "$datadir"
  chmod 700 "$datadir"
  chown -R lnd "$datadir"

  echo "$0: Setting data directory to $datadir"

  set -- "$@"
fi

echo "$0: Executing command => \"$@\""

# lnd or lncli have been called, execute using su-exec
if [[ "$1" = "lnd" ]] || [[ "$1" = "lncli" ]] ; then
  exec su-exec lnd "$@"
fi

# lnd or lncli have not been called, so just execute whatever was passed
exec "$@"
