#!/usr/bin/env bash

##########################################
# Run this script with Makefile from root
# VERSION=3.2 make release
##########################################

#VERSION=
SERVICE="pivx"
ARCH="arm64v8 x86_64"
ORG="crypdex"

# Build and push builds for these architectures
for arch in ${ARCH}; do
    docker build -f ${VERSION}/Dockerfile.${arch} -t ${ORG}/${SERVICE}:${VERSION}-${arch} ${VERSION}/.
    docker push ${ORG}/${SERVICE}:${VERSION}-${arch}
done

# Now create a manifest that points from latest to the specific architecture
rm -rf ~/.docker/manifests/*

# version
docker manifest create ${ORG}/${SERVICE}:${VERSION} ${ORG}/${SERVICE}:${VERSION}-x86_64 ${ORG}/${SERVICE}:${VERSION}-arm64v8
docker manifest push ${ORG}/${SERVICE}:${VERSION}

