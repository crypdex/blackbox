FROM ubuntu:bionic

ARG DASH_VERSION=0.12.2.3
ARG USER=dash
ENV DATA_DIR=/home/dash/.dash
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
RUN wget -O dash-"${DASH_VERSION}"-x86_64-linux-gnu.tar.gz \
  "https://github.com/dashpay/dash/releases/download/v"${DASH_VERSION}"/dashcore-"${DASH_VERSION}"-linux64.tar.gz"

# verify gpg signature
# RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 3BDCDA2D87A881D9
# RUN gpg --keyserver-options auto-key-retrieve --verify SHA256SUMS.asc

# extract binaries
RUN mkdir dash-$DASH_VERSION \
  && tar xzpvf dash-$DASH_VERSION-x86_64-linux-gnu.tar.gz -C dash-$DASH_VERSION --strip-components 1\
  && cd dash-$DASH_VERSION \
  && cp bin/* /usr/local/bin/ \
  && cd ~ \
  && rm -rf /tmp/dash-$DASH_VERSION

VOLUME ["/home/dash/.dash"]


COPY entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9998 9999 18332 19998 19999

CMD ["dashd"]
