#!/bin/bash

~/.config/quickshell/scripts/workspaces-engine.sh

# Restart QuickShell
systemctl --user restart quickshell

notify-send "QuickShell Ready" "Zenith Workspace Engine Initialized"
