#!/usr/bin/env bash
set -e

LOG_FILE="$(dirname "$0")/../logs/install.log"
log() { echo -e "\e[92m[OK]\e[0m $1" | tee -a "$LOG_FILE"; }
err() { echo -e "\e[91m[ERROR]\e[0m $1" | tee -a "$LOG_FILE"; exit 1; }

# Basic validation: check if quickshell runs
if ! quickshell --help >/dev/null 2>&1; then
    err "QuickShell failed to start. Missing QML modules?"
fi

log "QML environment verified successfully."
