# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.21.3@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c

ARG VERSION

ENV UMASK="0002" \
    TZ="Etc/UTC" \
    SOURCE="/source" \
    TARGET="/target"

USER root
WORKDIR /app
COPY . /

RUN apk add --no-cache catatonit lsyncd=${VERSION} \
    && mkdir /source /target \
    && chown -R nobody:nogroup /source /target

USER nobody:nogroup

ENTRYPOINT ["/usr/bin/catatonit", "--", "lsyncd", "-nodaemon", "/lsyncd.conf.lua"]
