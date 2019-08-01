#!/usr/bin/env bash

# ---------------
# Decred Prestart
# ---------------
# * Create the default data directories
# *

RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Get the location of this script
__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


function print() {
    echo -e "[decred] ${1}"
}

function error() {
    >&2 echo -e "[decred] ${RED}${1}${NC}"
}

function fatal() {
    >&2 echo -e "[decred] ${RED}FATAL! ${1}${NC}"
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
    mkdir -p ${dir} && chmod 0777 ${dir}
  fi
done


########################
# Generate the TLS certs
########################

for service in dcrd dcrwallet; do
  prefix=${DECRED_DATA_DIR}/${service}/${service}

  KEY=${prefix}.key
  CSR=${prefix}.csr
  CERT=${prefix}.cert

  if [[ -f "${CERT}" ]]; then
    print "✓ ${service}: RPC certs exist"
    continue
  fi

  print "Generating ${service} TLS certs"

  # Generate a key file
  # $ openssl ecparam -name secp521r1 -genkey -out dcrd.key
  output=$(openssl ecparam -name secp521r1 -genkey -out ${KEY} 2>&1)
  if [[ $? -eq 1 ]]; then
    fatal ${output}
  fi

  # Permissions are strange on Linux
  chmod 0777 ${KEY}

  # $ openssl req -new -out dcrd.csr -key dcrd.key -config ./openssl-decred.cnf -subj "/CN=dcrd cert"
  output=$(openssl req -new -out ${CSR} -key ${KEY} -config ${__dir}/openssl-decred.cnf -subj "/CN=${service} cert" 2>&1)
  if [[ $? -eq 1 ]]; then
    fatal "${output}"
  fi

  openssl req -text -noout -in ${CSR}

  output=$(openssl x509 -req -days 36500 -in ${CSR} -signkey ${KEY} -out ${CERT} -extensions v3_req -extfile ${__dir}/openssl-decred.cnf 2>&1)
  if [[ $? -eq 1 ]]; then
    fatal ${output}
  fi

  openssl x509 -text -in ${CERT}
done


#####################
# Pre-configure .env
#####################

file="${HOME}/.env"

if [[ -f "${file}" ]]; then
    print "INFO: .env file ${file} exists. Not overwriting."
else

    if [[ -z "${DATA_DIR}" ]]; then
      print "DATA_DIR is empty, generating one"
      DATA_DIR=${HOME}/.blackbox/data
    fi

    print "Writing default .env for decred to ${file}"
    if [[ -z "${DECRED_RPCUSER}" ]]; then
      print "DECRED_RPCUSER is empty, generating one"
      DECRED_RPCUSER=$(base64 < /dev/urandom | tr -d 'O0Il1+\:/' | head -c 32)
    fi

    if [[ -z "${DECRED_RPCPASS}" ]]; then
      print "DECRED_RPCPASS is empty, generating one"
      DECRED_RPCPASS=$(base64 < /dev/urandom | tr -d 'O0Il1+\:/' | head -c 32)
    fi

# Be aware that the location of the walletnotify script is relative to the container
cat >${file} <<EOF
DATA_DIR=${DATA_DIR}

# These are required
DECRED_RPCUSER=${DECRED_RPCUSER}
DECRED_RPCPASS=${DECRED_RPCPASS}
DECRED_WALLET_PASSWORD=

# Solo Voting
# ------------
DECRED_ENABLEVOTING=1

# Ticket Buyer
# -------------
DECRED_ENABLETICKETBUYER=1
# DECRED_BALANCETOMAINTAINABSOLUTE=0
# DECRED_MAXPRICEABSOLUTE=150
EOF
fi

#####################
# Check for a wallet: MAINNET ONLY RIGHT NOW
#####################

DECRED_WALLET_PASSWORD=${DECRED_WALLET_PASSWORD:-}

DECRED_NETWORK=${DECRED_NETWORK:-mainnet}

DECRED_TESTNET=${DECRED_TESTNET:-0}
if [[ -z ${DECRED_NETWORK} && ${DECRED_TESTNET} -eq 1 ]]; then
  DECRED_NETWORK=testnet3
fi

if [[ -z ${DECRED_NETWORK} && ${DECRED_SIMNET} -eq 1 ]]; then
  DECRED_NETWORK=simnet
fi



WALLET_FILE=${DECRED_DATA_DIR}/dcrwallet/${DECRED_NETWORK}/wallet.db

if [[  -f "$WALLET_FILE" ]]; then
  print "✓ Wallet exists"
  if [[ -z "${DECRED_WALLET_PASSWORD}" ]]; then
    fatal "You have to set DECRED_WALLET_PASSWORD in the .env or blackboxd will hang. Please make sure its right. Sorry homie."
  exit 1
fi
else
  print "${YELLOW}ATTENTION: You need to create a wallet ...${NC}\n"
  source ${__dir}/dcrwallet-create.sh

  if [[ -z "${DECRED_WALLET_PASSWORD}" ]]; then
    print "${YELLOW}ATTENTION: Your decred wallet has been successfully initialized!${NC}"
    print "${YELLOW}ATTENTION: Add your wallet password to env var DECRED_WALLET_PASSWORD and restart.${NC}"
    # We exit with a non-zero code to keep blackboxd from continuing.
    exit 1
  fi

  # echo
  # echo "GENERATE YOUR WALLET WITH THIS COMMAND:"
  # echo
  # echo "DECRED_DATA_DIR=${DECRED_DATA_DIR} ${p}/dcrwallet-create"
  # echo
  # fatal "wallet for ${DECRED_NETWORK} doesnt exist."
fi

