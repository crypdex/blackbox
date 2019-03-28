#!/usr/bin/env bash

# This script simply calls a pre-compiled version of "modd"
# Linux and macOS are supported in x86 and arm64 variants

ARCH=$(uname -m)
OS=$(uname -s)
# Get the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ ${OS} = "Darwin" ]]; then
    ${DIR}/../bin/osx64/modd
elif [[ ${OS} = "Linux" ]]; then
    if [[ ${ARCH} = "x86_64" ]]; then
        ${DIR}/../bin/linux64/modd
    elif [[ ${ARCH} = "aarch64" ]]; then
        ${DIR}/../bin/arm64/modd
    else
        echo ${ARCH} is unsupported
    fi
else
    echo ${OS} is unsupported
fi

