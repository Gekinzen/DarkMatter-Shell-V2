#!/usr/bin/env bash
set -e

log()  { echo -e "\e[92m[OK]\e[0m $1"; }
warn() { echo -e "\e[93m[WARN]\e[0m $1"; }
err()  { echo -e "\e[91m[ERROR]\e[0m $1"; exit 1; }

log "[AUR] Installing dependencies..."

AUR_PKGS=(
  anyrun hyprpicker-git matugen-git python-nvidia-ml-py quickshell-git
  google-breakpad ttf-google-fonts-typewolf
)

# Ensure paru exists
if ! command -v paru >/dev/null; then
    log "Paru missing → installing..."
    sudo pacman -S --noconfirm --needed base-devel git
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru
    makepkg -si --noconfirm || err "Failed to build paru"
fi

for pkg in "${AUR_PKGS[@]}"; do
    if paru -Qi "$pkg" &>/dev/null; then
        log "Skipping AUR: $pkg (already installed)"
        continue
    fi

    log "Installing AUR: $pkg"
    paru -S --needed --noconfirm "$pkg" || warn "Failed: $pkg (skipping)"
done

log "[AUR] Completed."
