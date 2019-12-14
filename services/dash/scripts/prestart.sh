#!/usr/bin/env bash

# Get the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


function print() {
    echo "[dash] ${1}"
}

print "Configuring Dash"

if [[ -z "${DASH_DATA_DIR}" ]]
then
  echo "DASH_DATA_DIR is empty"
  exit 1
fi



if [[ -d "${DASH_DATA_DIR}" ]]; then
print "✓ Data directory ${DASH_DATA_DIR} exists."
else
    print "Creating directory for data at ${DASH_DATA_DIR}"
    mkdir -p ${DASH_DATA_DIR}
fi
