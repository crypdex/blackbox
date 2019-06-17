FROM ubuntu:bionic

ARG PIVX_VERSION=3.1.1
ARG USER=pivx
ENV DATA_DIR=/home/pivx/.pivx

RUN useradd -r $USER \
  && apt-get update -y \
  && apt-get install -y git build-essential curl gnupg unzip wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /tmp


# download source
RUN wget -O pivx-"${PIVX_VERSION}"-x86_64-linux-gnu.tar.gz \
  "https://github.com/PIVX-Project/PIVX/releases/download/v"${PIVX_VERSION}"/pivx-"${PIVX_VERSION}"-x86_64-linux-gnu.tar.gz" \
  && wget -O /tmp/SHA256SUMS.asc "https://github.com/PIVX-Project/PIVX/releases/download/v"${PIVX_VERSION}"/SHA256SUMS.asc"

# verify gpg signature
# RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 3BDCDA2D87A881D9
# RUN gpg --keyserver-options auto-key-retrieve --verify SHA256SUMS.asc

# extract binaries
RUN mkdir pivx-$PIVX_VERSION \
  && tar xzpvf pivx-$PIVX_VERSION-x86_64-linux-gnu.tar.gz -C pivx-$PIVX_VERSION --strip-components 1\
  && cd pivx-$PIVX_VERSION \
  && cp bin/* /usr/local/bin/ \
  && cd ~ \
  && rm -rf /tmp/pivx-$PIVX_VERSION

RUN git clone https://github.com/ncopa/su-exec.git \
    && cd su-exec && make && cp su-exec /usr/local/bin/ \
    && cd .. && rm -rf su-exec


COPY entrypoint.sh /entrypoint.sh

RUN ["chmod", "+x", "/entrypoint.sh"]

VOLUME ["/home/pivx/.pivx"]


ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 51473 51472

CMD ["pivxd"]
