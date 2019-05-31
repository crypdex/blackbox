#!/usr/bin/env bash

# Make sure that root is defined.
if [[ -z "${BITCOIN_RPCUSER}" ]]; then
  print "BITCOIN_RPCUSER is empty"
  exit 1
fi