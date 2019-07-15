#!/usr/bin/env bash

minor=0.17
patch=0.17.1

docker buildx build \
  --build-arg VERSION=${patch} \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  -t crypdex/bitcoin-core:${minor} \
  -t crypdex/bitcoin-core:${patch} \
  -t crypdex/bitcoin-core:latest . \
  --push
