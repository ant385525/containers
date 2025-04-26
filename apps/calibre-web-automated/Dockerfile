# syntax=docker/dockerfile:1

FROM docker.io/alpine/git:v2.47.2 AS cwa-download

ARG VERSION
    
WORKDIR /app
USER root

RUN \
    git clone --branch V3.0.4 --depth 1 \
        https://github.com/crocodilestick/Calibre-Web-Automated.git /tmp \
    && cp -r /tmp/requirements.txt /tmp/dirs.json /tmp/scripts /tmp/root/* /app \
    && rm -rf /tmp/* 


FROM docker.io/library/python:3.12-alpine AS runtime
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
COPY --from=cwa-download /app /app/calibre-web-automated

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
    && pip install --upgrade -r /app/calibre-web-automated/requirements.txt \
