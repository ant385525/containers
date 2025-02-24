#!/bin/bash
set -e

# Gracefully stop fileflows when pod deleted
shutdown() {
    echo "Shutting down gracefully..."
    kill -TERM "$dotnet_pid"
    wait "$dotnet_pid"
    exit 0
}

# Trap SIGTERM and SIGINT from running FF process
trap shutdown SIGTERM SIGINT

printf "Launching FileFlows server as UID '$(id -u)'\n"

cd /app/Server
# Use & to print PID
dotnet FileFlows.Server.dll --urls=http://*:5000 --docker true &
dotnet_pid=$!

wait "$dotnet_pid"
