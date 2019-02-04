FROM ubuntu:bionic as builder

# switch to root, let the entrypoint drop back to configured user
USER root
ENV VERSION=3.1.1
ENV ARCH=aarch64
ARG USER=pivx

RUN useradd -r $USER \
  && apt-get update -y \
  && apt-get install -y git build-essential gnupg unzip wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /tmp

# download source
RUN wget -O /tmp/pivx-"${VERSION}"-"${ARCH}"-linux-gnu.tar.gz \
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

#install su-exec
RUN git clone https://github.com/ncopa/su-exec.git \
  && cd su-exec && make && cp su-exec /usr/local/bin/ \
  && cd .. && rm -rf su-exec

# --------
# PART 2
# --------


FROM ubuntu:bionic as final

ENV DATA_DIR=/home/pivx/.pivx
ENV USER pivx

RUN apt-get update && apt-get upgrade -y

COPY --from=builder /usr/local/bin/* /usr/local/bin/
COPY entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]

# add user to the system
RUN useradd -d /home/"${USER}" -s /bin/sh -G users "${USER}"

VOLUME ["/home/pivx/.pivx"]

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 51473 51472

CMD ["pivxd"]
