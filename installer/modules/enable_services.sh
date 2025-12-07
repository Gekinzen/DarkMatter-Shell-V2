#!/usr/bin/env bash
set -e

log() { echo -e "\e[92m[OK]\e[0m $1"; }
warn() { echo -e "\e[93m[WARN]\e[0m $1"; }
err() { echo -e "\e[91m[ERROR]\e[0m $1"; exit 1; }

SERVICE_DIR="$HOME/.config/systemd/user"
SERVICE_FILE="$SERVICE_DIR/quickshell.service"
QS_PATH="$HOME/.config/quickshell"

mkdir -p "$SERVICE_DIR"

log "Enabling QuickShell systemd service..."

# If project contains a custom service file → use it
if [[ -f "$HOME/DarkMatter-Shell-V2/quickshell/systemd/quickshell.service" ]]; then
    cp "$HOME/DarkMatter-Shell-V2/quickshell/systemd/quickshell.service" "$SERVICE_FILE"
    log "Imported QuickShell service from repo"
else
    warn "No systemd file found in repo — generating default QuickShell service..."

    cat <<EOF > "$SERVICE_FILE"
[Unit]
Description=QuickShell (DarkMatter)
After=graphical-session.target

[Service]
ExecStart=/usr/bin/quickshell --path $QS_PATH
Restart=on-failure

[Install]
WantedBy=default.target
EOF
fi

systemctl --user daemon-reload || warn "User session not active (normal if running installer from TTY)"
systemctl --user enable --now quickshell.service || \
    warn "Service could not start now — will work after next login"

log "QuickShell service installed."
