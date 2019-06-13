#!/usr/bin/env bash

# Get the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


function print() {
    echo "[litecoin] ${1}"
}

if [[ -z "${LITECOIN_DATA_DIR}" ]]
then
  echo "LITECOIN_DATA_DIR is empty"
  exit 1
fi


if [[ -d "${LITECOIN_DATA_DIR}" ]]; then
    print "✓ Data directory ${LITECOIN_DATA_DIR} exists."
else
    print "Creating directory for data at ${LITECOIN_DATA_DIR}"
    mkdir -p ${LITECOIN_DATA_DIR}
fi
