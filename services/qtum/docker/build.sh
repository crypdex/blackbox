#!/usr/bin/env bash

minor=0.17
patch=0.17.1

docker buildx build \
  --build-arg VERSION=${patch} \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  -t crypdex/qtum:${minor} \
  -t crypdex/qtum:${patch} \
  -t crypdex/qtum:latest . \
  --push
