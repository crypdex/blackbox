#!/usr/bin/env bash

# The data directory has to be pre-created. That is, portainer will not create it and will just fail to start.
# This could be solved with a named volume as well

if [[ -z ${DATA_DIR} ]]; then
    echo "DATA_DIR is unset"
else
    echo "[portainer] Ensuring DATA_DIR ${DATA_DIR} exists"
    mkdir -p ${DATA_DIR}/portainer
fi

