#!/usr/bin/env bash
set -e

log()  { echo -e "\e[92m[OK]\e[0m $1"; }
warn() { echo -e "\e[93m[WARN]\e[0m $1"; }

SRC="$HOME/DarkMatter-Shell-V2/quickshell"
DST="$HOME/.config/quickshell"

mkdir -p "$DST"

log "Syncing QuickShell configuration..."

# If rsync exists → use it (fastest & safest)
if command -v rsync >/dev/null 2>&1; then
    rsync -av --ignore-existing "$SRC/" "$DST/"
else
    warn "rsync not found — using fallback copy method."

    # Manual copy fallback, preserves existing files
    find "$SRC" -type f | while read f; do
        rel="${f#$SRC/}"
        dest="$DST/$rel"

        mkdir -p "$(dirname "$dest")"

        if [[ ! -f "$dest" ]]; then
            cp "$f" "$dest"
        fi
    done
fi

log "QuickShell config updated."
