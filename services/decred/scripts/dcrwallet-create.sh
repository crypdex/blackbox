#!/usr/bin/env bash

set -u # or set -o nounset
: "$DECRED_DATA_DIR"

args=()
DECRED_NETWORK=${DECRED_NETWORK:-mainnet}
if [[ ${DECRED_NETWORK} == "testnet" ]]; then
  args+=("--testnet")
fi
args+=("--create")

docker run -it -v ${DECRED_DATA_DIR}/dcrwallet:/home/decred/.dcrwallet crypdex/decred dcrwallet ${args[@]}
