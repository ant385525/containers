#!/usr/bin/env bash

IMAGE_NAME="revenz/fileflows"
API_ENDPOINT="https://hub.docker.com/v2/repositories/${IMAGE_NAME}/tags/?page=1&page_size=100&ordering=last_updated"
response=$(curl -s ${API_ENDPOINT})

latest_version=$(echo "${response}" | jq -r '.results[] | select(.name | match("^[0-9]+.[0-9]+$")) | .name' | head -n 1)

digest=$(echo "${response}" | jq ".results[] | select(.name == \"${latest_version}\") | .digest" | tr -d '"' )

printf "Latest Version: %s\nCommit Hash: %s\n" "${latest_version}" "${digest}"
