#!/usr/bin/env bash

ENDPOINT="https://fileflows.com/auto-update/latest-version?platform=docker"
response=$(curl -s ${ENDPOINT})

printf ${latest_version}
