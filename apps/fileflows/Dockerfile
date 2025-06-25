# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.22.0 AS fileflows-download
ARG VERSION

USER root
WORKDIR /app

RUN \
    apk add --no-cache \
        ca-certificates \
        curl \
        unzip \
    && curl -fsSL "https://fileflows.com/downloads/Zip/${VERSION}" -o /tmp/fileflows.zip \
    && unzip /tmp/fileflows.zip -d /app \
    # Init directories
    && mkdir -p /app/Plugins /app/DockerMods /app/common \
        /app/Logs /app/ManuallyAdded /app/Templates /app/Data/Data \
    && chown -R nobody:nogroup /app \
    && chmod -R 755 /app \
    # Clean up image
    && rm -rf /tmp/* /app/{FlowRunner,Node,Server}/runtimes \
        /app/{FlowRunner,Node,Server}/*.exe /app/Server/Nodes /app/*.* \
    && apk del \
        ca-certificates \
        curl \
        unzip

FROM docker.io/library/alpine:3.22.0 AS btbn-download
ARG TARGETARCH

USER root
WORKDIR /app/common/ffmpeg-static

RUN \
    if [ "$TARGETARCH" = "amd64" ]; then \
        BTBN_ARCH="linux64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BTBN_ARCH="linuxarm64"; \
    fi \
    && apk add --no-cache \
        ca-certificates \
        curl \
        tar \
        xz \
    && curl -fsSL "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-${BTBN_ARCH}-gpl.tar.xz" \
        | tar -xJ --strip-components=1 -C /tmp \
            --wildcards '*/bin/ffmpeg' '*/bin/ffprobe' \
    && mv /tmp/bin/ffmpeg /app/common/ffmpeg-static/ffmpeg \
    && mv /tmp/bin/ffprobe /app/common/ffmpeg-static/ffprobe \
    && chmod +x /app/common/ffmpeg-static/ffmpeg /app/common/ffmpeg-static/ffprobe \
    # Clean up image
    && rm -rf /tmp/* \
    && apk del \
        ca-certificates \
        curl \
        tar \
        xz

FROM docker.io/library/ubuntu:24.04 AS runtime
ARG TARGETARCH
ARG VENDOR
ARG VERSION
ARG FFMPEG_VERSION

ENV DEBIAN_FRONTEND="noninteractive" \
    UMASK="0002" \
    TZ="Etc/UTC"

ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility" \
    NVIDIA_VISIBLE_DEVICES="all" \
    DOTNET_CLI_TELEMETRY_OPTOUT=true \
    # Default run mode: server='0' node='1'
    FFNODE="0" \
    # Default port: 5000
    PORT="5000"

USER root
WORKDIR /app

COPY --from=fileflows-download /app /app
COPY --from=btbn-download /app/common/ffmpeg-static /app/common/ffmpeg-static

# hadolint ignore=DL3008,DL3015,SC2039,SC2086
RUN \
    apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
        # Can uninstall before build
        apt-transport-https \
        curl \
        gnupg \
        # Needed for FF to run
        aspnetcore-runtime-8.0 \
        ca-certificates \
        catatonit \
        libfontconfig1 \
        libfreetype6 \
        pciutils \
    # Install ffmpeg
    && VERSION_CODENAME=$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2) \
    && curl -fsSL https://repo.jellyfin.org/jellyfin_team.gpg.key \
        | gpg --dearmor -o /etc/apt/trusted.gpg.d/jellyfin_team.gpg \
    && echo "deb [arch=${TARGETARCH}] https://repo.jellyfin.org/ubuntu ${VERSION_CODENAME} main" \
        > /etc/apt/sources.list.d/jellyfin.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        jellyfin-ffmpeg7=${FFMPEG_VERSION} \
    # ffmpeg link
    && ln -s /usr/lib/jellyfin-ffmpeg/ffmpeg /usr/local/bin/ffmpeg \
    && ln -s /usr/lib/jellyfin-ffmpeg/ffmpeg /usr/local/bin/ffmpeg7 \
    && ln -s /usr/lib/jellyfin-ffmpeg/ffprobe /usr/local/bin/ffprobe \
    # Clean up unnecessary packages
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
        apt-transport-https \
        curl \
        gnupg \
    && apt-get autoremove -y \
    && apt-get clean \
    # Clean up image
    && rm -rf /var/lib/apt/lists/* /tmp/* \
    # i18n hack
    && mkdir -p /var/tmp/i18n && mv /app/Server/wwwroot/i18n/* /var/tmp/i18n

COPY . /
RUN chmod +x /entrypoint.sh

USER nobody:nogroup
VOLUME ["/app/Data"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
