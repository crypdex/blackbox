#!/usr/bin/env bash


SERVICE="litecoin-core"
ARCH="arm64v8 x86_64"
# This should alway track the latest version
VERSION='0.17'


# Build and push builds for these architectures
for arch in ${ARCH}; do
  if [[ ${arch} = "arm64v8" ]]; then
    IMAGE="arm64v8/debian:stable-slim"
    BIN_ARCH="aarch64"
  elif [[ ${arch} = "x86_64" ]]; then
    IMAGE="debian:stable-slim"
    BIN_ARCH="x86_64"
  fi

  echo "=> Building Litecoin Core ${VERSION} {arch: ${arch}, image: ${IMAGE}}"

  docker build -t crypdex/${SERVICE}:${VERSION}-${arch} --build-arg ARCH=${BIN_ARCH} --build-arg IMAGE=${IMAGE} .
  docker push crypdex/${SERVICE}:${VERSION}-${arch}
done

# Now create a manifest that points from latest to the specific architecture
rm -rf ~/.docker/manifests/*

# version
docker manifest create crypdex/${SERVICE}:${VERSION} crypdex/${SERVICE}:${VERSION}-x86_64 crypdex/${SERVICE}:${VERSION}-arm64v8
docker manifest push crypdex/${SERVICE}:${VERSION}

