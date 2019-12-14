#!/usr/bin/env bash

minor=0.8
patch=0.8.2-beta

docker buildx build \
  --build-arg VERSION=${patch} \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  -t crypdex/lnd:${minor} \
  -t crypdex/lnd:${patch} \
  -t crypdex/lnd:latest . \
  --push
