#!/usr/bin/env bash
set -e

LOG_FILE="$(dirname "$0")/../logs/install.log"
mkdir -p "$(dirname "$LOG_FILE")"

log()  { echo -e "\e[92m[OK]\e[0m $1"  | tee -a "$LOG_FILE"; }
warn() { echo -e "\e[93m[WARN]\e[0m $1" | tee -a "$LOG_FILE"; }

# Detect REAL repo root
REPO_DIR="$(realpath "$(dirname "$0")/../..")"

SOURCE="$REPO_DIR/config"
TARGET="$HOME/.config"

log "Copying configuration files from $SOURCE → $TARGET"

DIRS=(quickshell hypr mako swww)

for d in "${DIRS[@]}"; do
    if [[ ! -d "$SOURCE/$d" ]]; then
        warn "Missing config folder: $SOURCE/$d"
        continue
    fi

    mkdir -p "$TARGET/$d"
    cp -a "$SOURCE/$d/"* "$TARGET/$d/" 2>/dev/null || true
    log "Installed config: $d → ~/.config/$d"
done

log "Config copy stage complete."
