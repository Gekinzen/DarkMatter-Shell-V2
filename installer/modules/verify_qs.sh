#!/usr/bin/env bash
set -e

LOG="installer/logs/install.log"
log() { echo -e "\e[92m[OK]\e[0m $1" | tee -a "$LOG"; }
warn() { echo -e "\e[93m[WARN]\e[0m $1" | tee -a "$LOG"; }

if [[ -z "$WAYLAND_DISPLAY" ]]; then
    warn "Not in Wayland session. QuickShell runtime test skipped."
else
    qs --version >/dev/null 2>&1 && log "QuickShell is runnable."
fi
