#!/usr/bin/env bash

# This script generates common configs for chains in the Bitcoin lineage.
# It requires 2 environment variables to do its work
#
# - CHAINS - A space separated list of chain names
# - DATA_DIR - Path to where all the data is kept. For example: ~/data
if [[ -z "CHAINS" ]]; then
    echo "Must provide CHAINS in environment" 1>&2
    exit 1
fi

if [[ -z "DATA_DIR" ]]; then
    echo "Must provide DATA_DIR in environment" 1>&2
    exit 1
fi



# Generate random user/password combination
#
rpcuser=$(base64 < /dev/urandom | tr -d 'O0Il1+\:/' | head -c 64)
rpcpassword=$(base64 < /dev/urandom | tr -d 'O0Il1+\:/' | head -c 64)

for chain in ${CHAINS}
do
    echo "→ Generating conf file for ${chain} ..."
    # -----------
    # CONFIG FILE
    # -----------
    # Does not overwrite existing files. No option to force
    path="${DATA_DIR}/${chain}"
    file="${path}/${chain}.conf"
    if [[ -f "${file}" ]]; then
        echo "→ The file ${file} exists"

    else
        echo "→ Writing config for ${chain} to ${file}"

        cat >${file} <<EOF
rpcuser=${rpcuser}
rpcpassword=${rpcpassword}
walletnotify=${DATA_DIR}/${chain}/walletnotify.sh %s
EOF
    fi

    # --------------------
    # WALLET NOTIFY SCRIPT
    # --------------------
    #
    # This assumes the service runs in docker and is addressable as "api"
    walletnotify="${path}/walletnotify.sh"
    if [[ -f "${file}" ]]; then
        echo "→ The file ${walletnotify} exists"
    else
        echo "→ Writing walletnotify for ${chain} to ${walletnotify}"
        cat >${walletnotify} <<EOF
#!/usr/bin/env bash

curl -X POST http://api/${chain}/walletnotify/\$1
EOF
    fi

done



