#!/usr/bin/env bash

# ---------------
# Decred Prestart
# ---------------
# * Create the default data directories
# *


# Get the location of this script
__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


function print() {
    echo "[decred] ${1}"
}

function error() {
    >&2 echo "[decred] ${1}"
}

function fatal() {
    >&2 echo "[decred] FATAL: ${1}"
    exit 1
}

print "Configuring Decred ..."

########################
# Create the directories
########################

# Make sure that root is defined.
if [[ -z "${DECRED_DATA_DIR}" ]]; then
  print "DECRED_DATA_DIR is empty"
  exit 1
fi

dirs="${DECRED_DATA_DIR} ${DECRED_DATA_DIR}/dcrd ${DECRED_DATA_DIR}/dcrwallet"
for dir in ${dirs}; do
  if [[ -d "${dir}" ]]; then
    print "✓ Directory ${dir} exists."
  else
    print "Creating directory: ${dir}"
    mkdir -p ${dir}
  fi
done

########################
# Generate the TLS certs
########################

for service in dcrd dcrwallet; do
  print "Generating ${service} TLS certs"
  prefix=${DECRED_DATA_DIR}/${service}/${service}
  # Generate a key file
  output=$(openssl ecparam -name secp521r1 -genkey -out ${prefix}.key 2>&1)
  if [ $? -eq 1 ]; then
    fatal ${output}
  fi

  output=$(openssl req -new -out ${prefix}.csr -key ${prefix}.key -config ${__dir}/openssl-decred.cnf -subj "/CN=dcrd cert" 2>&1)
  if [ $? -eq 1 ]; then
    fatal "${output}"
  fi

  #openssl req -text -noout -in dcrd.csr
  output=$(openssl x509 -req -days 36500 -in ${prefix}.csr -signkey ${prefix}.key -out ${prefix}.cert -extensions v3_req -extfile ${__dir}/openssl-decred.cnf 2>&1)
  if [ $? -eq 1 ]; then
    fatal ${output}
  fi

  #openssl x509 -text -in dcrd.cert
done


#####################
# Check for a wallet: MAINNET ONLY RIGHT NOW
#####################

DECRED_NETWORK=${DECRED_NETWORK:-mainnet}
print "Checking for ${DECRED_NETWORK} wallet"
WALLET_FILE=${DECRED_DATA_DIR}/dcrwallet/${DECRED_NETWORK}/wallet.db
if [[ ! -f "$WALLET_FILE" ]]; then
  source ${__dir}/../bin/dcrwallet-create

  # echo
  # echo "GENERATE YOUR WALLET WITH THIS COMMAND:"
  # echo
  # echo "DECRED_DATA_DIR=${DECRED_DATA_DIR} ${p}/dcrwallet-create"
  # echo
  # fatal "wallet for ${DECRED_NETWORK} doesnt exist."
fi

