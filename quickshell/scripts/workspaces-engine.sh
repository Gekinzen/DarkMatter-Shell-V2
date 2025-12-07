#!/bin/bash

QS_DIR="$HOME/.config/quickshell"
WORKSPACE_JSON="$QS_DIR/cache/workspaces.json"

mkdir -p "$QS_DIR/cache"

# Read monitor data
MONITORS=$(hyprctl monitors -j)

# Extract monitor names
MONITOR_NAMES=$(echo "$MONITORS" | jq -r '.[].name')
MONITOR_COUNT=$(echo "$MONITORS" | jq 'length')

WORKSPACES_PER_MONITOR=10

# Build workspace map JSON
JSON="{\"monitors\":["

i=0
for MON in $MONITOR_NAMES; do
    START=$((i * WORKSPACES_PER_MONITOR + 1))
    END=$((START + WORKSPACES_PER_MONITOR - 1))

    JSON="$JSON{\"name\":\"$MON\",\"start\":$START,\"end\":$END}"

    i=$((i + 1))

    if [ $i -lt $MONITOR_COUNT ]; then
        JSON="$JSON,"
    fi
done

JSON="$JSON]}"

echo "$JSON" > "$WORKSPACE_JSON"

# Notify QuickShell
quickshell ipc call workspaces reload

notify-send "Zenith Workspaces Updated" "Detected $MONITOR_COUNT monitors"
