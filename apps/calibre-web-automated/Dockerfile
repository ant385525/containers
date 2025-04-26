# syntax=docker/dockerfile:1

FROM docker.io/library/python:3.12-alpine
ARG TARGETARCH
ARG VENDOR
ARG VERSION

ENV UMASK="0002" \
    TZ="Etc/UTC"

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1

USER root
WORKDIR /app


COPY --from=ghcr.io/bjw-s-labs/calibre-web:0.6.24 /config /app/calibre-web
COPY --from=ghcr.io/bjw-s-labs/kepubify:4.0.4 /app/kepubify /opt/kepubify/kepubify
COPY --from=ghcr.io/cdloh/calibre-bare:8.3.0 / /app/calibre
COPY --from=ghcr.io/linuxserver/unrar:7.1.6 /usr/bin/unrar-alpine /usr/bin/unrar

RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        ghostscript \
        inotify-tools \
        libc6-compat \
        libldap \
        libmagic \
        libsasl \
        libxi \
        libxml2 \
        libxslt \
        sqlite \
    # && pip install --upgrade -r /app/calibre-web-automated/requirements.txt \
