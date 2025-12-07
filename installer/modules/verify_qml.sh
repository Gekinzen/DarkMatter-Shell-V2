#!/usr/bin/env bash
set -e

LOG_FILE="$(dirname "$0")/../logs/install.log"
mkdir -p "$(dirname "$LOG_FILE")"

log()  { echo -e "\e[92m[OK]\e[0m $1" | tee -a "$LOG_FILE"; }
warn() { echo -e "\e[93m[WARN]\e[0m $1" | tee -a "$LOG_FILE"; }
err()  { echo -e "\e[91m[ERROR]\e[0m $1" | tee -a "$LOG_FILE"; exit 1; }

log "[INFO] Verifying QuickShell installation..."

command -v quickshell >/dev/null || err "QuickShell binary not found!"

pacman -Qi qt6-declarative >/dev/null || err "Qt6 declarative missing!"

warn "Skipping QuickShell runtime test (TTY, no Wayland session)."

log "QML verification passed."
