#!/usr/bin/env bash

#############################################
# Crypdex Version:
# This script is clipped from https://github.com/sparkswap/broker/blob/master/scripts/build.sh
#############################################




# Setting this env is ONLY required for a hosted broker setup.
#
# This address is used during the build process so that certs can be generated
# correctly for a hosted (remote) broker daemon.

EXTERNAL_ADDRESS=${EXTERNAL_ADDRESS:-localhost}

SPARKSWAP_DIRECTORY=${EXTERNAL_ADDRESS:-~/.sparkswap}



echo "Creating directories $SPARKSWAP_DIRECTORY and $SPARKSWAP_DIRECTORY/secure"

mkdir -p ${SPARKSWAP_DIRECTORY}/secure

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


#############################################
# Keypair Generation for SSL to the broker
#
# This step creates certs to allow a user to host a broker on a remote machine
# and have connections to their daemon be secured through ssl
#
# Primary use is TLS between Broker-CLI and Broker Daemon
#
#############################################
echo "Generating the Broker SSL certs"


KEY_PATH=${SPARKSWAP_DIRECTORY}/secure/broker-rpc-tls.key
CERT_PATH=${SPARKSWAP_DIRECTORY}/secure/broker-rpc-tls.cert
CSR_PATH=${SPARKSWAP_DIRECTORY}/secure/broker-rpc-csr.csr


if [[ -f "$KEY_PATH" ]]; then
  echo "WARNING: TLS Private Key already exists at $KEY_PATH for Broker Daemon. Skipping cert generation"
elif [[ -f "$CERT_PATH" ]]; then
  echo "WARNING: TLS Cert already exists at $CERT_PATH for Broker Daemon. Skipping cert generation"
else
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
fi
