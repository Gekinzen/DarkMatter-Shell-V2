#!/usr/bin/env bash
set -e

LOG_FILE="$(dirname "$0")/../logs/install.log"
log() { echo -e "\e[92m[OK]\e[0m $1" | tee -a "$LOG_FILE"; }
warn(){ echo -e "\e[93m[WARN]\e[0m $1"| tee -a "$LOG_FILE"; }

copy_if_exists() {
  if [[ -d "$1" ]]; then
    cp -r "$1" "$2"
    log "Copied: $1 → $2"
  else
    warn "Missing config folder: $1"
  fi
}

copy_if_exists "config/quickshell/" ~/.config/quickshell/
copy_if_exists "config/hypr/" ~/.config/hypr/
copy_if_exists "config/mako/" ~/.config/mako/
copy_if_exists "config/swww/" ~/.config/swww/
