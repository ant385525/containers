# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715

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
