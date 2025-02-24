# syntax = devthefuture/dockerfile-x
INCLUDE ./apps/fileflows/Dockerfile.base

    # Clean up and init dirs
RUN rm -rf /app/Node && \
    # IDK why this is needed don't speak microsoft
    chmod -R 777 /app/Server/wwwroot/i18n

COPY ./apps/fileflows/fileflows-server/entrypoint.sh /app/Server/entrypoint.sh
RUN chmod +x /app/Server/entrypoint.sh

# Set the container to run as a non-root user
WORKDIR /app
USER nobody:nogroup

# Expose the port used by FileFlows
EXPOSE 5000
VOLUME ["/app/Data"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/app/Server/entrypoint.sh"]
