#!/usr/bin/env bash

minor=0.18
patch=0.18.1

docker buildx build \
  --build-arg VERSION=${patch} \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  -t crypdex/bitcoin-core:${minor} \
  -t crypdex/bitcoin-core:${patch} \
  -t crypdex/bitcoin-core:latest . \
  --push
