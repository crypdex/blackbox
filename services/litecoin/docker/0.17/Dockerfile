# WARNING: Litecoin does not work well on Alpine yet - missing some libs
# https://github.com/litecoin-project/litecoin/issues/407

# Base image default is x86:
# arm64v8/debian:stable-slim | debian:stable-slim
ARG IMAGE=debian:stable-slim

FROM ${IMAGE} as builder

LABEL maintainer.0="David Michael <david@crypdex.io>"


ARG ARCH
RUN test -n "$ARCH"
ARG VERSION=$VERSION
RUN test -n "$VERSION"

# VERIFY
# Importing keys from a keyserver takes a loooong time.
# https://download.litecoin.org/README-HOWTO-GPG-VERIFY-TEAM-MEMBERS-KEY.txt
COPY litecoin.pgp.key litecoin.pgp.key

RUN useradd -r litecoin \
  && apt-get update -y \
  && apt-get install -y curl gnupg git build-essential \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && set -ex

RUN git clone https://github.com/ncopa/su-exec.git \
  && cd su-exec && make && cp su-exec /usr/local/bin/ \
  && cd .. && rm -rf su-exec

RUN curl -O https://download.litecoin.org/litecoin-${VERSION}/linux/litecoin-${VERSION}-${ARCH}-linux-gnu.tar.gz \
  && curl -SLO https://download.litecoin.org/litecoin-${VERSION}/linux/litecoin-${VERSION}-linux-signatures.asc \
  && gpg --import litecoin.pgp.key && gpg --fingerprint FE3348877809386C \
  && gpg --verify litecoin-${VERSION}-linux-signatures.asc \
  # we "strip" because the binaries are 2 dirs down
  && tar --strip=2 -xzf *.tar.gz -C /usr/local/bin \
  && rm *.tar.gz

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/home/litecoin/.litecoin"]

EXPOSE 9332 9333 19332 19333 19444
# ZMQ
EXPOSE 28332 28333

ENTRYPOINT ["/entrypoint.sh"]

CMD ["litecoind"]
