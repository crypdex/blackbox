#!/usr/bin/env bash

set -e

# Defaults
NETWORK=${NETWORK:-simnet}

CHAIN=${CHAIN:-bitcoin}

BACKEND=${BACKEND:-bitcoind}
if [[ "$CHAIN" == "litecoin" ]]; then
  BACKEND="litecoind"
fi
#NETWORK=$(set_default "$NETWORK" "simnet")
#CHAIN=$(set_default "$CHAIN" "bitcoin")

args=()
args+=("--$CHAIN.active")
args+=("--$CHAIN.node"=${BACKEND})
args+=("--$CHAIN.$NETWORK")
args+=("--$CHAIN.rpchost"=${BACKEND})
args+=("--$BACKEND.zmqpubrawblock=tcp://$BACKEND:28333")
args+=("--$BACKEND.zmqpubrawtx=tcp://$BACKEND:28334")


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
#  mkdir -p "$datadir"
#  chmod 700 "$datadir"
#  chown -R lnd "$datadir"

  echo "$0: Setting data directory to $datadir"

  set -- "$@"
fi

echo "$0: Executing command => \"$@\""

# lnd or lncli have been called, execute using su-exec
if [[ "$1" = "lnd" ]] || [[ "$1" = "lncli" ]] ; then
  echo exec su-exec lnd "$@"
  exit 0
fi

# lnd or lncli have not been called, so just execute whatever was passed
echo exec ${args[@]} "$@"
