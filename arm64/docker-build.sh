#!/usr/bin/env bash

for service in pivx; do
    for arch in amd64 arm64v8; do
        docker build -f Dockerfile.${arch} -t crypdex/${service}:${arch}-latest ${service}/.
        docker push crypdex/${service}:${arch}-latest
    done

    rm -rf ~/.docker/manifests/docker.io_crypdex_pivx-latest/

    docker manifest create crypdex/${service}:latest crypdex/pivx:amd64-latest crypdex/pivx:arm64v8-latest
#    docker manifest annotate crypdex/${service}:latest crypdex/${service}:arm64v8-latest --os linux --arch arm64 --variant v8

#    docker manifest annotate crypdex/${service}:latest crypdex/${service}:arm64v8-latest --os linux --arch arm64 --variant v8
    docker manifest push crypdex/${service}:latest
done


