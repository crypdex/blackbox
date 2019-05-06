#!/usr/bin/env bash

# Get the location of this script
__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


function print() {
    echo "[sparkswap pre-start] ${1}"
}

print "Configuring Sparkswap"

if [[ -z "${SPARKSWAP_DATA_DIR}" ]]
then
  echo "SPARKSWAP_DATA_DIR is empty"
  exit 1
fi


if [[ -d "${SPARKSWAP_DATA_DIR}/lnd_ltc" ]]; then
print "✓ Data directory ${SPARKSWAP_DATA_DIR}/lnd_ltc exists."
else
    print "Creating directory for data at ${SPARKSWAP_DATA_DIR}/lnd_ltc"
    mkdir -p ${SPARKSWAP_DATA_DIR}/lnd_ltc
fi

if [[ -d "${SPARKSWAP_DATA_DIR}/lnd_btc" ]]; then
print "✓ Data directory ${SPARKSWAP_DATA_DIR}/lnd_btc exists."
else
    print "Creating directory for data at ${SPARKSWAP_DATA_DIR}/lnd_btc"
    mkdir -p ${SPARKSWAP_DATA_DIR}/lnd_btc
fi


if [[ -d "${SPARKSWAP_DATA_DIR}/shared" ]]; then
print "✓ Data directory ${SPARKSWAP_DATA_DIR}/shared exists."
else
    print "Creating directory for data at ${SPARKSWAP_DATA_DIR}/shared"
    mkdir -p ${SPARKSWAP_DATA_DIR}/shared
fi


if [[ -d "${SPARKSWAP_DATA_DIR}/data" ]]; then
print "✓ Data directory ${SPARKSWAP_DATA_DIR}/data exists."
else
    print "Creating directory for data at ${SPARKSWAP_DATA_DIR}/data"
    mkdir -p ${SPARKSWAP_DATA_DIR}/data
fi

# Execute using the same bash process
source ${__dir}/generate-id-and-certs.sh