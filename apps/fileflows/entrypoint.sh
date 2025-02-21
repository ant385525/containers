#!/bin/bash

mode="${FILEFLOWS_MODE:-server}"

if [ "$mode" == "server" ]; then
    printf "Launching server as '$(whoami)'\n"
    cd /app/Server
    exec dotnet FileFlows.Server.dll --urls=http://*:5000
elif [ "$mode" == "node" ]; then
    printf "Launching node as '$(whoami)'\n"
    cd /app/Node
    exec dotnet FileFlows.Node.dll
else
    echo "Unknown mode: $mode. Use 'server' or 'node'."
    exit 1
fi
