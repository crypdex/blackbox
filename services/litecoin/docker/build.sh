#!/usr/bin/env bash

minor=0.17
patch=0.17.1

docker buildx build \
  --build-arg VERSION=${patch} \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  -t crypdex/litecoin-core:${minor} \
  -t crypdex/litecoin-core:${patch} \
  -t crypdex/litecoin-core:latest . \
  --push
