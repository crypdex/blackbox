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

if [[ -z "${PIVX_WALLETNOTIFY_CMD}" ]]
then
  echo "PIVX_WALLETNOTIFY_CMD is empty, setting default"
  PIVX_WALLETNOTIFY_CMD="echo \"PIVX tx received: \$1\""
fi

# 1. Ensure that the data directory exists!
if [[ -d "${PIVX_DATA_DIR}" ]]; then
echo "[pivx pre-start] ✓ Data directory ${PIVX_DATA_DIR} exists."
else
    echo "[pivx pre-start] Creating directory for data at ${PIVX_DATA_DIR}"
    mkdir -p ${PIVX_DATA_DIR}
fi

if [[ -z "${PIVX_RPCUSER}" ]]
then
  echo "PIVX_RPCUSER is empty, generating one"
  PIVX_RPCUSER=$(base64 < /dev/urandom | tr -d 'O0Il1+\:/' | head -c 64)
fi

if [[ -z "${PIVX_RPCPASSWORD}" ]]
then
  echo "PIVX_RPCPASSWORD is empty, generating one"
  PIVX_RPCPASSWORD=$(base64 < /dev/urandom | tr -d 'O0Il1+\:/' | head -c 64)
fi

# -----------
# CONFIG FILE
# -----------
# Does not overwrite existing files. No option to force

file="${PIVX_DATA_DIR}/pivx.conf"

if [[ -f "${file}" ]]; then
    echo "[pivx pre-start] WARN: Config file ${file} exists. Overwriting."
fi

echo "[pivx pre-start] Writing default config for PIVX to ${file}"

cat >${file} <<EOF
rpcuser=${PIVX_RPCUSER}
rpcpassword=${PIVX_RPCPASSWORD}
walletnotify=/bin/bash ${PIVX_DATA_DIR}/walletnotify.sh %s
EOF


# --------------------
# WALLET NOTIFY SCRIPT
# --------------------
#
# This assumes the service runs in docker and is addressable as "api"
walletnotify="${PIVX_DATA_DIR}/walletnotify.sh"
if [[ -f "${file}" ]]; then
    echo "[pivx pre-start] WARN: The file ${walletnotify} exists, overwriting."
fi

echo "[pivx pre-start] Writing walletnotify for PIVX to ${walletnotify}"
cat >${walletnotify} <<EOF
#!/usr/bin/env bash

${PIVX_WALLETNOTIFY_CMD}
EOF
