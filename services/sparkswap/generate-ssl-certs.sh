#!/usr/bin/env bash
#############################################
# Keypair Generation for SSL to the broker
#
# This step creates certs to allow a user to host a broker on a remote machine
# and have connections to their daemon be secured through ssl
#
# Primary use is TLS between Broker-CLI and Broker Daemon
#
#############################################
SPARKSWAP_DIRECTORY=~/.sparkswap

echo "Creating directories $SPARKSWAP_DIRECTORY and $SPARKSWAP_DIRECTORY/secure"
mkdir -p ${SPARKSWAP_DIRECTORY}/secure

KEY_PATH=${SPARKSWAP_DIRECTORY}/secure/broker-rpc-tls.key
CERT_PATH=${SPARKSWAP_DIRECTORY}/secure/broker-rpc-tls.cert
CSR_PATH=${SPARKSWAP_DIRECTORY}/secure/broker-rpc-csr.csr

EXTERNAL_ADDRESS=127.0.0.1


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
