#!/usr/bin/env bash
# https://github.com/crocodilestick/Calibre-Web-Automated/blob/main/root/etc/s6-overlay/s6-rc.d/cwa-auto-zipper/run
set -euo pipefail

echo "[auto-zipper] Enabling cronjob..."
supercronic /app/calibre-web-automated/cron

