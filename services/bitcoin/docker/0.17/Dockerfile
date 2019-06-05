ARG IMAGE

FROM ${IMAGE} as builder

LABEL maintainer.0="CRYPDEX"

RUN useradd -r bitcoin \
  && apt-get update -y \
  && apt-get install -y curl gnupg git build-essential \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/ncopa/su-exec.git \
  && cd su-exec && make && cp su-exec /usr/local/bin/ \
  && cd .. && rm -rf su-exec

ARG ARCH
RUN test -n "$ARCH"
ARG VERSION=$VERSION
RUN test -n "$VERSION"

ENV BITCOIN_DATA=/home/bitcoin/.bitcoin
ENV PATH=/opt/bitcoin-${VERSION}/bin:$PATH

RUN echo "https://bitcoin.org/bin/bitcoin-core-${VERSION}/bitcoin-${VERSION}-${ARCH}-linux-gnu.tar.gz"

RUN curl -SL https://bitcoin.org/laanwj-releases.asc | gpg --batch --import \
  && curl -SLO https://bitcoin.org/bin/bitcoin-core-${VERSION}/SHA256SUMS.asc \
  && curl -SLO https://bitcoin.org/bin/bitcoin-core-${VERSION}/bitcoin-${VERSION}-${ARCH}-linux-gnu.tar.gz \
  && gpg --verify SHA256SUMS.asc \
  && grep " bitcoin-${VERSION}-${ARCH}-linux-gnu.tar.gz\$" SHA256SUMS.asc | sha256sum -c - \
  && tar -xzf *.tar.gz -C /opt \
  && rm *.tar.gz *.asc

COPY entrypoint.sh /entrypoint.sh

VOLUME ["/home/bitcoin/.bitcoin"]

EXPOSE 8332 8333 18332 18333 18443 18444

ENTRYPOINT ["/entrypoint.sh"]

CMD ["bitcoind"]
