FROM ubuntu:bionic as builder

LABEL maintainer="CRYPDEX"

RUN useradd -r bitcoin \
  && apt-get update -y \
  && apt-get install -y curl gnupg git build-essential \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/ncopa/su-exec.git \
  && cd su-exec && make && cp su-exec /usr/local/bin/ \
  && cd .. && rm -rf su-exec

ARG VERSION=$VERSION
RUN test -n "$VERSION"

ENV BITCOIN_DATA=/home/bitcoin/.bitcoin
ENV PATH=/opt/bitcoin-${VERSION}/bin:$PATH

COPY download-release.sh ./
RUN VERSION=$VERSION bash download-release.sh

COPY entrypoint.sh /entrypoint.sh

VOLUME ["/home/bitcoin/.bitcoin"]

EXPOSE 8332 8333 18332 18333 18443 18444

ENTRYPOINT ["/entrypoint.sh"]

CMD ["bitcoind"]
