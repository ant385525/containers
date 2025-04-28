#!/usr/bin/env bash
# https://github.com/crocodilestick/Calibre-Web-Automated/blob/main/root/etc/s6-overlay/s6-rc.d/cwa-init/run
set -euo pipefail

echo "[cwa-init] Setting binary paths in '/config/app.db' to the correct ones…"

exec sqlite3 /config/app.db <<EOS
UPDATE settings
SET
  config_kepubifypath   = '/usr/bin/kepubify',
  config_converterpath  = '/usr/bin/ebook-convert',
  config_binariesdir    = '/usr/bin';
EOS
