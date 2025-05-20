# syntax=docker/dockerfile:1

FROM docker.io/library/ubuntu:24.04 AS fileflows-download
ARG VERSION

ENV DEBIAN_FRONTEND="noninteractive" \
    UMASK="0002" \
    TZ="Etc/UTC"

USER root
WORKDIR /app

RUN \
    apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
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
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
        ca-certificates \
        curl \
        unzip \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

FROM docker.io/library/ubuntu:24.04 AS runtime
ARG TARGETARCH
ARG VENDOR
ARG VERSION

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

COPY --from=fileflows-download /app /app

# hadolint ignore=DL3008,DL3015,SC2039,SC2086
RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        apt-transport-https \
        curl \
        gnupg \
        aspnetcore-runtime-8.0 \
        ca-certificates \
        catatonit \
        libfontconfig1 \
        libfreetype6 \
        pciutils \
    && if [ "${TARGETARCH}" = "amd64" ]; then \
        mkdir -p /tmp/intel-compute-runtime && cd /tmp/intel-compute-runtime && \
        curl -LO https://github.com/intel/compute-runtime/releases/download/25.13.33276.16/libigdgmm12_22.7.0_amd64.deb && \
        curl -LO https://github.com/intel/intel-graphics-compiler/releases/download/v2.11.7/intel-igc-core-2_2.11.7+19146_amd64.deb && \
        curl -LO https://github.com/intel/intel-graphics-compiler/releases/download/v2.11.7/intel-igc-opencl-2_2.11.7+19146_amd64.deb && \
        curl -LO https://github.com/intel/compute-runtime/releases/download/25.13.33276.16/intel-opencl-icd_25.13.33276.16_amd64.deb && \
        dpkg -i --force-all ./*.deb && \
        cd /; \
    fi \
    && VERSION_CODENAME=$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2) \
    && curl -fsSL https://repo.jellyfin.org/jellyfin_team.gpg.key \
        | gpg --dearmor -o /etc/apt/trusted.gpg.d/jellyfin_team.gpg \
    && echo "deb [arch=${TARGETARCH}] https://repo.jellyfin.org/ubuntu ${VERSION_CODENAME} main" \
        > /etc/apt/sources.list.d/jellyfin.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        jellyfin-ffmpeg7 \
    && ln -s /usr/lib/jellyfin-ffmpeg/ffmpeg /usr/local/bin/ffmpeg \
    && ln -s /usr/lib/jellyfin-ffmpeg/ffmpeg /usr/local/bin/ffmpeg7 \
    && ln -s /usr/lib/jellyfin-ffmpeg/ffprobe /usr/local/bin/ffprobe \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
        apt-transport-https \
        curl \
        gnupg \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* \
    && mkdir -p /var/tmp/i18n && mv /app/Server/wwwroot/i18n/* /var/tmp/i18n


COPY . /
RUN chmod +x /entrypoint.sh

WORKDIR /app
USER nobody:nogroup
VOLUME ["/app/Data"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
