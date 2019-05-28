#!/usr/bin/env bash

set -u # or set -o nounset
: "$DECRED_DATA_DIR"

docker run -it -v ${DECRED_DATA_DIR}/dcrwallet:/home/decred/.dcrwallet crypdex/decred dcrwallet --create