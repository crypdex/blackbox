FROM ubuntu:bionic as builder

LABEL maintainer.0="David Michael"

ARG VERSION=0.13.7.10
RUN test -n "$VERSION"

# https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md
RUN apt-get update && apt-get install -y \
  git \
  build-essential libtool autotools-dev automake pkg-config bsdmainutils python3 \
  libssl-dev libevent-dev \
#  libboost-system1.65.1 \
#  libboost-filesystem1.65.1 \
#  libboost-program-options1.65.1 \
#  libboost-thread1.65.1 \
#  libboost-chrono1.65.1 \
#  libboost-all-dev \
  libboost-all-dev \
  # 0MQ
  libzmq3-dev \
  # Required by BerkleyDB
  software-properties-common

# Berkley DB
RUN add-apt-repository ppa:bitcoin/bitcoin && apt-get update && apt-get install -y \
  libdb4.8-dev libdb4.8++-dev

RUN git clone https://github.com/ncopa/su-exec.git \
  && cd su-exec && make && cp su-exec /usr/local/bin/ \
  && cd .. && rm -rf su-exec

# These are run in separate layers to take advantage of cache

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/zcoinofficial/zcoin \
  && cd zcoin \
  && ./autogen.sh \
  && ./configure --without-gui --without-upnp --disable-tests \
  && make -j 4 \
  && make install-strip \
  # Cleanup
  && cd .. && rm -rf zcoin \
  && apt-get remove -qq -y build-essential libtool autotools-dev automake pkg-config bsdmainutils libssl-dev libboost-all-dev software-properties-common git \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Its possible to make a smaller image - just need to figure out which boost libs to copy too
# FROM ubuntu:bionic

RUN useradd -r zcoin

# COPY --from=builder /usr/local/bin/zcoind  /usr/local/bin/
# COPY --from=builder /usr/local/bin/zcoin-cli /usr/local/bin/
# COPY --from=builder /usr/local/bin/zcoin-tx /usr/local/bin/
# COPY --from=builder /usr/local/bin/su-exec /usr/local/bin/


COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh


VOLUME ["/home/zcoin/.zcoin"]

EXPOSE 8168 8888

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["zcoind"]
