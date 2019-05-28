#!/usr/bin/env bash

# Get the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


function print() {
    echo "[navcoin] ${1}"
}

# The PIVX pre-start needs to do the following
# - Ensure that the data directory exists!
# - Create the navcoin.conf file
# - Create the walletnotify.sh file

print "Configuring NavCoin"

if [[ -z "${NAVCOIN_DATA_DIR}" ]]
then
  echo "NAVCOIN_DATA_DIR is empty"
  exit 1
fi


# 1. Ensure that the data directory exists!
if [[ -d "${NAVCOIN_DATA_DIR}" ]]; then
  print "✓ Data directory ${NAVCOIN_DATA_DIR} exists."
else
  print "Creating directory for data at ${NAVCOIN_DATA_DIR}"
  mkdir -p ${NAVCOIN_DATA_DIR}
fi


# -----------
# CONFIG FILE
# -----------
# Does not overwrite existing files. No option to force

file="${NAVCOIN_DATA_DIR}/navcoin.conf"

if [[ -f "${file}" ]]; then
    print "INFO: Config file ${file} exists. Not overwriting."
else
    print "Writing default config for NavCoin to ${file}"
    if [[ -z "${NAVCOIN_RPCUSER}" ]]; then
      print "NAVCOIN_RPCUSER is empty, generating one"
      NAVCOIN_RPCUSER=$(base64 < /dev/urandom | tr -d 'O0Il1+\:/' | head -c 32)
    fi

    if [[ -z "${NAVCOIN_RPCPASSWORD}" ]]; then
      print "NAVCOIN_RPCPASSWORD is empty, generating one"
      NAVCOIN_RPCPASSWORD=$(base64 < /dev/urandom | tr -d 'O0Il1+\:/' | head -c 32)
    fi

# Be aware that the location of the walletnotify script is relative to the container
cat >${file} <<EOF
rpcuser=${NAVCOIN_RPCUSER}
rpcpassword=${NAVCOIN_RPCPASSWORD}
EOF
fi


