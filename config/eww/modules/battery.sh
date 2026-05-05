#!/bin/bash

last_percent=""

while true; do
    if [ -f "/sys/class/power_supply/BAT0/capacity" ]; then
        PERCENT=$(cat "/sys/class/power_supply/BAT0/capacity")

        # Only output if the number has changed
        if [ "$PERCENT" != "$last_percent" ]; then
            echo "$PERCENT"
            last_percent="$PERCENT"
        fi
    fi

    # Check every 5 seconds to save CPU
    sleep 5
done
