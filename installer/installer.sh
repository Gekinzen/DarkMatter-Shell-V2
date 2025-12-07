#!/usr/bin/env bash
set -e

MODULES_DIR="$(dirname "$0")/modules"
LOG_DIR="$(dirname "$0")/logs"
LOG_FILE="$LOG_DIR/install.log"

mkdir -p "$LOG_DIR"
echo "[Installer] Starting DarkMatter Shell installation..." > "$LOG_FILE"

log()  { echo -e "\e[92m[OK]\e[0m $1"    | tee -a "$LOG_FILE"; }
warn() { echo -e "\e[93m[WARN]\e[0m $1"  | tee -a "$LOG_FILE"; }
err()  { echo -e "\e[91m[ERROR]\e[0m $1" | tee -a "$LOG_FILE"; exit 1; }

run_module() {
    local module="$MODULES_DIR/$1"
    if [[ -f "$module" ]]; then
        log "Running module: $1"
        bash "$module" || err "Module $1 failed!"
    else
        err "Module $1 not found!"
    fi
}

# ORDER IS IMPORTANT
run_module detect.sh
run_module deps_pacman.sh
run_module deps_aur.sh
run_module copy_quickshell.sh
run_module copy_hypr.sh
run_module enable_services.sh
run_module verify_qs.sh
run_module finish.sh

log "DarkMatter Shell installation completed successfully 🎉"
