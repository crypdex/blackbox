FROM ubuntu:bionic

ARG VERSION=0.16.3
ARG USER=litecoin
ENV DATA_DIR=/home/litecoin/.litecoin
ARG GOSU_VERSION=1.11

RUN useradd -r $USER \
  && apt-get update -y \
  && apt-get install -y curl gnupg unzip wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Get the PGP keys: For verifying the gosu signature
# Some of these keyservers seem not to work
# RUN set -ex \
#   && for key in \
#   B42F6819007F00F88E364FD4036A9C25BF357DD4 \
#   ; do \
#   gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
#   gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
#   gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
#   gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" ; \
#   done

RUN curl -o /usr/local/bin/gosu -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
  && curl -o /usr/local/bin/gosu.asc -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc \
  # && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu

# download source
# https://download.litecoin.org/litecoin-0.16.3/linux/litecoin-0.16.3-x86_64-linux-gnu.tar.gz
RUN wget -O litecoin-"${VERSION}"-x86_64-linux-gnu.tar.gz \
  "https://download.litecoin.org/litecoin-"${VERSION}"/linux/litecoin-"${VERSION}"-x86_64-linux-gnu.tar.gz"

# verify gpg signature
# RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 3BDCDA2D87A881D9
# RUN gpg --keyserver-options auto-key-retrieve --verify SHA256SUMS.asc

# extract binaries
RUN mkdir litecoin-$VERSION \
  && tar xzpvf litecoin-$VERSION-x86_64-linux-gnu.tar.gz -C litecoin-$VERSION --strip-components 1\
  && cd litecoin-$VERSION \
  && cp bin/* /usr/local/bin/ \
  && cd ~ \
  && rm -rf /tmp/litecoin-$VERSION

VOLUME ["/home/litecoin/.litecoin"]


COPY entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]

# Ports are found here
# https://github.com/litecoin-project/litecoin/blob/master/src/chainparams.cpp#L120
EXPOSE 9332 9333 19332 19333 19444

CMD ["litecoind"]
