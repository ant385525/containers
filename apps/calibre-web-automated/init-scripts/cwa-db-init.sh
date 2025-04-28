#!/usr/bin/env bash
# https://github.com/crocodilestick/Calibre-Web-Automated/blob/main/root/etc/s6-overlay/s6-rc.d/cwa-init/run
set -euo pipefail

echo "[cwa-db-init] Checking for an existing app.db in /config..."
if [ ! -f /config/app.db ]; then
    echo "[cwa-db-init] No existing app.db found! Creating new one..."
    exec cp /app/calibre-web-automated/empty_library/app.db /config/app.db
else
    echo "[cwa-db-init] Existing app.db found!"
fi
