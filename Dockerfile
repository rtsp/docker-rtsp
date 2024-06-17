FROM rtsp/net-tools:1.4.17

LABEL org.opencontainers.image.title="RTSP Tools"
LABEL org.opencontainers.image.authors="RTSP <docker@rtsp.us>"
LABEL org.opencontainers.image.source="https://github.com/rtsp/docker-rtsp"
LABEL org.opencontainers.image.licenses="Apache-2.0"

ARG MONGODB_VERSION=6.0
ARG MONGOSH_VERSION=2.2.6
ARG AWSCLI_VERSION=2.15.52

RUN set -x \
    && curl -fsSL https://www.mongodb.org/static/pgp/server-${MONGODB_VERSION}.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/mongodb-org-${MONGODB_VERSION}.gpg \
    && echo "deb https://repo.mongodb.org/apt/debian bullseye/mongodb-org/${MONGODB_VERSION} main" > /etc/apt/sources.list.d/mongodb-org-${MONGODB_VERSION}.list

ARG TARGETPLATFORM

RUN set -x && apt-get update && apt-get --yes --no-install-recommends install \
    mongodb-mongosh=${MONGOSH_VERSION} \
    $( [ "$TARGETPLATFORM" = "linux/amd64" ] && echo mongodb-database-tools) \
    && rm -rvf /var/lib/apt/lists/*

RUN set -x \
    && mkdir -p /tmp/awscli && cd /tmp/awscli \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-$( [ "$TARGETPLATFORM" = "linux/amd64" ] && echo x86_64 || echo aarch64 )-${AWSCLI_VERSION}.zip" -o awscliv2.zip \
    && unzip -q awscliv2.zip \
    && ./aws/install \
    && rm -rf /tmp/awscli \
    && /usr/local/bin/aws --version

COPY files/ /root/

CMD ["/bin/sleep", "infinity"]
