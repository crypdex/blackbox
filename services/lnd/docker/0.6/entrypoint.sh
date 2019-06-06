#!/usr/bin/env bash

# CHAIN
# NETWORK
# BACKEND

set -e

# Defaults: bitcoin, bitcoind, simnet

CHAIN=${CHAIN:-bitcoin}

NETWORK=${NETWORK:-simnet}

BACKEND=${BACKEND:-bitcoind}
if [[ "$CHAIN" == "litecoin" ]]; then
  BACKEND="litecoind"
fi

# Setup some default arguments
args=(
  "--$CHAIN.active"
  "--$CHAIN.node"=${BACKEND}
  "--$CHAIN.$NETWORK"
  "--$BACKEND.rpchost"=${BACKEND}
  "--$BACKEND.zmqpubrawblock=tcp://$BACKEND:28333"
  "--$BACKEND.zmqpubrawtx=tcp://$BACKEND:28334"
)


if [[ ${CHAIN} == "bitcoin" ]]; then
  args+=()
  args+=("--$BACKEND.rpcuser=${BITCOIN_RPCUSER:?BITCOIN_RPCUSER is required}")
  args+=("--$BACKEND.rpcpass=${BITCOIN_RPCPASS:?BITCOIN_RPCPASS is required}")
fi

if [[ ${CHAIN} == "litecoin" ]]; then
  args+=("--$BACKEND.rpcuser=${LITECOIN_RPCUSER:?LITECOIN_RPCUSER is required}")
  args+=("--$BACKEND.rpcpass=${LITECOIN_RPCPASS:?LITECOIN_RPCPASS is required}")
fi

#  if [[ ${BACKEND} == "btcd" ]]; then
#    args+=("--$BACKEND.rpccert=/home/btcd/.btcd/rpc.cert")
#  fi

# This is the default datadir, assuming user "lnd"
# We likely do not have to create this as it is managed by the daemon
datadir=/home/lnd/.lnd

# If this script is called only with flags,
# We default to just using the lnd binary and pass it all the args
if [[ $(echo "$1" | cut -c1) = "-" ]]; then
  echo "$0: Executing with arguments for lnd"
  set -- lnd ${args[@]} "$@"
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
# Remember, exec stops execution
if [[ "$1" = "lnd" ]] || [[ "$1" = "lncli" ]] ; then
  exec su-exec lnd "$@"
fi

# lnd or lncli have not been called, so just execute whatever was passed
exec "$@"
