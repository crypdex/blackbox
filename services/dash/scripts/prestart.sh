#!/usr/bin/env bash

# Get the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


function print() {
    echo "[dash pre-start] ${1}"
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


#if [[ -z "${LITECOIN_RPCUSER}" ]]
#then
#  print "LITECOIN_RPCUSER is empty, generating one"
#  LITECOIN_RPCUSER=$(base64 < /dev/urandom | tr -d 'O0Il1+\:/' | head -c 64)
#fi
#
#if [[ -z "${LITECOIN_RPCPASSWORD}" ]]
#then
#  print "LITECOIN_RPCPASSWORD is empty, generating one"
#  LITECOIN_RPCPASSWORD=$(base64 < /dev/urandom | tr -d 'O0Il1+\:/' | head -c 64)
#fi

# -----------
# CONFIG FILE
# -----------

#file="${DASH_DATA_DIR}/litecoin.conf"
#
#if [[ -f "${file}" ]]; then
#    print "WARN: Config file ${file} exists. Overwriting."
#fi

# Be aware that the location of the walletnotify script is relative to the container
# cat >${file} <<EOF
# rpcuser=${LITECOIN_RPCUSER}
#rpcpassword=${LITECOIN_RPCPASSWORD}
#EOF

