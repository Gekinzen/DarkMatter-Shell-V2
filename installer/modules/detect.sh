#!/usr/bin/env bash
set -e

LOG="installer/logs/install.log"

echo "[INFO] Detecting system..." | tee -a "$LOG"

if [[ ! -f /etc/os-release ]]; then
    echo "[ERROR] /etc/os-release missing!" | tee -a "$LOG"
    exit 1
fi

source /etc/os-release
ID="${ID,,}"
LIKE="${ID_LIKE,,}"

if [[ "$ID" == "arch" || "$LIKE" == *"arch"* ]]; then
    echo "[INFO] Arch-based system detected: $PRETTY_NAME" | tee -a "$LOG"
else
    echo "[ERROR] Unsupported distro: $PRETTY_NAME" | tee -a "$LOG"
    exit 1
fi
