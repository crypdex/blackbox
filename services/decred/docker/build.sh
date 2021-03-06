#!/usr/bin/env bash

minor=1.4
patch=1.4.0

docker buildx build \
  --build-arg VERSION=${patch} \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  -t crypdex/decred:${minor} \
  -t crypdex/decred:${patch} \
  -t crypdex/decred:latest . \
  --push
