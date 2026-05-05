#!/bin/bash
LAST_PERCENT=""

while true; do
    # Get raw data from brightnessctl
    RAW=$(brightnessctl -m)

    # Parse the comma-separated string to get the percentage
    IFS=',' read -r _ _ _ PERCENT_STR _ <<< "$RAW"
    PERCENT="${PERCENT_STR%\%}"

    # Only output if the value has changed
    if [ "$PERCENT" != "$LAST_PERCENT" ]; then
        echo "$PERCENT"
        LAST_PERCENT="$PERCENT"
    fi

    # Check every 0.2 seconds
    sleep 0.2
done
