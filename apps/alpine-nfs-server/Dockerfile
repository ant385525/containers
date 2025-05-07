# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.21.3
ARG VERSION

ENV UMASK="0002" \
    TZ="Etc/UTC"

USER root
WORKDIR /app
COPY . /

RUN apk add nfs-utils rpcbind \
    && chmod +x /entrypoint.sh

EXPOSE 2049 111 20048

ENTRYPOINT ["/entrypoint.sh"]
