#!/usr/bin/env bash


function print() {
    echo "[portainer pre-start] ${1}"
}

# The PIVX pre-start needs to do the following
# - Ensure that the data directory exists!
# - Create the pivx.conf file
# - Create the walletnotify.sh file

print "Configuring Portainer"

if [[ -z "${PORTAINER_DATA_DIR}" ]]
then
  echo "PORTAINER_DATA_DIR variable is empty"
  exit 1
fi


# 1. Ensure that the data directory exists!
if [[ -d "${PORTAINER_DATA_DIR}" ]]; then
print "✓ Data directory ${PORTAINER_DATA_DIR} exists."
else
    print "Creating directory for data at ${PORTAINER_DATA_DIR}"
    mkdir -p ${PORTAINER_DATA_DIR}
fi
