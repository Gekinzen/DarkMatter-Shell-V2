#!/usr/bin/env bash
set -e

# Load shared log path
LOG_FILE="$(dirname "$0")/../logs/install.log"

log()   { echo -e "\e[92m[OK]\e[0m $1"    | tee -a "$LOG_FILE"; }
err()   { echo -e "\e[91m[ERROR]\e[0m $1" | tee -a "$LOG_FILE"; exit 1; }
warn()  { echo -e "\e[93m[WARN]\e[0m $1"  | tee -a "$LOG_FILE"; }

# Detect Arch-based system
if ! grep -qi "arch\|manjaro\|endeavour\|cachyos" /etc/os-release; then
    err "Unsupported OS. Installer works only on Arch-based distributions."
else
    log "Arch-based OS detected."
fi

# Detect AUR helper
if command -v paru >/dev/null; then
    echo "paru" > /tmp/aurhelper
    log "Using AUR helper: paru"
elif command -v yay >/dev/null; then
    echo "yay" > /tmp/aurhelper
    log "Using AUR helper: yay"
else
    warn "No AUR helper found. Installing paru..."

    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru
    makepkg -si --noconfirm
    
    echo "paru" > /tmp/aurhelper
    log "Paru installed successfully."
fi
