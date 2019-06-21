FROM alpine as builder

LABEL maintainer.0="David Michael <david@crypdex.io>"

ARG VERSION=$VERSION
RUN test -n "$VERSION"

RUN apk add curl su-exec bash

RUN adduser -S lnd

WORKDIR /home/lnd

COPY download-release.sh ./
RUN VERSION=$VERSION bash download-release.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh

# This volume is to be mounted
VOLUME ["/home/lnd/.lnd"]

# GRPC P2P
EXPOSE 10009 9735

ENTRYPOINT ["/entrypoint.sh"]

CMD ["lnd"]
