# syntax = edrevo/dockerfile-plus
INCLUDE+ ../Dockerfile.base

    # Clean up and init dirs
RUN rm -rf /app/Node && \
    mkdir -p /temp /app/Data/Dockermods /app/Logs /app/common /app/ManuallyAdded && \
    chown -R nobody:nogroup /temp /app && \
    chmod -R 755 /app && \
    # IDK why this is needed don't speak microsoft
    chmod -R 777 /app/Server/wwwroot/i18n

COPY ./apps/fileflows-server/entrypoint.sh /app/Server/entrypoint.sh
RUN chmod +x /app/Server/entrypoint.sh

# Set the container to run as a non-root user
WORKDIR /app
USER nobody:nogroup
VOLUME ["/app"]

# Expose the port used by FileFlows
EXPOSE 5000

ENTRYPOINT ["/usr/bin/catatonit", "--", "/app/Server/entrypoint.sh"]
