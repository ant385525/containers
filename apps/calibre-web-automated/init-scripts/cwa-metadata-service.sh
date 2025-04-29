#!/usr/bin/env bash
# https://github.com/crocodilestick/Calibre-Web-Automated/blob/main/root/etc/s6-overlay/s6-rc.d/metadata-change-detector/run
set -euo pipefail

echo "[cwa-metadata-change-detector] Starting…"

WATCH_FOLDER="/app/calibre-web-automated/metadata_change_logs"
echo "[cwa-metadata-change-detector] Watching folder: $WATCH_FOLDER"

exec inotifywait -m \
  -e close_write,moved_to \
  --exclude '^.*\.(swp)$' \
  "$WATCH_FOLDER" \
| while read -r DIR EVENT FILE; do
    echo "[cwa-metadata-change-detector] New file detected: $FILE"
    python3 /app/calibre-web-automated/scripts/cover_enforcer.py --log "$FILE"
  done
