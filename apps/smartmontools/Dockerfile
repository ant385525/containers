# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.22.1@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1

ARG VERSION

ENV UMASK="0002" \
    TZ="Etc/UTC"

USER root

RUN apk add --no-cache \
    bash \
    smartmontools=${VERSION}

ENTRYPOINT ["/usr/bin/catatonit", "--", "bash", "-c", "sleep infinity"]
