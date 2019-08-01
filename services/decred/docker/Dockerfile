FROM debian:stretch-slim as builder

LABEL description="Decred Daemon"
LABEL maintainer="contact@crypdex.io"

ARG VERSION=$VERSION
RUN test -n "$VERSION"


ENV USER decred
ENV HOME /home/$USER
ENV DOTDCRD $HOME/.dcrd

# --------------------
# Install dependencies
# --------------------

RUN apt-get update -y && \
    apt-get install -y curl gpg git build-essential && \
    # Install su-exec
    git clone https://github.com/ncopa/su-exec.git && \
    cd su-exec && make && cp su-exec /usr/local/bin/ && \
    cd .. && rm -rf su-exec && \
    # Cleanup
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY download-release.sh ./
RUN VERSION=$VERSION bash download-release.sh

###########
# STAKEPOOL
###########

#ARG DCRSTAKEPOOL_COMMIT=cce2438c018237ee12d13fef64f96c0ee88e41e1
## Build dcrstakepool (frontend) and stakepoold (backend)
#RUN git clone https://github.com/decred/dcrstakepool.git && \
#  cd dcrstakepool && \
#  git checkout $DCRSTAKEPOOL_COMMIT && \
#  go build && \
#  mv dcrstakepool /usr/local/bin && \
#  cd backend/stakepoold && \
#  go build && \
#  mv stakepoold /usr/local/bin

# Download and install Decred
# useradd -r $USER -d $HOME && \
RUN adduser --disabled-password --gecos '' $USER && \
    # Verify signature and hash
#    gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys 0x518A031D && \
#    gpg --verify --trust-model=always $DCR_MANIFEST_FILE.asc && \
#    grep "$DCR_RELEASE_FILE" $DCR_MANIFEST_FILE | sha256sum -c - && \
#    rm -R $HOME/.gnupg && \
    # Extract and install
    mkdir -p $DOTDCRD && \
    chown -R $USER.$USER $HOME && \
    # Cleanup
#    apt-get -qy remove $BUILD_DEPS && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh /entrypoint.sh

VOLUME ["/home/decred/.decred"]

ENTRYPOINT ["/entrypoint.sh"]

# PEER & RPC PORTS
EXPOSE 9108 9109 9110 9111

CMD ["dcrd"]

