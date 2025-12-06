#!/usr/bin/env bash
set -e

LOG_FILE="$(dirname "$0")/../logs/install.log"
AUR="$(cat /tmp/aurhelper)"

log() { echo -e "\e[92m[OK]\e[0m $1" | tee -a "$LOG_FILE"; }
err() { echo -e "\e[91m[ERROR]\e[0m $1" | tee -a "$LOG_FILE"; exit 1; }

AUR_PKGS=(
  xdg-desktop-portal-hyprland
)

log "Installing AUR dependencies..."
$AUR -S --needed --noconfirm "${AUR_PKGS[@]}" || err "AUR installation failed."
