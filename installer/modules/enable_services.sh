#!/usr/bin/env bash
set -e

LOG_FILE="$(dirname "$0")/../logs/install.log"
log() { echo -e "\e[92m[OK]\e[0m $1" | tee -a "$LOG_FILE"; }

# QuickShell systemd service
cat << EOF > ~/.config/systemd/user/quickshell.service
[Unit]
Description=QuickShell Desktop Shell
After=graphical-session.target

[Service]
ExecStart=/usr/bin/quickshell --config ~/.config/quickshell/config.json
Restart=on-failure

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now quickshell.service

log "Enabled QuickShell service."
