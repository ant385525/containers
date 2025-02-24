# syntax = devthefuture/dockerfile-x
INCLUDE ./apps/fileflows/Dockerfile.base

# Clean up and init dirs
RUN rm -rf /app/Node && \
    # IDK why this is needed don't speak microsoft
    chmod -R 777 /app/Server/wwwroot/i18n

# Set the container to run as a non-root user
USER nobody:nogroup

# Expose the port used by FileFlows
EXPOSE 5000
VOLUME ["/app/Data"]
WORKDIR /app/Server

ENTRYPOINT ["/usr/bin/catatonit", "--", "dotnet", "FileFlows.Server.dll"]
CMD ["--docker", "true", "--urls=http://*:5000"]
