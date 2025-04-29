# syntax=docker/dockerfile:1

FROM docker.io/alpine/git:v2.47.2 AS cwa-download
ARG VERSION
WORKDIR /tmp/cwa
USER root

RUN \
    mkdir -p /app/calibre-web-automated /app/calibre-web/cps \
    && git clone --quiet --branch "V${VERSION}" --depth 1 \
        https://github.com/crocodilestick/Calibre-Web-Automated.git /tmp/cwa \
    && cp -r requirements.txt dirs.json  \
        scripts empty_library \
        /app/calibre-web-automated \
    && cp -r root/app/calibre-web/cps/* /app/calibre-web/cps/ \
    && rm -rf /tmp/cwa

FROM python:3.13-slim AS builder
ENV \
    DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1

COPY --from=ghcr.io/bjw-s-labs/calibre-web:0.6.24 /app/requirements.txt /app/optional-requirements.txt /calibre-web/
COPY --from=cwa-download /app/calibre-web-automated/requirements.txt /calibre-web-automated/requirements.txt

RUN \
    apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
        gcc \
        libldap2-dev \
        libsasl2-dev \
    && pip install --upgrade pip uv \
    && uv pip install --system \
        -r /calibre-web-automated/requirements.txt \
        -r /calibre-web/requirements.txt \
        -r /calibre-web/optional-requirements.txt \
    && apt-get purge -y --auto-remove \
        gcc \
        libldap2-dev \
        libsasl2-dev \
    && rm -rf /var/lib/apt/lists/*


FROM docker.io/library/python:3.12-slim AS runtime
ARG TARGETARCH
ARG VENDOR
ARG VERSION
# renovate: datasource=github-releases depName=aptible/supercronic
ARG SUPERCRONIC_VERSION=v0.2.33

ENV \
    DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
ENV UMASK="0002" \
    TZ="Etc/UTC" \
    APP_MODE="production" \
    DEFAULT_CACHE_DIR="/cache" \
    CACHE_DIR="/cache" \
    DEFAULT_PORT="8083" \
    CALIBRE_DBPATH="/config" \
    # 1=enabled 0=disabled
    ENABLE_CWA_UPDATE_NOTIFICATION=1

USER root
WORKDIR /app

COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=ghcr.io/bjw-s-labs/kepubify:4.0.4 /app/kepubify /usr/bin/kepubify
COPY --from=ghcr.io/cdloh/calibre-bare:8.3.0 / /app/calibre
COPY --from=ghcr.io/linuxserver/unrar:7.1.6 /usr/bin/unrar-ubuntu /usr/bin/unrar
COPY --from=ghcr.io/bjw-s-labs/calibre-web:0.6.24 /app /app/calibre-web
COPY --from=cwa-download /app/calibre-web/cps/* /app/calibre-web/cps/
COPY --from=cwa-download /app/calibre-web-automated /app/calibre-web-automated
COPY . /

RUN \
    apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
        curl \
        catatonit \
        file \
        ghostscript \
        inotify-tools \
        libegl1-mesa \
        libgl1-mesa-glx \
        libmagic1 \
        libnss3 \
        libopengl0 \
        libxkbcommon0 \
        sqlite3 \
    # Add cronjob
    && echo "@daily python3 /app/calibre-web-automated/scripts/auto_zip.py" \
        >> /etc/cron.d/auto_zip \
    && curl -fsSL "https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-${TARGETARCH}" \
        -o /usr/local/bin/supercronic \
    && chmod +x /usr/local/bin/supercronic \
    # Setup directories from setup-cwa.sh
    && mkdir -p /app/calibre-web-automated/metadata_change_logs /app/calibre-web-automated/metadata_temp \
    /cwa-book-ingest /calibre-library \
    && chown -R nobody:nogroup /app /cwa-book-ingest /calibre-library \
    && chmod -R 755 /app /cwa-book-ingest /calibre-library \
    # Setup config directories from cwa-init
    && mkdir -p /config/processed_books/converted /config/processed_books/imported /config/processed_books/failed \
        /config/processed_books/fixed_originals /config/log_archive /config/.cwa_conversion_tmp \
    && chown -R nobody:nogroup /config \
    && chmod -R 755 /config \
    # Symlink calibre binaries to /usr/bin
    && for bin in /app/calibre/*; do \
      if [ -f "$bin" ] && [ -x "$bin" ]; then \
        ln -sf "$bin" "/usr/bin/$(basename "$bin")"; \
      fi; \
    done \
    # Set scripts as executable
    && chmod +x /entrypoint.sh /init-scripts/* \
    # Cleanup
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    # Hack for hardcoded chowns everywhere
    && rm /usr/bin/chown \
    && printf '%s\n' '#!/bin/sh' 'exit 0' > /usr/bin/chown \
    && chmod +x /usr/bin/chown

USER nobody:nogroup
ENTRYPOINT ["/usr/bin/catatonit", "-g", "--", "/entrypoint.sh"]
