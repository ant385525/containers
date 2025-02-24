# syntax = devthefuture/dockerfile-x
INCLUDE ./apps/fileflows/Dockerfile.base

ENV FFNODE=1
# Clean up and init dirs
RUN rm -rf /app/Server && \
    mkdir -p /temp /app/Data/Dockermods /app/Logs /app/common /app/ManuallyAdded && \
    chown -R nobody:nogroup /temp /app && \
    chmod -R 755 /app

COPY ./apps/fileflows/fileflows-node/entrypoint.sh /app/Node/entrypoint.sh
RUN chmod +x /app/Server/entrypoint.sh

# Set the container to run as a non-root user
WORKDIR /app
USER nobody:nogroup
VOLUME ["/app"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/app/Node/entrypoint.sh"]
