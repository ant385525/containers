# syntax=docker/dockerfile:1

ARG VERSION
FROM ghcr.io/calibrain/calibre-web-automated-book-downloader:${VERSION} AS og

FROM docker.io/library/python:3.13-slim

COPY . /

ENV DEBIAN_FRONTEND=noninteractive \
    DOCKERMODE=true \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONIOENCODING=UTF-8 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100 \
    NAME=Calibre-Web-Automated-Book-Downloader \
    PYTHONPATH=/app \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    APP_ENV=prod \
    UMASK="0002" \
    TZ="Etc/UTC" \
    # CF bypass not supported in this container
    USE_CF_BYPASS="false"

USER root
WORKDIR /app

COPY --from=og /app /app

RUN \
    apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
        catatonit \
    && pip install --upgrade pip uv \
    && uv pip install --system --no-cache-dir -r /requirements.txt \
    && mkdir -p /var/log/cwa-book-downloader /cwa-book-ingest \
    && chown -R nobody:nogroup /app /var/log/cwa-book-downloader /cwa-book-ingest \
    && chmod -R 755 /app /var/log/cwa-book-downloader /cwa-book-ingest \
    # clean up
    && rm -rf /root/.cache \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER nobody:nogroup

ENTRYPOINT ["/usr/bin/catatonit", "--", "gunicorn", "-t", "300", "-b", "0.0.0.0:8084", "app:app"]
