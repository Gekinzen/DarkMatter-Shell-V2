#!/bin/bash

# -------------------------------------------------------------
#  Zenith Shell - Monitor Scale Auto-Fixer
#  Fixes invalid Hyprland scale values, keeps transform intact
# -------------------------------------------------------------

MONITORS_CONF="$HOME/.config/hypr/monitors.conf"
BACKUP_CONF="$HOME/.config/hypr/monitors.conf.backup"

round_scale() {
    local input_scale=$1
    local rounded

    rounded=$(echo "$input_scale" | awk '{
        val = $1
        if (val <= 1.0) print "1.0"
        else if (val > 1.0 && val < 1.29) print "1.25"
        else if (val >= 1.29 && val < 1.42) print "1.333333"
        else if (val >= 1.42 && val < 1.58) print "1.5"
        else if (val >= 1.58 && val < 1.71) print "1.666667"
        else if (val >= 1.71 && val < 1.87) print "1.75"
        else if (val >= 1.87 && val < 2.12) print "2.0"
        else if (val >= 2.12 && val < 2.37) print "2.25"
        else if (val >= 2.37 && val < 2.62) print "2.5"
        else if (val >= 2.62 && val < 2.87) print "2.75"
        else print "3.0"
    }')

    echo "$rounded"
}

# ---------------------------------------------
#  Validate file
# ---------------------------------------------
if [ ! -f "$MONITORS_CONF" ]; then
    echo "monitors.conf not found — skipping scale patch"
    exit 0
fi

cp "$MONITORS_CONF" "$BACKUP_CONF"

FIXED=false
TEMP_FILE=$(mktemp)

while IFS= read -r line; do

    [[ $line =~ ^#.*$ || -z "$line" ]] && echo "$line" >> "$TEMP_FILE" && continue

    # skip transform-only lines
    if [[ $line =~ ^monitor=.*,transform, ]]; then
        echo "$line" >> "$TEMP_FILE"
        continue
    fi

    if [[ $line =~ ^monitor=([^,]+),([^,]+),([^,]+),([0-9]+\.?[0-9]*)(.*)?$ ]]; then
        NAME="${BASH_REMATCH[1]}"
        RES="${BASH_REMATCH[2]}"
        POS="${BASH_REMATCH[3]}"
        SCALE="${BASH_REMATCH[4]}"
        EXTRA="${BASH_REMATCH[5]}"

        if [[ "$SCALE" =~ ^(1\.0|1\.25|1\.333333|1\.5|1\.666667|1\.75|2\.0|2\.25|2\.5|2\.75|3\.0)$ ]]; then
            echo "$line" >> "$TEMP_FILE"
        else
            FIXED_SCALE=$(round_scale "$SCALE")
            echo "✓ $NAME: invalid scale $SCALE → $FIXED_SCALE"
            echo "monitor=$NAME,$RES,$POS,$FIXED_SCALE$EXTRA" >> "$TEMP_FILE"
            FIXED=true
        fi
    else
        echo "$line" >> "$TEMP_FILE"
    fi

done < "$MONITORS_CONF"

if [ "$FIXED" = true ]; then
    mv "$TEMP_FILE" "$MONITORS_CONF"
    notify-send "Zenith Monitor Fix" "Invalid monitor scales corrected automatically."
    sleep 0.3
    hyprctl reload
else
    rm "$TEMP_FILE"
fi
