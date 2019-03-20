#!/usr/bin/env bash
latest=$(git ls-remote -q --tags --sort=-v:refname | awk -F/ '{ print $3 }' | head -n 1)

echo "Latest: ${latest}"

echo "Current: "