# Specify the base image (e.g., Ubuntu)
FROM ubuntu:24.04

# Set build arguments
ARG RELEASE
ARG LAUNCHPAD_BUILD_ARCH

# Add metadata labels
LABEL org.opencontainers.image.ref.name="fileflows"
LABEL org.opencontainers.image.version="24.04"

# Set the environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV DOTNET_ROOT=/usr/share/dotnet
ENV PATH="/usr/share/dotnet:/dotnet:/dotnet/tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
    NVIDIA_DRIVER_CAPABILITIES="compute,video,utility" \
    NVIDIA_VISIBLE_DEVICES="all" \
    DOTNET_CLI_TELEMETRY_OPTOUT=true

# Install dependencies for FileFlows
RUN apt-get update && \
    apt-get install -y \
        wget \
        unzip \
        curl \
        gpg \
        aspnetcore-runtime-8.0 \
    && rm -rf /var/lib/apt/lists/*

# Download and set up FileFlows
WORKDIR /tmp/fileflows
RUN wget -O FileFlows.zip https://fileflows.com/downloads/zip && \
    unzip FileFlows.zip -d /app && \
    cd /app && \
    bash /bin/sh -c 'for file in *.sh; do [ -f "$file" ] && chmod +x "$file"; done'

# TESTING w local file
# WORKDIR /tmp/fileflows
# COPY fileflows.zip .
# RUN unzip fileflows.zip -d /app && \
#     cd /app && \
#     bash -c 'for file in *.sh; do [ -f "$file" ] && chmod +x "$file"; done'

# DockerMods hack
# FFMPEG7
RUN wget -O /tmp/FFmpeg7.sh https://raw.githubusercontent.com/revenz/FileFlowsRepository/refs/heads/master/DockerMods/FFmpeg7.sh && \
    chmod +x /tmp/FFmpeg7.sh && \
    bash /tmp/FFmpeg7.sh

COPY entrypoint.sh /app/server/entrypoint.sh
RUN chmod +x /app/server/entrypoint.sh

RUN mkdir -p /temp /app /app/Data/Dockermods /app/Logs /app/common && \
    chown -R nobody:nogroup /temp /app
# Set the container to run as a non-root user
USER nobody:nogroup
WORKDIR /app
VOLUME ["/app"]

# Expose the port used by FileFlows
EXPOSE 5000

# Set the custom entrypoint
ENTRYPOINT ["/app/server/entrypoint.sh"]
