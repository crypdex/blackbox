FROM ubuntu:bionic as builder

LABEL maintainer="CRYPDEX"

ARG VERSION=0.17.1
RUN test -n "$VERSION"

# https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md
RUN apt-get update && apt-get install -y \
  git \
  build-essential libtool autotools-dev automake pkg-config bsdmainutils python3 \
  libssl-dev libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev \
  # 0MQ
  libzmq3-dev \
  # Requied by BerkleyDB
  software-properties-common

# Berkley DB
RUN add-apt-repository ppa:bitcoin/bitcoin && apt-get update && apt-get install -y \
  libdb4.8-dev libdb4.8++-dev

# These are run in separate layers to take advantage of cache
RUN git clone https://github.com/bitcoin/bitcoin.git && cd bitcoin/ && git checkout v${VERSION}
WORKDIR bitcoin
RUN ./autogen.sh && ./configure --without-gui --without-miniupnpc
RUN make -j 4 && \
  strip src/bitcoind && \
  strip src/bitcoin-cli && \
  strip src/bitcoin-tx && \
  make install

FROM ubuntu:bionic

#RUN useradd -r bitcoin \
#  && apt-get update -y \
#  && apt-get install -y curl gnupg git build-essential \
#  && apt-get clean \
#  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#
#RUN git clone https://github.com/ncopa/su-exec.git \
#  && cd su-exec && make && cp su-exec /usr/local/bin/ \
#  && cd .. && rm -rf su-exec

COPY --from=builder /usr/local/bin/bitcoind  /usr/local/bin/
COPY --from=builder /usr/local/bin/bitcoin-cli /usr/local/bin/
COPY --from=builder /usr/local/bin/bitcoin-tx /usr/local/bin/
COPY --from=builder /usr/local/bin/bitcoin-wallet /usr/local/bin/

#ENV BITCOIN_DATA=/home/bitcoin/.bitcoin
#ENV PATH=/opt/bitcoin-${VERSION}/bin:$PATH
#
#RUN echo "https://bitcoin.org/bin/bitcoin-core-${VERSION}/bitcoin-${VERSION}-${ARCH}-linux-gnu.tar.gz"
#
#RUN curl -SL https://bitcoin.org/laanwj-releases.asc | gpg --batch --import \
#  && curl -SLO https://bitcoin.org/bin/bitcoin-core-${VERSION}/SHA256SUMS.asc \
#  && curl -SLO https://bitcoin.org/bin/bitcoin-core-${VERSION}/bitcoin-${VERSION}-${ARCH}-linux-gnu.tar.gz \
#  && gpg --verify SHA256SUMS.asc \
#  && grep " bitcoin-${VERSION}-${ARCH}-linux-gnu.tar.gz\$" SHA256SUMS.asc | sha256sum -c - \
#  && tar -xzf *.tar.gz -C /opt \
#  && rm *.tar.gz *.asc
#
#COPY entrypoint.sh /entrypoint.sh
#
#VOLUME ["/home/bitcoin/.bitcoin"]
#
#EXPOSE 8332 8333 18332 18333 18443 18444
#
#ENTRYPOINT ["/entrypoint.sh"]
#
#CMD ["bitcoind"]
