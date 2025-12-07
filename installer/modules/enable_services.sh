#!/usr/bin/env bash
set -e

LOG="installer/logs/install.log"
log() { echo -e "\e[92m[OK]\e[0m $1" | tee -a "$LOG"; }

mkdir -p ~/.config/systemd/user

cat <<EOF > ~/.config/systemd/user/quickshell.service
[Unit]
Description=QuickShell Desktop Shell
After=graphical-session.target

[Service]
ExecStart=/usr/bin/qs
Restart=always

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now quickshell.service || true

log "QuickShell systemd service enabled."
