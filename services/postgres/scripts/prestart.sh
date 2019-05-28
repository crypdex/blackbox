#!/usr/bin/env bash

# Get the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


function print() {
    echo "[postgres] ${1}"
}

# The PIVX pre-start needs to do the following
# - Ensure that the data directory exists!
# - Create the pivx.conf file
# - Create the walletnotify.sh file

print "Configuring Postgres"

if [[ -z "${POSTGRES_DATA_DIR}" ]]
then
  echo "POSTGRES_DATA_DIR variable is empty"
  exit 1
fi


# 1. Ensure that the data directory exists!
if [[ -d "${POSTGRES_DATA_DIR}" ]]; then
print "✓ Data directory ${POSTGRES_DATA_DIR} exists."
else
    print "Creating directory for data at ${POSTGRES_DATA_DIR}"
    mkdir -p ${POSTGRES_DATA_DIR}
fi
