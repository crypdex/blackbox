# Multistage docker build, requires docker 17.05
ARG IMAGE

# builder stage
FROM ${IMAGE} as builder

RUN set -ex && \
    apt-get update && \
    apt-get --no-install-recommends --yes install \
    clang \
    libclang-dev \
    llvm-dev \
    libncurses5 \
    libncursesw5 \
    cmake \
    git

WORKDIR /usr/src/

RUN git clone https://github.com/mimblewimble/grin.git && \
    cd grin  && \
    git checkout ${VERSION} && \
    cargo build --release

# runtime stage
# FROM debian:9.4
FROM ${IMAGE}

RUN useradd -r grin
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales openssl

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8

RUN git clone https://github.com/ncopa/su-exec.git \
  && cd su-exec && make && cp su-exec /usr/local/bin/ \
  && cd .. && rm -rf su-exec

COPY entrypoint.sh /entrypoint.sh
COPY --from=builder /usr/src/grin/target/release/grin /usr/local/bin/grin

WORKDIR /home/grin/.grin

RUN grin server config && \
    sed -i -e 's/run_tui = true/run_tui = false/' grin-server.toml

VOLUME ["/root/.grin"]

EXPOSE 3413 3414 3415 3416

ENTRYPOINT ["/entrypoint.sh"]

CMD ["grin"]
#CMD ["server", "run"]

