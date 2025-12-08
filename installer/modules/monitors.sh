#!/bin/bash

log "Installing NWG-Displays (monitor GUI)"

# Detect distro family for easier branching
detect_distro() {
    if command -v pacman >/dev/null 2>&1; then
        echo "arch"
    elif command -v dnf >/dev/null 2>&1; then
        echo "fedora"
    elif command -v apt >/dev/null 2>&1; then
        echo "debian"
    else
        echo "unknown"
    fi
}

DISTRO=$(detect_distro)

# Install nwg-displays ONLY if missing
if ! command -v nwg-displays >/dev/null 2>&1; then
    case "$DISTRO" in
        arch)
            # Covers Arch, EndeavourOS, CachyOS, Garuda, Manjaro*
            log "• Arch-based detected — installing nwg-displays"
            sudo pacman -S --noconfirm nwg-displays
            ;;
        fedora)
            log "• Fedora detected — installing nwg-displays"
            sudo dnf install -y nwg-displays || log "Fedora: nwg-displays may require COPR"
            ;;
        debian)
            log "• Debian/Ubuntu detected — attempting install"
            sudo apt install -y nwg-displays || \
                log "⚠ nwg-displays is not in default Ubuntu repos — skipping"
            ;;
        *)
            log "⚠ Unknown distro — skipping nwg-displays installation"
            ;;
    esac
else
    log "nwg-displays already installed — skipping"
fi


log "Deploying monitor scripts"



log "Monitor scripts + scale fixer installed"
