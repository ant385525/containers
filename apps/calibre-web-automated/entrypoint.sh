#!/usr/bin/env bash
set -euo pipefail

echo "Starting Calibre Web Automated"
echo "Running init scripts..."

# https://github.com/crocodilestick/Calibre-Web-Automated/blob/main/root/etc/s6-overlay/s6-rc.d/cwa-init/run
bash /init-scripts/cwa-db-init.sh
bash /init-scripts/cwa-binary-paths.sh
# https://github.com/crocodilestick/Calibre-Web-Automated/blob/main/root/etc/s6-overlay/s6-rc.d/cwa-auto-library/run
bash /init-scripts/cwa-auto-library.sh

echo "init scripts complete. Starting application..."
# https://github.com/crocodilestick/Calibre-Web-Automated/blob/main/root/etc/s6-overlay/s6-rc.d/cwa-auto-zipper/run
bash /init-scripts/cwa-auto-zipper.sh &
ZIPPER_PID=$!
# https://github.com/crocodilestick/Calibre-Web-Automated/blob/main/root/etc/s6-overlay/s6-rc.d/cwa-ingest-service/run
bash /init-scripts/cwa-ingest-service.sh &
INGEST_PID=$!
# https://github.com/crocodilestick/Calibre-Web-Automated/blob/main/root/etc/s6-overlay/s6-rc.d/metadata-change-detector/run
bash /init-scripts/cwa-metadata-service.sh &
METADATA_PID=$!

# Kill container if any app script fails
wait -n
code=$?
echo "[entrypoint] A child exited with exit code $code — terminating the rest."
kill -- "$ZIPPER_PID" "$INGEST_PID" "$METADATA_PID" 2>/dev/null || true
exit $code
# Process exited w/ code 0, wait for others
wait
