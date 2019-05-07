#!/usr/bin/env bash

#############################################
# Crypdex Version:
# This script is clipped from https://github.com/sparkswap/broker/blob/master/scripts/build.sh
#############################################



EXTERNAL_ADDRESS=${EXTERNAL_ADDRESS}

SPARKSWAP_DIRECTORY=${SPARKSWAP_DIRECTORY:-~/.sparkswap}

echo "Creating directories $SPARKSWAP_DIRECTORY/secure"
mkdir -p ${SPARKSWAP_DIRECTORY}/secure

# RESOLVE THE IP ADDRESS

PREVIOUS_ADDRESS=""

resolve_ip() {
  echo "Resolving IP address"
  local file=${SPARKSWAP_DIRECTORY}/ipaddress.txt

  # PREVIOUS
  if [[ -f ${file} ]]; then
    while IFS= read line
    do
      PREVIOUS_ADDRESS=${line}
    done <"$file"
  fi

  # CURRENT
  if [[ ${EXTERNAL_ADDRESS} == "" ]]; then
    EXTERNAL_ADDRESS=$(hostname -i)
  fi

  echo "The current IP is set to ${EXTERNAL_ADDRESS}"

# Write current to file
/bin/cat <<EOM >${file}
${EXTERNAL_ADDRESS}
EOM
}

# Call the function
resolve_ip



#############################################
# Keypair Generation for SSL to the broker
#
# This step creates certs to allow a user to host a broker on a remote machine
# and have connections to their daemon be secured through ssl
#
# Primary use is TLS between Broker-CLI and Broker Daemon
#
#############################################

KEY_PATH=${SPARKSWAP_DIRECTORY}/secure/broker-rpc-tls.key
CERT_PATH=${SPARKSWAP_DIRECTORY}/secure/broker-rpc-tls.cert
CSR_PATH=${SPARKSWAP_DIRECTORY}/secure/broker-rpc-csr.csr

generate_tls_certs() {
  echo "Generating TLS certs for Broker Daemon"
  openssl ecparam -genkey -name prime256v1 > ${KEY_PATH}
  openssl req -new -sha256 -key ${KEY_PATH} \
    -reqexts SAN \
    -extensions SAN \
    -config <(cat /etc/ssl/openssl.cnf \
      <(printf "\n[SAN]\nsubjectAltName=DNS:$EXTERNAL_ADDRESS,DNS:localhost")) \
    -subj "/CN=$EXTERNAL_ADDRESS/O=sparkswap" > ${CSR_PATH}
  openssl req -x509 -sha256 -key ${KEY_PATH} -in  ${CSR_PATH} -days 36500 \
    -reqexts SAN \
    -extensions SAN \
    -config <(cat /etc/ssl/openssl.cnf \
      <(printf "\n[SAN]\nsubjectAltName=DNS:$EXTERNAL_ADDRESS,DNS:localhost")) > $CERT_PATH

  rm -f ${CSR_PATH}
}

# If the IP has changed, re-generate the certs
if [[ ${PREVIOUS_ADDRESS} != ${EXTERNAL_ADDRESS} ]]; then
  echo "WARNING: IP has changed. Will regenerate TLS certs."
  generate_tls_certs
else
  if [[ -f "$KEY_PATH" ]]; then
    echo "WARNING: TLS Private Key already exists at $KEY_PATH for Broker Daemon. Skipping cert generation"
  elif [[ -f "$CERT_PATH" ]]; then
    echo "WARNING: TLS Cert already exists at $CERT_PATH for Broker Daemon. Skipping cert generation"
  else
    generate_tls_certs
  fi
fi



#############################################
# Keypair Generation of Broker Identity for Relayer
#
# This step creates certs to allow the broker to authenticate/auth for all actions
# on the relayer
#
# We use a "Secure key exchange algorithm" (ECDH) here because these keys are exchanged
# via a non secure channel.
#
#############################################

echo "Generating the Broker identity"

ID_PRIV_KEY=${SPARKSWAP_DIRECTORY}/secure/broker-identity.private.pem
ID_PUB_KEY=${SPARKSWAP_DIRECTORY}/secure/broker-identity.public.pem

NO_IDENTITY=false

if [[ -f "$ID_PRIV_KEY" ]]; then
  echo "WARNING: ID already exists for Broker Daemon. Skipping ID generation"
elif [[ -f "$ID_PUB_KEY" ]]; then
  echo "WARNING: ID Public Key already exists for Broker Daemon. Skipping ID generation"
elif [[ "$NO_IDENTITY" != "true" ]]; then
  openssl ecparam -name prime256v1 -genkey -noout > ${ID_PRIV_KEY}
  openssl ec -in ${ID_PRIV_KEY} -pubout > ${ID_PUB_KEY}
fi
