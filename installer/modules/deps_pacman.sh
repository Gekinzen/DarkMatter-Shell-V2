#!/usr/bin/env bash
set -e

LOG="installer/logs/install.log"
log() { echo -e "\e[92m[OK]\e[0m $1" | tee -a "$LOG"; }
err() { echo -e "\e[91m[ERROR]\e[0m $1" | tee -a "$LOG"; exit 1; }

PKGS=(
  brightnessctl
  cliphist
  easyeffects
  firefox
  fuzzel
  gedit
  gnome-disk-utility
  grim
  hyprland
  mission-center
  nautilus
  nwg-look
  pavucontrol
  polkit
  polkit-gnome
  mate-polkit
  ptyxis
  qt6ct
  slurp
  swappy
  tesseract
  wl-clipboard
  xdg-desktop-portal-hyprland
  yad
)

log "Installing official repo packages..."
sudo pacman -Syu --noconfirm || err "Pacman sync failed!"

sudo pacman -S --needed --noconfirm "${PKGS[@]}" || err "Repository pkg install failed!"

log "Official packages installed."
