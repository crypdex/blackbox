#!/usr/bin/env bash

# Get the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# The PIVX pre-start needs to do the following
# - Ensure that the data directory exists!
# - Create the pivx.conf file
# - Create the walletnotify.sh file

echo "[pivx pre-start] Configuring PIVX"

if [[ -z "${PIVX_DATA_DIR}" ]]
then
  echo "PIVX_DATA_DIR is empty"
  exit 1
fi

# 1. Ensure that the data directory exists!
if [[ -d "${PIVX_DATA_DIR}" ]]; then
echo "[pivx pre-start] ✓ Data directory ${PIVX_DATA_DIR} exists."
else
    echo "[pivx pre-start] Creating directory for data at ${PIVX_DATA_DIR}"
    mkdir -p ${PIVX_DATA_DIR}
fi


# -----------
# CONFIG FILE
# -----------
# Does not overwrite existing files. No option to force

file="${PIVX_DATA_DIR}/pivx.conf"

if [[ -f "${file}" ]]; then
    echo "[pivx pre-start] ✓ Config file ${file} exists."
else
    echo "[pivx pre-start] Writing default config for PIVX to ${file}"

    cat >${file} <<EOF
rpcuser=${rpcuser}
rpcpassword=${rpcpassword}
walletnotify=/bin/bash ${PIVX_DATA_DIR}/walletnotify.sh %s
EOF
fi


# --------------------
# WALLET NOTIFY SCRIPT
# --------------------
#
# This assumes the service runs in docker and is addressable as "api"
walletnotify="${PIVX_DATA_DIR}/walletnotify.sh"
if [[ -f "${file}" ]]; then
    echo "[pivx pre-start] ✓ The file ${walletnotify} exists"
else
    echo "[pivx pre-start] Writing walletnotify for PIVX to ${walletnotify}"
    cat >${walletnotify} <<EOF
#!/usr/bin/env bash

curl -X POST http://api/pivx/walletnotify/\$1
EOF
fi