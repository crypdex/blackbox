# This here is an image appropriate for building multiarch images.
#
# The strategy here is to use a manifest at the upper level and feed
# in the image name. Running Docker on ARM is easiest to work with when
# the base images use ARM OSs.

# Base image default is x86:
# alpine | arm64v8/alpine
ARG IMAGE=alpine

FROM ${IMAGE} as builder

LABEL maintainer.0="David Michael <david@crypdex.io>"

# amd64 | arm64
ARG ARCH
RUN test -n "$ARCH"
ARG VERSION=$VERSION
RUN test -n "$VERSION"

RUN apk add curl su-exec bash

RUN adduser -S lnd

WORKDIR /home/lnd

RUN curl -SLO https://github.com/lightningnetwork/lnd/releases/download/v${VERSION}/lnd-linux-${ARCH}-v${VERSION}.tar.gz \
  && tar --strip=1 -xzf *.tar.gz \
  && mv lnd /usr/local/bin \
  && mv lncli /usr/local/bin \
  && rm *.tar.gz

COPY entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh

# This volume is to be mounted
VOLUME ["/home/lnd/.lnd"]

# GRPC P2P
EXPOSE 10009 9735

ENTRYPOINT ["/entrypoint.sh"]

CMD ["lnd"]
