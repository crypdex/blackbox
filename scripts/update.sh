#!/usr/bin/env bash

latest=$(git ls-remote -q --tags --sort=-v:refname | awk -F/ '{ print $3 }' | head -n 1)

current=$(git describe --tags)

echo "Latest: ${latest}"
echo "Current: ${current}"

if [[ "${latest}" = "${current}" ]]; then
    echo "You are on the latest"
else
    echo "You are not on the latest"
fi

