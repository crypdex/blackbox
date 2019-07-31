#!/usr/bin/env bash

minor=0.14
patch=0.14.0.2

docker buildx build \
  --build-arg VERSION=${patch} \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  -t crypdex/dash-core:${minor} \
  -t crypdex/dash-core:${patch} \
  -t crypdex/dash-core:latest . \
  --push
