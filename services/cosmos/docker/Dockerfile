# This here is an image appropriate for building multiarch images.
#
# The strategy here is to use a manifest at the upper level and feed
# in the image name. Running Docker on ARM is easiest to work with when
# the base images use ARM OSs.

# Base image default is x86:
# alpine | arm64v8/alpine
ARG IMAGE=golang:1.12-stretch

FROM golang:1.12-stretch as builder

LABEL maintainer.0="David Michael <david@crypdex.io>"

ARG GOOS=linux
ARG GOARCH=$GOARCH
ARG VERSION=1.0.0-rc1
RUN test -n "$VERSION"

RUN git clone -b v$VERSION https://github.com/cosmos/gaia.git

WORKDIR gaia

RUN mv Makefile Makefile.orig
COPY Makefile Makefile
RUN LEDGER_ENABLED=false GOOS=$GOOS GOOARCH=$GOARCH make build-xplatform


FROM ${IMAGE}

COPY --from=builder /go/gaia/gaiad /usr/local/bin/gaiad
COPY --from=builder /go/gaia/gaiacli /usr/local/bin/gaiacli

RUN useradd -r cosmos



git