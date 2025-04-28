#!/usr/bin/env bash
# https://github.com/crocodilestick/Calibre-Web-Automated/blob/main/root/etc/s6-overlay/s6-rc.d/cwa-ingest-service/run
set -euo pipefail

echo "[cwa-ingest-service] Monitoring /cwa-book-ingest for new files…"

exec inotifywait -m \
  -e close_write,moved_to --format '%w%f' '/cwa-book-ingest' \
| while read -r NEWFILE; do
    echo "[cwa-ingest-service] Detected new file: $NEWFILE"
    python3 /app/calibre-web-automated/scripts/ingest_processor.py "$NEWFILE"
  done
