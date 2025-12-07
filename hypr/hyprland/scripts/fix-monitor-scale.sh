#!/bin/bash

# Monitor Scale + Reserved Zones Fixer for Hyprland
# - Rounds invalid scales to valid Hyprland values
# - Ensures safe reserved zones (top + bottom) for bars/docks
# - Keeps bitdepth/other params intact

MONITORS_CONF="$HOME/.config/hypr/monitors.conf"
BACKUP_CONF="$HOME/.config/hypr/monitors.conf.backup"

# ----- CONFIGURABLE SAFE ZONES -----
SAFE_TOP=40      # space for QuickShell top bar
SAFE_BOTTOM=80   # space for QuickShell dock / OSD
SAFE_LEFT=0
SAFE_RIGHT=0

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

if [ ! -f "$MONITORS_CONF" ]; then
    echo "monitors.conf not found, skipping."
    exit 0
fi

cp "$MONITORS_CONF" "$BACKUP_CONF"

FIXED=false
TEMP_FILE=$(mktemp)

while IFS= read -r line; do
    # comments / blank
    if [[ $line =~ ^#.*$ ]] || [[ -z "$line" ]]; then
        echo "$line" >> "$TEMP_FILE"
        continue
    fi

    # pure transform lines
    if [[ $line =~ ^monitor=.*,transform, ]]; then
        echo "$line" >> "$TEMP_FILE"
        continue
    fi

    # monitor=NAME,RES,POS,SCALE[,extra...]
    if [[ $line =~ ^monitor=([^,]+),([^,]+),([^,]+),([0-9]+\.?[0-9]*)(.*)?$ ]]; then
        MONITOR_NAME="${BASH_REMATCH[1]}"
        RESOLUTION="${BASH_REMATCH[2]}"
        POSITION="${BASH_REMATCH[3]}"
        CURRENT_SCALE="${BASH_REMATCH[4]}"
        EXTRA_PARAMS="${BASH_REMATCH[5]}"

        NEW_SCALE="$CURRENT_SCALE"

        if ! [[ "$CURRENT_SCALE" =~ ^(1\.0|1\.25|1\.333333|1\.5|1\.666667|1\.75|2\.0|2\.25|2\.5|2\.75|3\.0)$ ]]; then
            NEW_SCALE=$(round_scale "$CURRENT_SCALE")
            echo "✓ Fixed $MONITOR_NAME: scale $CURRENT_SCALE → $NEW_SCALE"
            FIXED=true
        fi

        # Ensure reserved exists and is sane
        RESERVED_APPEND=",reserved,$SAFE_LEFT,$SAFE_TOP,$SAFE_BOTTOM,$SAFE_RIGHT"

        if [[ "$EXTRA_PARAMS" == *"reserved"* ]]; then
            # Normalize existing reserved block
            # replace any reserved,* with our safe block
            EXTRA_PARAMS=$(echo "$EXTRA_PARAMS" | sed -E "s/,reserved,[0-9]+,[0-9]+,[0-9]+,[0-9]+/$RESERVED_APPEND/")
        else
            EXTRA_PARAMS="$EXTRA_PARAMS$RESERVED_APPEND"
        fi

        FIXED_LINE="monitor=$MONITOR_NAME,$RESOLUTION,$POSITION,$NEW_SCALE$EXTRA_PARAMS"
        echo "$FIXED_LINE" >> "$TEMP_FILE"
        FIXED=true
    else
        echo "$line" >> "$TEMP_FILE"
    fi
done < "$MONITORS_CONF"

mv "$TEMP_FILE" "$MONITORS_CONF"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ monitors.conf updated with safe scales + reserved zones"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
cat "$MONITORS_CONF"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

notify-send "Hyprland Monitors Updated" \
    "Scales + reserved areas normalized for bars & dock" \
    -i video-display

sleep 0.5
hyprctl reload
