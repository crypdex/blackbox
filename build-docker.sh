#!/usr/bin/env bash

for service in pivx postfix-relay; do
    for arch in amd64 arm64v8; do
        docker build -f services/${service}/Dockerfile.${arch} -t crypdex/${service}:${arch}-latest services/${service}/.
        docker push crypdex/${service}:${arch}-latest
    done

    rm -rf ~/.docker/manifests/*

    docker manifest create crypdex/${service}:latest crypdex/${service}:amd64-latest crypdex/${service}:arm64v8-latest
    docker manifest push crypdex/${service}:latest
done


