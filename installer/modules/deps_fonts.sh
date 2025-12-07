#!/usr/bin/env bash
set -e

LOG_FILE="$(dirname "$0")/../logs/install.log"
log()  { echo -e "\e[92m[OK]\e[0m $1"  | tee -a "$LOG_FILE"; }
warn() { echo -e "\e[93m[WARN]\e[0m $1" | tee -a "$LOG_FILE"; }
err()  { echo -e "\e[91m[ERROR]\e[0m $1" | tee -a "$LOG_FILE"; exit 1; }

log "Installing required fonts..."

# Official repository fonts
PACMAN_FONTS=(
  ttf-inter
  ttf-fira-code
  noto-fonts
  noto-fonts-cjk
  noto-fonts-extra
)

sudo pacman -S --needed --noconfirm "${PACMAN_FONTS[@]}" || warn "Some official fonts failed to install."

# AUR Nerd Fonts
AUR_FONTS=(
  nerd-fonts-fira-code
  ttf-material-symbols # If exists
  ttf-google-sans      # Optional fallback
)

if command -v paru >/dev/null 2>&1; then
    paru -S --needed --noconfirm "${AUR_FONTS[@]}" || warn "Some AUR fonts failed."
elif command -v yay >/dev/null 2>&1; then
    yay -S --needed --noconfirm "${AUR_FONTS[@]}" || warn "Some AUR fonts failed."
else
    warn "No AUR helper found — skipping AUR fonts."
fi

# Verify FiraCode Nerd Font exists, else install manually
if ! fc-list | grep -qi "FiraCode Nerd Font"; then
    warn "FiraCode Nerd Font missing — installing manually..."

    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts

    wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip -O FiraCode.zip
    unzip -o FiraCode.zip >/dev/null 2>&1 || warn "Failed to unzip FiraCode"
    rm FiraCode.zip
fi

fc-cache -fv

log "Font installation stage complete."
