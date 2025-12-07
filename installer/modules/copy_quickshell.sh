#!/usr/bin/env bash
set -e

LOG="installer/logs/install.log"
log() { echo -e "\e[92m[OK]\e[0m $1" | tee -a "$LOG"; }

REPO_DIR="$(realpath "$(dirname "$0")/../..")"
SRC="$REPO_DIR/quickshell"
DEST="$HOME/.config/quickshell"

mkdir -p "$DEST"

cp -a "$SRC/"* "$DEST/" || true

log "QuickShell configuration installed → ~/.config/quickshell"
