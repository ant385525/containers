# Specify the base image (e.g., Ubuntu)
FROM docker.io/library/ubuntu:24.04

# Set build arguments
ARG LAUNCHPAD_BUILD_ARCH
ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

# Add metadata labels
LABEL org.opencontainers.image.ref.name="fileflows"
LABEL org.opencontainers.image.version="25.02"

# Set the environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN="true" \
    DEBIAN_FRONTEND="noninteractive" \
    UMASK="0002" \
    TZ="Etc/UTC" \
    DOTNET_ROOT=/usr/share/dotnet \
    PATH="/usr/share/dotnet:/dotnet:/dotnet/tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
    NVIDIA_DRIVER_CAPABILITIES="compute,video,utility" \
    NVIDIA_VISIBLE_DEVICES="all" \
    DOTNET_CLI_TELEMETRY_OPTOUT=true \
    UMASK="0002" \
    SQLITE_TMPDIR="/tmp/sqlite/"

USER root
WORKDIR /app

# All ff deps
RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
        catatonit \
        aspnetcore-runtime-8.0 \
        tzdata \
        ca-certificates \
        gnupg \
        nano \
        curl \
        apt-transport-https \
        openssl \
        locales \
        libfontconfig1 \
        libfreetype6 \
        pciutils \
        ccextractor \
        aom-tools \
        svt-av1 \
        x265 \
        x264 \
        vainfo \
        libva-dev \
        mesa-va-drivers \
        unzip && \
    if [ "$(dpkg --print-architecture)" = "amd64" ]; then \
        apt-get install -y \
            libmfx-gen1.2 \
            intel-media-va-driver-non-free \
            i965-va-driver-shaders; \
    fi && \
    rm -rf /var/lib/apt/lists/*

# Download FF and clean up unneeded dirs
RUN curl -fsSL -o /tmp/fileflows.zip https://fileflows.com/downloads/zip && \
    unzip /tmp/fileflows.zip -d /app && \ rm -rf /app/Server /app/server-upgrade.bat /app/server-upgrade-actual.bat /app/server-upgrade.sh && \
    find /app/FlowRunner/runtimes /app/Node/runtimes -mindepth 1 -maxdepth 1 -type d ! -name "linux-x64" ! -name "linux-arm64" ! -name "unix" -exec rm -rf {} + && \
    find . -type f -name "*.sh" -exec chmod +x {} \;

# jellyfin-FFMPEG7
# Taken from dockermod https://raw.githubusercontent.com/revenz/FileFlowsRepository/refs/heads/master/DockerMods/FFmpeg7.sh
RUN curl -fsSL https://repo.jellyfin.org/debian/jellyfin_team.gpg.key | gpg --dearmor --batch --yes -o /etc/apt/trusted.gpg.d/debian-jellyfin.gpg && \
    os_id=$(awk -F'=' '/^ID=/{ print $NF }' /etc/os-release) && \
    os_codename=$(awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release) && \
    echo "deb [arch=$(dpkg --print-architecture)] https://repo.jellyfin.org/$os_id $os_codename main" | tee /etc/apt/sources.list.d/jellyfin.list && \
    apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
    jellyfin-ffmpeg7 && \
    ln -s /usr/lib/jellyfin-ffmpeg/ffmpeg /usr/local/bin/ffmpeg && \
    ln -s /usr/lib/jellyfin-ffmpeg/ffprobe /usr/local/bin/ffprobe

COPY ./apps/fileflows-node/entrypoint.sh /app/Node/entrypoint.sh
RUN chmod +x /app/Node/entrypoint.sh

RUN mkdir -p /temp /app/Data/Dockermods /app/Logs /app/common /app/ManuallyAdded && \
    chown -R nobody:nogroup /temp /app && \
    chmod -R 755 /app

# purge packages that aren't needed at runtime
RUN apt-get purge -y \
        gnupg \
        curl \
        apt-transport-https \
        ca-certificates && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Set the container to run as a non-root user
USER nobody:nogroup

VOLUME ["/app"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/app/Node/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/revenz/fileflows"
