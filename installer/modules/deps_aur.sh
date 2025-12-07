#!/usr/bin/env bash
set -e

LOG_FILE="$(dirname "$0")/../logs/install.log"
mkdir -p "$(dirname "$LOG_FILE")"

log()  { echo -e "\e[92m[OK]\e[0m $1"  | tee -a "$LOG_FILE"; }
warn() { echo -e "\e[93m[WARN]\e[0m $1" | tee -a "$LOG_FILE"; }
skip() { echo -e "\e[94m[SKIP]\e[0m $1" | tee -a "$LOG_FILE"; }

log "Installing AUR dependencies..."

# ---------------------------------------------------------------
# Helper: check if root actions are allowed
# ---------------------------------------------------------------
if [[ $EUID -eq 0 ]]; then
    warn "AUR installation cannot run as root. Skipping AUR stage."
    exit 0
fi

# ---------------------------------------------------------------
# Ensure paru exists (NO sudo here)
# ---------------------------------------------------------------
if ! command -v paru >/dev/null 2>&1; then
    warn "paru not installed. User must install it manually:"
    warn "   sudo pacman -S --needed base-devel git"
    warn "   git clone https://aur.archlinux.org/paru.git"
    warn "   cd paru && makepkg -si"
    warn "Skipping AUR package installation."
    exit 0
fi

# ---------------------------------------------------------------
# Smart package list (avoids conflicts)
# ---------------------------------------------------------------
AUR_PKGS=(
  quickshell-git
  anyrun
  dgop
  hyprpicker-git
  matugen-git
  python-pynvml
  ttf-inter
  ttf-material-symbols
  material-design-icons
  wlogout
)

# ---------------------------------------------------------------
# SMART INSTALL LOOP (no failing)
# ---------------------------------------------------------------
for pkg in "${AUR_PKGS[@]}"; do

    # If installed → skip
    if pacman -Q "$pkg" &>/dev/null; then
        skip "$pkg already installed"
        continue
    fi

    # If conflicting repo version exists → skip AUR version
    conflict_name=$(basename "$pkg" -git)
    if pacman -Q | grep -q "^${conflict_name}-"; then
        skip "Conflict detected: $pkg vs repo $conflict_name → keeping REPO version"
        continue
    fi

    # Install package but NEVER fail installer
    log "Installing AUR: $pkg"
    if ! paru -S --needed --noconfirm "$pkg"; then
        warn "Failed to install $pkg → skipping"
        continue
    fi

done

log "AUR stage completed successfully (smart mode)."
exit 0
