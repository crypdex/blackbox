#!/usr/bin/env bash

# Get the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


function print() {
    echo "[blocknetdx pre-start] ${1}"
}

print "Configuring Blocknet"

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

if [[ -z "${BLOCKNETDX_RPCUSER}" ]]
then
  print "BLOCKNETDX_RPCUSER is empty, generating one"
  BLOCKNETDX_RPCUSER=$(base64 < /dev/urandom | tr -d 'O0Il1+\:/' | head -c 64)
fi

if [[ -z "${BLOCKNETDX_RPCPASSWORD}" ]]
then
  print "BLOCKNETDX_RPCPASSWORD is empty, generating one"
  BLOCKNETDX_RPCPASSWORD=$(base64 < /dev/urandom | tr -d 'O0Il1+\:/' | head -c 64)
fi

# -----------
# CONFIG FILE
# -----------

file="${BLOCKNETDX_DATA_DIR}/blocknetdx.conf"

if [[ -f "${file}" ]]; then
    print "WARN: Config file ${file} exists. Not overwriting."
else
# Be aware that the location of the walletnotify script is relative to the container
cat >${file} <<EOF
rpcuser=${BLOCKNETDX_RPCUSER}
rpcpassword=${BLOCKNETDX_RPCPASSWORD}
EOF
fi


