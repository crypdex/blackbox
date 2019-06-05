#!/usr/bin/env bash

# Get the location of this script
# and make sure we are executing this from the correct location
__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${__dir}/../services/${SERVICE}/docker

COMMON_ARCHS=(arm64v8 x86_64)
ARCHS=(arm64 amd64)
BASE_IMAGES=(arm64v8/debian:stable-slim debian:stable-slim)

source "buildvars.sh"
pwd

ORG="crypdex"
SERVICE=${SERVICE}
VERSION_DIR=${VERSION_DIR}
VERSION=${VERSION}


failed=0




for i in "${!ARCHS[@]}"; do
  common_arch=${COMMON_ARCHS[$i]}
  arch=${ARCHS[$i]}
  image=${BASE_IMAGES[$i]}


  echo "=> Building ${SERVICE} {arch: ${arch}, image: ${image}, common: ${common_arch}"

  docker build -f ${VERSION_DIR}/Dockerfile \
    -t ${ORG}/${SERVICE}:${VERSION}-${common_arch} \
    --build-arg ARCH=${arch} \
    --build-arg IMAGE=${image} \
    --build-arg VERSION=${VERSION} \
    ${VERSION_DIR}/.

  if [[ $? -eq 1 ]]; then
    echo "Build failed"
    failed=$((failed + 1))
  else
    docker push ${ORG}/${SERVICE}:${VERSION}-${common_arch}
  fi
done



if [[ ${failed} -eq 0 ]]; then
  echo "Creating the manifest ..."

  # Now create a manifest that points from latest to the specific architecture
  rm -rf ~/.docker/manifests/*

  # minor version
  docker manifest create ${ORG}/${SERVICE}:${VERSION_DIR} ${ORG}/${SERVICE}:${VERSION}-${COMMON_ARCHS[0]} ${ORG}/${SERVICE}:${VERSION}-${COMMON_ARCHS[1]}
  docker manifest push ${ORG}/${SERVICE}:${VERSION_DIR}

  # patch version
  docker manifest create ${ORG}/${SERVICE}:${VERSION} ${ORG}/${SERVICE}:${VERSION}-${COMMON_ARCHS[0]} ${ORG}/${SERVICE}:${VERSION}-${COMMON_ARCHS[1]}
  docker manifest push ${ORG}/${SERVICE}:${VERSION}

  # latest?
  docker manifest create ${ORG}/${SERVICE}:latest ${ORG}/${SERVICE}:${VERSION}-${COMMON_ARCHS[0]} ${ORG}/${SERVICE}:${VERSION}-${COMMON_ARCHS[1]}
  docker manifest push ${ORG}/${SERVICE}:latest
fi


