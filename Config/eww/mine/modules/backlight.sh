#!/bin/bash
LAST_PERCENT=""

while true; do
    RAW=$(brightnessctl -m)

    IFS=',' read -r _ _ _ PERCENT_STR _ <<< "$RAW"
    PERCENT="${PERCENT_STR%\%}"

    if [ "$PERCENT" != "$LAST_PERCENT" ]; then
        
        # Icon Logic
        if [ "$PERCENT" -ge 90 ]; then icon="󰃠 [████████]"
        elif [ "$PERCENT" -ge 80 ]; then icon="󰃝 [███████░]"
        elif [ "$PERCENT" -ge 70 ]; then icon="󰃝 [██████░░]"
        elif [ "$PERCENT" -ge 60 ]; then icon="󰃟 [█████░░░]"
        elif [ "$PERCENT" -ge 50 ]; then icon="󰃞 [████░░░░]"
        elif [ "$PERCENT" -ge 30 ]; then icon="󰃜 [███░░░░░]"
        else icon="󰃛 [██░░░░░░]"; fi

        # Print the icon
        echo "$icon $PERCENT"

        # Update the tracker
        LAST_PERCENT="$PERCENT"
    fi

    sleep 0.5
done
