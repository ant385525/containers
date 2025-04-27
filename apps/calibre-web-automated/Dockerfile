# syntax=docker/dockerfile:1

FROM docker.io/alpine/git:v2.47.2 AS cwa-download

ARG VERSION
WORKDIR /tmp/cwa
USER root

RUN \
    mkdir /app \
    && git clone --branch "V${VERSION}" --depth 1 \
        https://github.com/crocodilestick/Calibre-Web-Automated.git /tmp/cwa \
    && cp -r requirements.txt dirs.json  \
        scripts root/* empty_library \
        /app/ \
    && rm -rf /tmp/cwa


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
COPY --from=ghcr.io/bjw-s-labs/kepubify:4.0.4 /app/kepubify /usr/bin/kepubify
COPY --from=ghcr.io/cdloh/calibre-bare:8.3.0 / /app/calibre
COPY --from=ghcr.io/linuxserver/unrar:7.1.6 /usr/bin/unrar-alpine /usr/bin/unrar
COPY --from=cwa-download /app /app/calibre-web-automated
COPY . /

RUN deluser nobody && delgroup nogroup \
    && addgroup -S -g 65534 abc \
    && adduser -S -H -u 65534 -G abc abc

RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
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
        supercronic \
    && pip install --upgrade -r /app/calibre-web-automated/requirements.txt \
    # Add cronjob
    && echo "@daily python3 /app/calibre-web-automated/scripts/auto_zip.py" >> /app/calibre-web-automated/cron \
    # Setup directories from setup-cwa.sh
    && mkdir -p /app/calibre-web-automated/metadata_change_logs /app/calibre-web-automated/metadata_temp \
    /cwa-book-ingest /calibre-library \
    && chown -R abc:abc /app/calibre-web-automated /cwa-book-ingest /calibre-library \
    && chmod -R 755 /app/calibre-web-automated /cwa-book-ingest /calibre-library \
    # Setup config directories from cwa-init
    && mkdir -p /config/processed_books/converted /config/processed_books/imported /config/processed_books/failed \
        /config/processed_books/fixed_originals /config/log_archive /config/.cwa_conversion_tmp \
    && chown -R abc:abc /config \
    && chmod -R 755 /config \
    # Set scripts as executable
    && chmod +x /entrypoint.sh /init-scripts/*

USER abc:abc
ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
