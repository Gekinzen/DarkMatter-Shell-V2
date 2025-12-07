#!/usr/bin/env bash
set -e

log()  { echo -e "\e[92m[OK]\e[0m $1"; }
warn() { echo -e "\e[93m[WARN]\e[0m $1"; }
err()  { echo -e "\e[91m[ERROR]\e[0m $1"; exit 1; }

log "Installing official repo dependencies..."

PKGS=(
  brightnessctl cliphist easyeffects firefox fuzzel gedit
  gnome-disk-utility grim hyprland mission-center nautilus nwg-look
  pavucontrol polkit polkit-gnome mate-polkit ptyxis qt6ct slurp
  swappy tesseract wl-clipboard wlogout xdg-desktop-portal-hyprland
  yad noto-fonts noto-fonts-cjk noto-fonts-emoji inter-font
  ttf-jetbrains-mono ttf-fira-code otf-material-design-icons
  rsync
)


sudo pacman -Syu --noconfirm || warn "Pacman update warning — continuing."

for pkg in "${PKGS[@]}"; do
    if pacman -Qi "$pkg" &>/dev/null; then
        log "Skipping: $pkg (already installed)"
    else
        log "Installing: $pkg"
        sudo pacman -S --noconfirm --needed "$pkg" || warn "Failed: $pkg"
    fi
done

log "PACMAN deps completed."
