#!/usr/bin/env bash
set -e

log()  { echo -e "\e[92m[OK]\e[0m $1"; }
warn() { echo -e "\e[93m[WARN]\e[0m $1"; }

FONTS=(
  "Inter"
  "FiraCode"
  "JetBrainsMono"
  "Material Symbols"
)

log "Ensuring required fonts are installed..."

sudo fc-cache -fv >/dev/null 2>&1 || true

log "Fonts OK."
