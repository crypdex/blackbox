#!/usr/bin/env bash
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
SPARKSWAP_DIRECTORY=~/.sparkswap

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


