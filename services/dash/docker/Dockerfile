FROM ubuntu:bionic as builder

LABEL maintainer="CRYPDEX"

RUN useradd -r dash \
  && apt-get update -y \
  && apt-get install -y curl gnupg git build-essential \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/ncopa/su-exec.git \
  && cd su-exec && make && cp su-exec /usr/local/bin/ \
  && cd .. && rm -rf su-exec

ARG VERSION=$VERSION
RUN test -n "$VERSION"

COPY download-release.sh ./
RUN VERSION=$VERSION bash download-release.sh

RUN echo "Verifying checksums" && \
  curl -SL https://keybase.io/codablock/pgp_keys.asc | gpg --import && \
  gpg --verify SHA256SUMS.asc

# we "strip" because the binaries are 2 dirs down
RUN tar --strip=2 -xzf *.tar.gz -C /usr/local/bin && \
  rm *.tar.gz

COPY docker-entrypoint.sh /docker-entrypoint.sh

VOLUME ["/home/dash/.dash"]

EXPOSE 9998 9999 19998 19999

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["dashd"]
