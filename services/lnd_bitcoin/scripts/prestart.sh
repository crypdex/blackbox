#!/usr/bin/env bash

function print() {
    echo -e "[lnd_bitcoin] ${1}"
}

# Make sure that root is defined.
if [[ -z "${BITCOIN_RPCUSER}" ]]; then
  print "BITCOIN_RPCUSER is empty"
  exit 1
fi

# Make sure that root is defined.
if [[ -z "${BITCOIN_RPCPASS}" ]]; then
  print "BITCOIN_RPCPASS is empty"
  exit 1
fi