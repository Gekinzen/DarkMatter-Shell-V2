#!/bin/bash

LOCK_FILE="/tmp/nwg-display.lock"

if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "nwg-displays already running"
        exit 0
    else
        rm -f "$LOCK_FILE"
    fi
fi

echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

nwg-displays

echo "Applying monitor scale + reserved fixes..."
~/.config/hypr/scripts/fix-monitor-scale.sh
