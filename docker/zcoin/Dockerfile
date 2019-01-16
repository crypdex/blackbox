FROM ubuntu:bionic

ARG ZCOIN_VERSION=0.13.7.6
ARG USER=zcoin
ENV DATA_DIR=/home/zcoin/.zcoin
ARG GOSU_VERSION=1.11

RUN useradd -r $USER \
  && apt-get update -y \
  && apt-get install -y curl gnupg unzip wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# https://github.com/zcoinofficial/zcoin/releases/download/v0.13.7.6/zcoin-0.13.7.6-linux64.tar.gz
# Get the PGP keys: For verifying the gosu signature
# Some of these keyservers seem not to work
RUN set -ex \
  && for key in \
  B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  ; do \
  gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
  gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
  gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
  gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" ; \
  done

RUN curl -o /usr/local/bin/gosu -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
  && curl -o /usr/local/bin/gosu.asc -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu

# download source
RUN wget -O zcoin-"${ZCOIN_VERSION}"-x86_64-linux-gnu.tar.gz \
  "https://github.com/zcoinofficial/zcoin/releases/download/v"${ZCOIN_VERSION}"/zcoin-"${ZCOIN_VERSION}"-linux64.tar.gz"

# verify gpg signature
# RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 3BDCDA2D87A881D9
# RUN gpg --keyserver-options auto-key-retrieve --verify SHA256SUMS.asc

# extract binaries
RUN mkdir zcoin-$ZCOIN_VERSION \
  && tar xzpvf zcoin-$ZCOIN_VERSION-x86_64-linux-gnu.tar.gz -C zcoin-$ZCOIN_VERSION --strip-components 1\
  && cd zcoin-$ZCOIN_VERSION \
  && cp bin/* /usr/local/bin/ \
  && cd ~ \
  && rm -rf /tmp/zcoin-$ZCOIN_VERSION

VOLUME ["/home/zcoin/.zcoin"]


COPY entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8168
EXPOSE 8888

CMD ["zcoind"]
