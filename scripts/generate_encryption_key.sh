#!/usr/bin/env bash
filename=.encryption_key.env

if [[ ! -f ${filename} ]]; then
    echo "Generating the encryption key."
    printf "ENCRYPTION_KEY=%s" $(openssl rand -hex 32) >> ${filename}
else
    echo "The key has already been generated. Not overwriting."
fi
