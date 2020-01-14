#!/usr/bin/env bash

minor=4.0
patch=4.0.1

docker buildx build \
  --build-arg VERSION=${patch} \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  -t crypdex/pivx:${minor} \
  -t crypdex/pivx:${patch} \
  -t crypdex/pivx:latest . \
  --push
