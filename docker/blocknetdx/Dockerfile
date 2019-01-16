FROM ubuntu:latest

ARG BLOCKNETDX_VERSION=3.11.0
ENV DATA_DIR=/home/blocknetdx/.blocknetdx
ARG USER=blocknetdx
ARG GOSU_VERSION=1.11

RUN useradd -r $USER \
  && apt-get update -y \
  && apt-get install -y curl gnupg unzip wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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
RUN wget -O blocknetdx-"${BLOCKNETDX_VERSION}"-x86_64-linux-gnu.tar.gz \
  "https://github.com/BlocknetDX/BlockDX/releases/download/v"${BLOCKNETDX_VERSION}"-redesign/blocknetdx-"${BLOCKNETDX_VERSION}"-x86_64-linux-gnu.tar.gz"
# && wget -O /tmp/SHA256SUMS.asc "https://github.com/BlocknetDX/BlockDX/releases/download/v"${BLOCKNETDX_VERSION}"/checksums-sha256.asc"

# extract binaries
RUN mkdir blocknetdx-$BLOCKNETDX_VERSION \
  && tar xzpvf blocknetdx-$BLOCKNETDX_VERSION-x86_64-linux-gnu.tar.gz -C blocknetdx-$BLOCKNETDX_VERSION --strip-components 1\
  && cd blocknetdx-$BLOCKNETDX_VERSION \
  && cp bin/* /usr/local/bin/ \
  && cd ~ \
  && rm -rf /tmp/blocknetdx-$BLOCKNETDX_VERSION

VOLUME ["/home/blocknetdx/.blocknetdx"]


COPY entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 41414 41414

CMD ["blocknetdxd"]
