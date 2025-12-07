#!/bin/bash

MONITORS_CONF="$HOME/.config/hypr/monitors.conf"
BACKUP_CONF="$HOME/.config/hypr/monitors.conf.autosave.backup"

if ! command -v jq >/dev/null 2>&1; then
    echo "jq is required (sudo pacman -S jq)"
    exit 1
fi

MON_JSON=$(hyprctl monitors -j 2>/dev/null)
if [ -z "$MON_JSON" ]; then
    echo "hyprctl monitors -j failed"
    exit 1
fi

cp "$MONITORS_CONF" "$BACKUP_CONF" 2>/dev/null || true

{
    echo "# Auto-saved from hyprctl on $(date)"
    echo ""
    echo "$MON_JSON" | jq -r '
        .[] | 
        "monitor=\(.name),\(.width)x\(.height)@\(.refreshRate|floor),\(.x)x\(.y),\(.scale)"
    '
} > "$MONITORS_CONF"

~/.config/hypr/scripts/fix-monitor-scale.sh
