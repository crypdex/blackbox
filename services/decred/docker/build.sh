#!/usr/bin/env bash

##########################################
# Run this script with Makefile from root
# VERSION=0.17 make release
##########################################

ORG="crypdex"
SERVICE="decred"
VERSION='1.4'
ARCH="arm64v8 x86_64"

# Build and push builds for these architectures
for arch in ${ARCH}; do
  if [[ ${arch} = "arm64v8" ]]; then
    IMAGE="arm64v8/debian:stable-slim"
    DECRED_ARCH="arm64"
  elif [[ ${arch} = "x86_64" ]]; then
    IMAGE="debian:stable-slim"
    DECRED_ARCH="amd64"
  fi

  echo "=> Building Decred {arch: ${arch}, image: ${IMAGE}, decred-arch: ${DECRED_ARCH}}"


  docker build -f Dockerfile -t ${ORG}/${SERVICE}:${VERSION}-${arch} --build-arg DECRED_ARCH=${DECRED_ARCH} --build-arg IMAGE=${IMAGE} .
  docker push ${ORG}/${SERVICE}:${VERSION}-${arch}
done


# Now create a manifest that points from latest to the specific architecture
rm -rf ~/.docker/manifests/*

# version
docker manifest create ${ORG}/${SERVICE}:${VERSION} ${ORG}/${SERVICE}:${VERSION}-x86_64 ${ORG}/${SERVICE}:${VERSION}-arm64v8
docker manifest push ${ORG}/${SERVICE}:${VERSION}

# latest?
docker manifest create ${ORG}/${SERVICE}:latest ${ORG}/${SERVICE}:${VERSION}-x86_64 ${ORG}/${SERVICE}:${VERSION}-arm64v8
docker manifest push ${ORG}/${SERVICE}:latest

