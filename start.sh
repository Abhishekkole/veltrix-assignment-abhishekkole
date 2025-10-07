#!/bin/bash

LOCKFILE="app.pid"
LOGFILE="logs/output_$(date +'%Y%m%d_%H%M%S').log"

echo "[Swap Optimizer] Starting the path-finder service..."

# Ensure .env exists
if [ ! -f .env ]; then
    echo "[ERROR] Missing .env file. Please run setup.sh first."
    exit 1
fi

# Check PID lock to avoid double-starts
if [ -f "$LOCKFILE" ]; then
    echo "[ERROR] Lock file exists. App is already running."
    exit 2
fi
echo $$ > "$LOCKFILE"

# Run orchestrator logic and tee output to timestamped log
echo "[Swap Optimizer] Starting orchestrator..."
npm run build
npm start 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee "$LOGFILE"
EXIT_CODE=${PIPESTATUS[0]}

# Remove lock file on exit
rm -f "$LOCKFILE"

# Exit non-zero if app terminates abnormally
if [ $EXIT_CODE -ne 0 ]; then
    echo "[ERROR] App terminated abnormally with exit code $EXIT_CODE"
    exit $EXIT_CODE
fi
(
  sleep 300
  pkill -f "node src/app.js"
  echo "[SWAP OPTIMIZER] Simulated crash: app.js stopped after 5 minutes." >> logs/output.log
) &

wait