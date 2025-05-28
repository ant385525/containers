# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.21.3 AS fileflows-download
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
    LIBVA_DRIVERS_PATH="/usr/lib/x86_64-linux-gnu/dri" \
    LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu" \
    DOTNET_CLI_TELEMETRY_OPTOUT=true \
    # Default run mode: server='0' node='1'
    FFNODE="0" \
    # Default port: 5000
    PORT="5000"

USER root
WORKDIR /app

COPY --from=fileflows-download /app /app

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
    && VERSION_CODENAME=$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2) \
    && \
        # add plucky repo for up-to-date packages
        if [ "${TARGETARCH}" = "amd64" ]; then \
            RUN echo "deb http://archive.ubuntu.com/ubuntu plucky main universe multiverse" > /etc/apt/sources.list.d/plucky.list
            RUN echo "Package: *\nPin: release n=plucky\n\Pin-Priority: 100\n" \
                > /etc/apt/preferences.d/pin-plucky \
            && apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
                intel-media-va-driver-non-free/plucky \
                libmfx1/plucky \
                vainfo/plucky; \
        fi \
    # Install ffmpeg
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
    && rm -rf /var/lib/apt/lists/* \
    # i18n hack
    && mkdir -p /var/tmp/i18n && mv /app/Server/wwwroot/i18n/* /var/tmp/i18n

COPY . /
RUN chmod +x /entrypoint.sh

USER nobody:nogroup
VOLUME ["/app/Data"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
