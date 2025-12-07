#!/usr/bin/env bash
set -e

log()  { echo -e "\e[92m[OK]\e[0m $1"; }

SRC="$HOME/DarkMatter-Shell-V2/hypr"
DST="$HOME/.config/hypr"

mkdir -p "$DST"

rsync -av --ignore-existing "$SRC/" "$DST/"

log "Hypr config updated."
