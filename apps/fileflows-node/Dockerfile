# syntax = devthefuture/dockerfile-x
INCLUDE ./apps/fileflows-server/Dockerfile.base

ENV FFNODE=1
ENV ServerUrl=http://localhost:5000
# Clean up
RUN rm -rf /app/Server

# Set the container to run as a non-root user
USER nobody:nogroup
WORKDIR /app/Node

ENTRYPOINT ["/usr/bin/catatonit", "--", "dotnet", "FileFlows.Node.dll"]
CMD ["--docker", "true"]
