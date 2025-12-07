#!/usr/bin/env bash
set -e

LOG="installer/logs/install.log"
log() { echo -e "\e[92m[OK]\e[0m $1" | tee -a "$LOG"; }

REPO_DIR="$(realpath "$(dirname "$0")/../..")"
SRC="$REPO_DIR/hypr"
DEST="$HOME/.config/hypr"

mkdir -p "$DEST"
cp -a "$SRC/"* "$DEST/" || true

log "Hyprland configuration installed → ~/.config/hypr"
