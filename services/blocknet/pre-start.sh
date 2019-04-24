#!/usr/bin/env bash

# Get the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


function print() {
    echo "[blocknetdx pre-start] ${1}"
}

print "Configuring Dash"

if [[ -z "${BLOCKNETDX_DATA_DIR}" ]]
then
  echo "BLOCKNETDX_DATA_DIR is empty"
  exit 1
fi



if [[ -d "${BLOCKNETDX_DATA_DIR}" ]]; then
print "✓ Data directory ${BLOCKNETDX_DATA_DIR} exists."
else
    print "Creating directory for data at ${BLOCKNETDX_DATA_DIR}"
    mkdir -p ${BLOCKNETDX_DATA_DIR}
fi

