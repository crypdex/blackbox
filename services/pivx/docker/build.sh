#!/usr/bin/env bash

minor=3.3
patch=3.3.0

docker buildx build \
  --build-arg VERSION=${patch} \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  -t crypdex/pivx:${minor} \
  -t crypdex/pivx:${patch} \
  -t crypdex/pivx:latest . \
  --push
