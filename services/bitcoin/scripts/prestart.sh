#!/usr/bin/env bash

# Get the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


function print() {
    echo "[bitcoin] ${1}"
}

print "Configuring Bitcoin"

if [[ -z "${BITCOIN_DATA_DIR}" ]]
then
  echo "BITCOIN_DATA_DIR is empty"
  exit 1
fi



if [[ -d "${BITCOIN_DATA_DIR}" ]]; then
print "✓ Data directory ${BITCOIN_DATA_DIR} exists."
else
    print "Creating directory for data at ${BITCOIN_DATA_DIR}"
    mkdir -p ${BITCOIN_DATA_DIR}
fi
