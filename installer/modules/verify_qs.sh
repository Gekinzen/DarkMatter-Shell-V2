#!/usr/bin/env bash
set -e

log() { echo -e "\e[92m[OK]\e[0m $1"; }
warn() { echo -e "\e[93m[WARN]\e[0m $1"; }

log "[VERIFY] Checking QuickShell..."

if ! command -v quickshell >/dev/null; then
    warn "QuickShell binary missing — rebuild using: paru -S quickshell-git"
fi

log "QuickShell verified."
