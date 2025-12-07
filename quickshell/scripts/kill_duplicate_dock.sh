#!/usr/bin/env bash

# Kill duplicate QuickShell dock windows
DOCK_COUNT=$(hyprctl clients | grep -c "quickshell:dock")

if [ "$DOCK_COUNT" -gt 1 ]; then
    echo "[QS] Duplicate dock detected — fixing..."
    hyprctl clients | grep "quickshell:dock" | tail -n +2 | awk '{print $1}' | xargs -I {} hyprctl kill {}
fi
