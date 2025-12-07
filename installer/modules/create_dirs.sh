#!/usr/bin/env bash
set -e

LOG_FILE="$(dirname "$0")/../logs/install.log"

log() { echo -e "\e[92m[OK]\e[0m $1" | tee -a "$LOG_FILE"; }

DIRS=(
  ~/.config/quickshell
  ~/.config/hypr
  ~/.config/mako
  ~/.config/swww
  ~/.config/systemd/user
)

for d in "${DIRS[@]}"; do
  mkdir -p "$d"
done

log "All required directories created."
