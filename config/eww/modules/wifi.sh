#!/bin/bash

# Find interface
INTERFACE=$(ls /sys/class/net | grep -E '^wlp|^wlan' | head -n 1)

# Check if the interface is actually up (powered on)
STATE=$(cat "/sys/class/net/$INTERFACE/operstate" 2>/dev/null)

# Get Signal from /proc
STRENGTH=$(grep "$INTERFACE" /proc/net/wireless | awk '{print int($3)}')

# Ensure PERCENT isn't empty if disconnected
[[ -z "$STRENGTH" ]] && PERCENT=0 || PERCENT=$(( STRENGTH * 100 / 70 ))

# Icon Logic
if [[ "$STATE" == "down" ]]; then
    icon="󰪎  OFF" 
elif [[ "$PERCENT" -eq 0 ]]; then
    icon="󰪎  ON"
else
    # Connected icons based on strength
    if [ "$PERCENT" -ge 80 ]; then icon="󰤨  WIFI"; 
    elif [ "$PERCENT" -ge 60 ]; then icon="󰤢  WIFI"; 
    elif [ "$PERCENT" -ge 40 ]; then icon="󰤟  WIFI"; 
    else icon="󰤯  WIFI"; fi
fi

echo "$icon"
