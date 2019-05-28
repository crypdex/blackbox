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


# -----------
# CONFIG FILE
# -----------

file="${BITCOIN_DATA_DIR}/bitcoin.conf"

if [[ -f "${file}" ]]; then
    print "INFO: Config file ${file} exists. NOT OVERWRITING."
else
    if [[ -z "${BITCOIN_RPCUSER}" ]]
    then
      print "BITCOIN_RPCUSER is empty, generating one"
      BITCOIN_RPCUSER=$(base64 < /dev/urandom | tr -d 'O0Il1+\:/' | head -c 64)
    fi

    if [[ -z "${BITCOIN_RPCPASSWORD}" ]]
    then
      print "BITCOIN_RPCPASSWORD is empty, generating one"
      BITCOIN_RPCPASSWORD=$(base64 < /dev/urandom | tr -d 'O0Il1+\:/' | head -c 64)
    fi
# Be aware that the location of the walletnotify script is relative to the container
cat >${file} <<EOF
rpcuser=${BITCOIN_RPCUSER}
rpcpassword=${BITCOIN_RPCPASSWORD}
EOF
fi


