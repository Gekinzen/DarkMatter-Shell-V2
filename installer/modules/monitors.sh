#!/bin/bash

log "Installing NWG-Displays (monitor GUI)"
if ! command -v nwg-displays >/dev/null 2>&1; then
    case "$DISTRO" in
        arch) sudo pacman -S --noconfirm nwg-look nwg-displays ;;
        fedora) sudo dnf install -y nwg-look nwg-displays ;;
        pikaos|ubuntu) sudo apt install -y nwg-look || true ;; # may require manual build
    esac
fi

log "Deploying monitor scripts"
mkdir -p ~/.config/hypr/scripts

rsync -a modules/scripts/monitors/ ~/.config/hypr/scripts/
chmod +x ~/.config/hypr/scripts/*.sh

log "Monitor scale fixer installed"
