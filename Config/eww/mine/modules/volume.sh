#!/bin/bash

get_output() {
    # Function to get raw number
    get_volume() { pamixer --get-volume; }
    is_muted() { pamixer --get-mute; }

    if [ "$(is_muted)" = "true" ]; then
        echo " [MUTE] $(get_volume)"
    else
        VOL=$(get_volume)
        if [ "$VOL" -ge 90 ]; then icon=" [████████]"
        elif [ "$VOL" -ge 80 ]; then icon=" [███████░]"
        elif [ "$VOL" -ge 70 ]; then icon=" [██████░░]"
        elif [ "$VOL" -ge 60 ]; then icon=" [█████░░░]"
        elif [ "$VOL" -ge 50 ]; then icon=" [████░░░░]"
        elif [ "$VOL" -ge 30 ]; then icon=" [███░░░░░]"
        elif [ "$VOL" -ge 10 ]; then icon=" [█░░░░░░░]"
        else icon=" [░░░░░░░░]"; fi
        
        echo "$icon $VOL"
    fi
}

# 1. Run once on startup
get_output

# 2. Listen for changes using pactl
pactl subscribe | while read -r event; do
    if echo "$event" | grep -q "sink"; then
        get_output
    fi
done
