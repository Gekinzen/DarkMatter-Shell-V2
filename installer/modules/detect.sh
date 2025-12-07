#!/usr/bin/env bash
set -e

log()  { echo -e "\e[92m[OK]\e[0m $1"; }
warn() { echo -e "\e[93m[WARN]\e[0m $1"; }
err()  { echo -e "\e[91m[ERROR]\e[0m $1"; exit 1; }

log "[INFO] Running detect.sh..."

if [[ -f /etc/arch-release ]]; then
    log "Arch Linux detected."
else
    err "This installer only supports Arch Linux."
fi
