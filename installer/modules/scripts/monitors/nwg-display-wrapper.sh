#!/bin/bash

LOCK_FILE="/tmp/nwg-display.lock"

if [ -f "$LOCK_FILE" ] && ps -p "$(cat "$LOCK_FILE")" >/dev/null 2>&1; then
    echo "nwg-displays already running"
    exit 0
fi

echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

# launch gui
nwg-displays

# auto-fix after closing
~/.config/hypr/scripts/fix-monitor-scale.sh
