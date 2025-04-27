#!/usr/bin/env bash
# https://github.com/crocodilestick/Calibre-Web-Automated/blob/main/root/etc/s6-overlay/s6-rc.d/cwa-auto-zipper/run
set -euo pipefail

echo "[cwa-init] Setting binary paths in '/config/app.db' to the correct ones…"

sqlite3 /config/app.db <<EOS
UPDATE settings
SET
  config_kepubifypath   = '/usr/bin/kepubify',
  config_converterpath  = '/usr/bin/ebook-convert',
  config_binariesdir    = '/usr/bin';
EOS

echo "[cwa-init] Successfully set binary paths in '/config/app.db'!"
