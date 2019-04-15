#!/usr/bin/env bash

# Get the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


function print() {
    echo "[qtum pre-start] ${1}"
}

# The PIVX pre-start needs to do the following
# - Ensure that the data directory exists!
# - Create the qtum.conf file
# - Create the walletnotify.sh file

print "Configuring QTUM"

if [[ -z "${QTUM_DATA_DIR}" ]]
then
  echo "QTUM_DATA_DIR is empty"
  exit 1
fi


# 1. Ensure that the data directory exists!
if [[ -d "${QTUM_DATA_DIR}" ]]; then
print "✓ Data directory ${QTUM_DATA_DIR} exists."
else
    print "Creating directory for data at ${QTUM_DATA_DIR}"
    mkdir -p ${QTUM_DATA_DIR}
fi

if [[ -z "${QTUM_RPCUSER}" ]]
then
  print "QTUM_RPCUSER is empty, generating one"
  QTUM_RPCUSER=$(base64 < /dev/urandom | tr -d 'O0Il1+\:/' | head -c 64)
fi

if [[ -z "${QTUM_RPCPASSWORD}" ]]
then
  print "QTUM_RPCPASSWORD is empty, generating one"
  QTUM_RPCPASSWORD=$(base64 < /dev/urandom | tr -d 'O0Il1+\:/' | head -c 64)
fi

# -----------
# CONFIG FILE
# -----------
# Does not overwrite existing files. No option to force

file="${QTUM_DATA_DIR}/qtum.conf"

if [[ -f "${file}" ]]; then
    print "WARN: Config file ${file} exists. Not overwriting."
else
    print "Writing default config for QTUM to ${file}"

# Be aware that the location of the walletnotify script is relative to the container
cat >${file} <<EOF
rpcuser=${QTUM_RPCUSER}
rpcpassword=${QTUM_RPCPASSWORD}
EOF
fi


