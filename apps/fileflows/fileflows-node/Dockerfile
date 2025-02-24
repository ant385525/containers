# syntax = devthefuture/dockerfile-x
INCLUDE ./apps/fileflows/Dockerfile.base

ENV FFNODE=1
ENV ServerUrl=http://localhost:5000
# Clean up
RUN rm -rf /app/Server

COPY ./apps/fileflows/fileflows-node/entrypoint.sh /app/Node/entrypoint.sh
RUN chmod +x /app/Node/entrypoint.sh

# Set the container to run as a non-root user
WORKDIR /app
USER nobody:nogroup

ENTRYPOINT ["/usr/bin/catatonit", "--", "/app/Node/entrypoint.sh"]
