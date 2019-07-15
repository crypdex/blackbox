FROM debian:stable-slim as builder

LABEL maintainer.0="David Michael <david@crypdex.io>"

ARG VERSION=$VERSION
RUN test -n "$VERSION"

ARG USER=pivx

RUN useradd -r $USER \
  && apt-get update -y \
  && apt-get install -y git build-essential gnupg unzip wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY download-release.sh ./
RUN VERSION=$VERSION bash download-release.sh


RUN mkdir pivx-${VERSION} && \
  tar xf pivx-${VERSION}.tar.gz -C pivx-${VERSION} --strip 1 && \
  cd pivx-${VERSION} && \
  mv bin/* /usr/local/bin

RUN git clone https://github.com/ncopa/su-exec.git \
  && cd su-exec && make && cp su-exec /usr/local/bin/ \
  && cd .. && rm -rf su-exec

#RUN apt-get update && apt-get install -y curl && apt-get clean

COPY entrypoint.sh /entrypoint.sh

RUN ["chmod", "+x", "/entrypoint.sh"]

VOLUME ["/home/pivx/.pivx"]

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 51473 51472

CMD ["pivxd"]
