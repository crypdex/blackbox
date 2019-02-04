FROM multiarch/alpine:aarch64-latest-stable

ENV VERSION=3.1.1
ENV ARCH=aarch64
ENV DATA_DIR=/home/pivx/.pivx
ARG USER=pivx
# ARG GOSU_VERSION=1.11

RUN apk add --update --no-cache curl unzip wget su-exec \
  && adduser -S $USER

# RUN useradd -r $USER \
#   && apt-get update -y \
#   && apt-get install -y curl gnupg unzip wget \
#   && apt-get clean \
#   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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

# RUN curl -o /usr/local/bin/gosu -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
#   && curl -o /usr/local/bin/gosu.asc -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc \
#   # && gpg --verify /usr/local/bin/gosu.asc \
#   && rm /usr/local/bin/gosu.asc \
#   && chmod +x /usr/local/bin/gosu

# download source
RUN wget -O pivx-"${VERSION}"-"${ARCH}"-linux-gnu.tar.gz \
  "https://github.com/PIVX-Project/PIVX/releases/download/v"${VERSION}"/pivx-"${VERSION}"-"${ARCH}"-linux-gnu.tar.gz" \
  && wget -O /tmp/SHA256SUMS.asc "https://github.com/PIVX-Project/PIVX/releases/download/v"${VERSION}"/SHA256SUMS.asc"

# verify gpg signature
# RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 3BDCDA2D87A881D9
# RUN gpg --keyserver-options auto-key-retrieve --verify SHA256SUMS.asc

# extract binaries
RUN mkdir pivx-$VERSION \
  && tar xzpvf pivx-$VERSION-$ARCH-linux-gnu.tar.gz -C pivx-$VERSION --strip-components 1\
  && cd pivx-$VERSION \
  && cp bin/* /usr/local/bin/ \
  && cd ~ \
  && rm -rf /tmp/pivx-$VERSION

VOLUME ["/home/pivx/.pivx"]

# RUN [ "cross-build-end" ]

COPY entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 51473 51472

CMD ["pivxd"]
