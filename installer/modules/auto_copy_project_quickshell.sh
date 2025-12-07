#!/usr/bin/env bash
set -e

LOG_FILE="$(dirname "$0")/../logs/install.log"
mkdir -p "$(dirname "$LOG_FILE")"

log()  { echo -e "\e[92m[OK]\e[0m $1"  | tee -a "$LOG_FILE"; }
warn() { echo -e "\e[93m[WARN]\e[0m $1" | tee -a "$LOG_FILE"; }

# Detect repo root dynamically
REPO_DIR="$(realpath "$(dirname "$0")/../..")"
SRC_QUICKSHELL="$REPO_DIR/quickshell"
DEST_QUICKSHELL="$REPO_DIR/config/quickshell"

log "Repo directory detected: $REPO_DIR"

# If main quickshell folder exists, copy to config/
if [[ -d "$SRC_QUICKSHELL" ]]; then
    mkdir -p "$DEST_QUICKSHELL"
    cp -a "$SRC_QUICKSHELL/"* "$DEST_QUICKSHELL/" 2>/dev/null || true
    log "Copied project QuickShell → config/quickshell/"
else
    warn "No project quickshell/ found at $SRC_QUICKSHELL"
fi

log "Auto copy of project QuickShell completed."
