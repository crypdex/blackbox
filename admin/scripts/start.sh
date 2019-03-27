#!/usr/bin/env bash

ARCH=$(uname -m)
OS=$(uname -s)

if [[ ${OS} = "Darwin" ]]; then
    ./bin/darwin/app
elif [[ ${OS} = "Linux" ]]; then
    if [[ ${ARCH} = "x86_64" ]]; then
        ./bin/amd64/app
    elif [[ ${ARCH} = "aarch64" ]]; then
        ./bin/arm64/app
    else
        echo ${ARCH} is unsupported
    fi
else
    echo ${OS} is unsupported
fi
