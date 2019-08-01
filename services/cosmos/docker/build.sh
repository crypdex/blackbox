#!/usr/bin/env bash

##########################################
# Run this script with Makefile from root
# VERSION=0.17 make release
##########################################

ORG="crypdex"
SERVICE="cosmos"
VERSION='1.0.0-rc1'
ARCH="arm64v8 x86_64"

# Build and push builds for these architectures
for arch in ${ARCH}; do
  if [[ ${arch} = "arm64v8" ]]; then
    IMAGE="arm64v8/golang:1.12-stretch"
    GOARCH="arm64"
  elif [[ ${arch} = "x86_64" ]]; then
    IMAGE="golang:1.12-stretch"
    GOARCH="amd64"
  fi

  echo "=> Building CosmosHub (gaia) ${VERSION} {arch: ${arch}, image: ${IMAGE}, GOARCH: ${GOARCH}}"

  docker build -f ./Dockerfile -t ${ORG}/${SERVICE}:${VERSION}-${arch} --build-arg GOARCH=${GOARCH} --build-arg IMAGE=${IMAGE} .
  docker push ${ORG}/${SERVICE}:${VERSION}-${arch}
done


## Now create a manifest that points from latest to the specific architecture
#rm -rf ~/.docker/manifests/*
#
## version
#docker manifest create ${ORG}/${SERVICE}:${VERSION} ${ORG}/${SERVICE}:${VERSION}-x86_64 ${ORG}/${SERVICE}:${VERSION}-arm64v8
#docker manifest push ${ORG}/${SERVICE}:${VERSION}
#
