#!/usr/bin/env bash
set -euo pipefail

echo "Starting Calibre Web Automated"

# Hack for dirs.json
mv /var/tmp/calibre-web-automated/* /app/calibre-web-automated/
echo "Running init scripts..."

# https://github.com/crocodilestick/Calibre-Web-Automated/blob/main/root/etc/s6-overlay/s6-rc.d/cwa-init/run
bash /init-scripts/cwa-db-init.sh
bash /init-scripts/cwa-binary-paths.sh
# https://github.com/crocodilestick/Calibre-Web-Automated/blob/main/root/etc/s6-overlay/s6-rc.d/cwa-auto-library/run
bash /init-scripts/cwa-auto-library.sh

# Fully initialize db to set custom settings
bash /init-scripts/cwa-db-config.sh

pids=()
echo "init scripts complete. Starting services in the background..."
# https://github.com/crocodilestick/Calibre-Web-Automated/blob/main/root/etc/s6-overlay/s6-rc.d/cwa-auto-zipper/run
bash /init-scripts/cwa-auto-zipper.sh & pids+=($!)
# https://github.com/crocodilestick/Calibre-Web-Automated/blob/main/root/etc/s6-overlay/s6-rc.d/cwa-ingest-service/run
bash /init-scripts/cwa-ingest-service.sh & pids+=($!)
# https://github.com/crocodilestick/Calibre-Web-Automated/blob/main/root/etc/s6-overlay/s6-rc.d/metadata-change-detector/run
bash /init-scripts/cwa-metadata-service.sh & pids+=($!)

echo "services started. Starting app..."
# start app
python3 /app/calibre-web/cps.py & pids+=($!)

# Wait until any process exits
wait -n "${pids[@]}"
exit_code=$?
exit $exit_code

echo "A process died with code ${exit_code} shutting container down..."
kill "${pids[@]}" 2>/dev/null || true
exit $exit_code
