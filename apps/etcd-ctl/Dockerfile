# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715

ARG VERSION

ENV UMASK="0002" \
    TZ="Etc/UTC"

USER root
WORKDIR /app

RUN apk add --no-cache \
    bash \
    etcd-ctl

USER nobody:nogroup

ENTRYPOINT ["bash", "-c", "sleep infinity & wait"]
