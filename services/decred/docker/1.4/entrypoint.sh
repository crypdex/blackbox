#!/bin/bash
set -e



user=decred


# ------------
# Default args
# ------------





NETWORK=${NETWORK:-mainnet}
RPCUSER=${RPCUSER:-} # required
RPCPASS=${RPCPASS:-} # required
RPCLISTEN=${RPCLISTEN:-}

args=("--rpclisten=${RPCLISTEN}")

if [[ ${NETWORK} == "testnet" ]]; then
  args+=("--testnet")
fi

#########
# WALLET
#########

if [[ "$1" = "dcrwallet" ]]; then

  args+=("--username=${RPCUSER}")
  args+=("--password=${RPCPASS}")


  if [[ -z "$RPCCERT" ]]; then
    args+=("--rpccert=/home/decred/.dcrwallet/dcrw.cert")
  fi

  if [[ -z "$RPCKEY" ]]; then
    args+=("--rpckey=/home/decred/.dcrwallet/dcrw.key")
  fi

  # THIS IS ONLY FOR DCRWALLET
  if [[ -z "$CAFILE" ]]; then
    args+=("--cafile=/home/decred/.dcrd/dcrd.cert")
  fi
fi

######
# DCRD
######

if [[ $(echo "$1" | cut -c1) = "-" ]] || [[ "$1" = "dcrd" ]]; then

  args+=("--rpcuser=${RPCUSER}")
  args+=("--rpcpass=${RPCPASS}")


  if [[ -z "$RPCKEY" ]]; then
    args+=("--rpckey=/home/decred/.dcrd/dcrd.key")
  fi

  # THIS IS ONLY FOR DCRWALLET
  if [[ -z "$RPCCERT" ]]; then
    args+=("--rpccert=/home/decred/.dcrd/dcrd.cert")
  fi
fi


####################
# Passing only flags - default to DCRD
####################

if [[ $(echo "$1" | cut -c1) = "-" ]]; then
  echo "WARN: Only flags were passed, setting executable to dcrd"
  echo "$0: assuming arguments for dcrd"

  set -- dcrd "$@"
fi


if [[ "$1" = "dcrd" ]]; then
  # This is the default data dir
  appdata="/home/${user}/.dcrd"
  datadir="/home/${user}/.dcrd/data"

  echo "Ensuring $1 data directory $appdata $datadir ..."
  mkdir -p "$datadir" && chmod 700 "$datadir" && chown -R ${user} "$datadir"
  mkdir -p "$appdata" && chmod 700 "$appdata" && chown -R ${user} "$appdata"

  set -- "$@" ${args[@]} --appdata="$appdata" --datadir="$datadir"
fi

if [[ "$1" = "dcrwallet" ]]; then
  # This is the default anyway
  appdata="/home/${user}/.dcrwallet"

  echo "Ensuring $1 data directory $appdata ..."
  mkdir -p "$appdata" && chmod 700 "$appdata" && chown -R ${user} "$appdata"

  set -- "$@" ${args[@]} --appdata="$appdata"
fi


if [[ "$1" = "dcrd" ]] || [[ "$1" = "dcrwallet" ]] || [[ "$1" = "dcrctl" ]]; then
  echo exec su-exec ${user} "$@"
  exec su-exec ${user} "$@"
fi

exec "$@"
