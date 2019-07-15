#!/usr/bin/env bash

minor=0.13.8
patch=0.13.8.1

docker buildx build \
  --build-arg VERSION=${patch} \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  -t crypdex/zcoin:${minor} \
  -t crypdex/zcoin:${patch} \
  -t crypdex/zcoin:latest . \
  --push
