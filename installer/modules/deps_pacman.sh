#!/usr/bin/env bash
set -e

LOG_FILE="$(dirname "$0")/../logs/install.log"
log() { echo -e "\e[92m[OK]\e[0m $1" | tee -a "$LOG_FILE"; }
err() { echo -e "\e[91m[ERROR]\e[0m $1" | tee -a "$LOG_FILE"; exit 1; }

PKGS=(
  hyprland
  quickshell
  fuzzel
  pipewire pipewire-pulse wireplumber
  networkmanager
  polkit-gnome
  swww
  mako
  qt6-base qt6-declarative qt6-svg qt6-quickcontrols2
  gtk3 gtk4
  papirus-icon-theme
  hypridle hyprlock
)

log "Installing pacman dependencies..."
sudo pacman -S --needed --noconfirm "${PKGS[@]}" || err "Failed to install pacman packages."
