# FROM multiarch/ubuntu-core:arm64-bionic
FROM arm64v8/ubuntu:bionic

# Enable cross-build for aarch64
# COPY ./vendor/qemu-bin /usr/bin/
# RUN [ "cross-build-start" ]
# FROM ubuntu:bionic

ENV VERSION=3.2.2
# x86_64 || aarch64
ARG USER=pivx

RUN useradd -r $USER \
  && apt-get update -y \
  && apt-get install -y git build-essential gnupg unzip wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /tmp

# download source
RUN wget -O /tmp/pivx-"${VERSION}"-aarch64-linux-gnu.tar.gz \
  "https://github.com/PIVX-Project/PIVX/releases/download/v"${VERSION}"/pivx-"${VERSION}"-aarch64-linux-gnu.tar.gz" \
  && wget -O /tmp/SHA256SUMS.asc "https://github.com/PIVX-Project/PIVX/releases/download/v"${VERSION}"/SHA256SUMS.asc"

# verify gpg signature
# RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 3BDCDA2D87A881D9
# RUN gpg --keyserver-options auto-key-retrieve --verify SHA256SUMS.asc

# extract binaries
RUN mkdir pivx-$VERSION \
  && tar xzpvf pivx-$VERSION-aarch64-linux-gnu.tar.gz -C pivx-$VERSION --strip-components 1\
  && cd pivx-$VERSION \
  && cp bin/* /usr/local/bin/ \
  && cd ~ \
  && rm -rf /tmp/pivx-$VERSION

#install su-exec
RUN git clone https://github.com/ncopa/su-exec.git \
  && cd su-exec && make && cp su-exec /usr/local/bin/ \
  && cd .. && rm -rf su-exec

# RUN [ "cross-build-end" ]
RUN apt-get update && apt-get install -y curl && apt-get clean

COPY entrypoint.sh /entrypoint.sh

RUN ["chmod", "+x", "/entrypoint.sh"]

VOLUME ["/home/pivx/.pivx"]

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 51473 51472

CMD ["pivxd"]
