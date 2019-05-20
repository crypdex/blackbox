#!/usr/bin/env bash

echo ""
echo "    ▄▄██████▄▄                              ▄▄                                "
echo "  ▄██████████▀█▄                            ██                                "
echo " ████████▀▀ ▄████    ▄███▄ ████▄  ████▄ ███ ██  ██ ▄███▄ ██ ██ ██ ████▄ ████▄ "
echo "█████▀    ▄███████   ██    ██  ██     █ ██▀ ████▀  ██    ██▄██▄██     █ ██  ██"
echo "██████▄    ▀██████   ▀███▄ ██  ██ ▄████ ██  ████   ▀███▄  ██████  ▄████ ██  ██"
echo "███████▀    ▄█████      ██ ██  ██ ██  █ ██  ██ ██     ██  ▀██ █▀  ██  █ ██  ██"
echo " ████▀ ▄▄████████    ▀███▀ ████▀  █████ ██  ██  ██ ▀███▀   ██ █   █████ ████▀ "
echo "  ▀█▄██████████▀           ██                                           ██    "
echo "    ▀▀██████▀▀             ▀▀                                           ▀▀    "
echo "                                                         https://sparkswap.com"
echo ""
echo ""

# This is necessary to avoid "random state" error
export RANDFILE=/tmp/.rnd

# Get the location of this script
__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


function print() {
    echo "[sparkswap] ${1}"
}

print "Configuring Sparkswap ..."

# Ensure that the Sparkswap directories are in place
# SPARKSWAP_DATA_DIR
# SPARKSWAP_DATA_DIR/lnd_ltc
# SPARKSWAP_DATA_DIR/lnd_btc
# SPARKSWAP_DATA_DIR/shared
# SPARKSWAP_DATA_DIR/data

root=${SPARKSWAP_DATA_DIR}
directories="${root} ${root}/lnd_ltc ${root}/lnd_btc ${root}/shared ${root}/data"

# Make sure that root is defined.
if [[ -z "${root}" ]]
then
  echo "SPARKSWAP_DATA_DIR is empty"
  exit 1
fi

for dir in ${directories}; do
  if [[ -d "${dir}" ]]; then
    print "✓ Directory ${dir} exists."
  else
    print "Creating directory at ${dir}"
    mkdir -p ${dir}
  fi
done

# Execute using the same bash process
source ${__dir}/scripts/install-id-and-certs.sh

source ${__dir}/scripts/install-shell.sh