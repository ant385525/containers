#!/usr/bin/env bash
# https://github.com/crocodilestick/Calibre-Web-Automated/blob/main/root/etc/s6-overlay/s6-rc.d/cwa-auto-library/run
set -euo pipefail

echo "[cwa-auto-library] Running auto_library…"
exec python3 /app/calibre-web-automated/scripts/auto_library.py
