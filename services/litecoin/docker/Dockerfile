# WARNING: Litecoin does not work well on Alpine yet - missing some libs
# https://github.com/litecoin-project/litecoin/issues/407

FROM debian:stable-slim as builder

LABEL maintainer.0="David Michael <david@crypdex.io>"

ARG VERSION=$VERSION
RUN test -n "$VERSION"

# VERIFY
# Importing keys from a keyserver takes a loooong time.
# https://download.litecoin.org/README-HOWTO-GPG-VERIFY-TEAM-MEMBERS-KEY.txt
COPY litecoin.pgp.key ./
COPY download-release.sh ./
COPY docker-entrypoint.sh /entrypoint.sh

RUN useradd -r litecoin \
  && apt-get update -y \
  && apt-get install -y curl gnupg git build-essential \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && set -ex

RUN git clone https://github.com/ncopa/su-exec.git \
  && cd su-exec && make && cp su-exec /usr/local/bin/ \
  && cd .. && rm -rf su-exec

RUN VERSION=$VERSION bash download-release.sh

VOLUME ["/home/litecoin/.litecoin"]

EXPOSE 9332 9333 19332 19333 19444
# ZMQ
EXPOSE 28332 28333

ENTRYPOINT ["/entrypoint.sh"]

CMD ["litecoind"]
