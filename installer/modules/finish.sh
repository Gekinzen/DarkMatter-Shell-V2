#!/usr/bin/env bash
set -e

LOG_FILE="$(dirname "$0")/../logs/install.log"
log() { echo -e "\e[92m[OK]\e[0m $1" | tee -a "$LOG_FILE"; }

log "Installation finished 🎉"
log "You may reboot to start the full shell experience."
