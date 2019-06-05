ARG IMAGE

FROM ${IMAGE} as builder

LABEL description="Decred Daemon"
LABEL maintainer="contact@crypdex.io"

# Not sure why this needs to be declared after the IMAGE
ARG ARCH
RUN test -n "$ARCH"
ARG VERSION=$VERSION
RUN test -n "$VERSION"

#https://github.com/decred/decred-binaries/releases/download/v1.4.0/decred-linux-amd64-v1.4.0.tar.gz
ENV DCR_RELEASE_URL="https://github.com/decred/decred-binaries/releases/download/v$VERSION"
ENV DCR_MANIFEST_FILE="manifest-$VERSION.txt"
ENV DCR_RELEASE_NAME="decred-linux-$ARCH-v$VERSION"
ENV DCR_RELEASE_FILE="$DCR_RELEASE_NAME.tar.gz"

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


# https://github.com/decred/decred-binaries/releases/download/v1.4.0/decred-linux-arm64-v1.4.0.tar.gz

# Download and install Decred
# useradd -r $USER -d $HOME && \
RUN adduser --disabled-password --gecos '' $USER && \
    DEBIAN_FRONTEND=noninteractive && \
    # Download archives
    cd /tmp && \
    curl -SLO $DCR_RELEASE_URL/$DCR_RELEASE_FILE && \
    curl -SLO $DCR_RELEASE_URL/$DCR_MANIFEST_FILE && \
    curl -SLO $DCR_RELEASE_URL/$DCR_MANIFEST_FILE.asc && \
    # Verify signature and hash
#    gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys 0x518A031D && \
#    gpg --verify --trust-model=always $DCR_MANIFEST_FILE.asc && \
#    grep "$DCR_RELEASE_FILE" $DCR_MANIFEST_FILE | sha256sum -c - && \
#    rm -R $HOME/.gnupg && \
    # Extract and install
    tar xvzf $DCR_RELEASE_FILE && \
    # Move the binaries into place
    mv $DCR_RELEASE_NAME/dcrd /usr/local/bin && \
    mv $DCR_RELEASE_NAME/dcrwallet /usr/local/bin && \
    mv $DCR_RELEASE_NAME/dcrctl /usr/local/bin && \
    mv $DCR_RELEASE_NAME/promptsecret /usr/local/bin && \

    mkdir -p $DOTDCRD && \
    chown -R $USER.$USER $HOME && \
    # Cleanup
    apt-get -qy remove $BUILD_DEPS && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh /entrypoint.sh

VOLUME ["/home/decred/.decred"]

ENTRYPOINT ["/entrypoint.sh"]

# PEER & RPC PORTS
EXPOSE 9108 9109 9110 9111

CMD ["dcrd"]

