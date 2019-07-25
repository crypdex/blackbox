#!/usr/bin/env bash

minor=3.13
patch=3.13.1

docker buildx build \
  --build-arg VERSION=${patch} \
  --platform linux/amd64,linux/arm64 \
  -t crypdex/blocknetdx:${minor} \
  -t crypdex/blocknetdx:${patch} \
  -t crypdex/blocknetdx:latest . \
  --push
