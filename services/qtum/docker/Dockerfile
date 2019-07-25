# https://github.com/qtumproject/qtum-docker/blob/master/dev/Dockerfile

FROM ubuntu:bionic

LABEL maintainer.0="David Michael"

ARG VERSION=0.17.6
RUN test -n "$VERSION"

RUN useradd -r qtum \
  && apt-get update -y \
  && apt-get install -y curl git build-essential \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/ncopa/su-exec.git \
  && cd su-exec && make && cp su-exec /usr/local/bin/ \
  && cd .. && rm -rf su-exec


COPY download-release.sh ./
RUN VERSION=$VERSION bash download-release.sh


COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME ["/home/qtum/.qtum"]

EXPOSE 3888 3889 13888 13889

ENTRYPOINT ["/entrypoint.sh"]

CMD ["qtumd"]


