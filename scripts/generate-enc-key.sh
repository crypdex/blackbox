#!/usr/bin/env bash

filename=./.encryption-key.env

if [[ ! -f  ${filename} ]]; then
    echo "Generating ${filename} ..."
    printf "ENCRYPTION_KEY=%s" $(openssl rand -hex 32) >> ${filename}
else
    echo "File ${filename} exists. Not overwriting."
fi
