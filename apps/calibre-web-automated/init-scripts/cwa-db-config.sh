#!/usr/bin/env bash
set -euo pipefail

echo "[init] Creating tables & default settings…"
python3 /app/calibre-web-automated/scripts/cwa_db.py

echo "[init] Setting ENABLE_CWA_UPDATE_NOTIFICATION to ${ENABLE_CWA_UPDATE_NOTIFICATION}"
exec sqlite3 /config/cwa.db <<EOS
UPDATE cwa_settings
    SET cwa_update_notifications = '${ENABLE_CWA_UPDATE_NOTIFICATION}'
EOS
