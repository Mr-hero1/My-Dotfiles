#!/bin/bash

# Initialize a variable to store the previous state
LAST_PERCENT=""

while true; do
    # 1. Get current brightness raw data
    RAW=$(brightnessctl -m)

    # 2. Extract percentage using Pure Bash (super light)
    # This removes everything before the 4th field and trims the %
    IFS=',' read -r _ _ _ PERCENT_STR _ <<< "$RAW"
    PERCENT="${PERCENT_STR%\%}"

    # 3. Only run the logic if the percentage has changed
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
        echo "$icon"

        # Update the tracker
        LAST_PERCENT="$PERCENT"
    fi

    # 4. Wait a tiny bit (0.1s is very responsive but still super light)
    sleep 0.1
done