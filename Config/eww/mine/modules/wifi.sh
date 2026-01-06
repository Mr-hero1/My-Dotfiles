#!/bin/bash

# Find interface
INTERFACE=$(ls /sys/class/net | grep -E '^wlp|^wlan' | head -n 1)

# Check if the interface is actually up (powered on)
STATE=$(cat "/sys/class/net/$INTERFACE/operstate" 2>/dev/null)

# Get Signal from /proc
STRENGTH=$(grep "$INTERFACE" /proc/net/wireless | awk '{print int($3)}')
# Ensure PERCENT isn't empty if disconnected
[[ -z "$STRENGTH" ]] && PERCENT=0 || PERCENT=$(( STRENGTH * 100 / 70 ))

# Cache SSID name
CACHE_FILE="/tmp/eww_wifi_name"
if [[ ! -f "$CACHE_FILE" || $(find "$CACHE_FILE" -mmin +1) ]]; then
    nmcli -t -f ACTIVE,SSID dev wifi | awk -F':' '$1=="yes" {print $2}' > "$CACHE_FILE"
fi
SSID=$(cat "$CACHE_FILE")

# Icon Logic
if [[ "$STATE" == "down" ]]; then
    icon="󰪎" 
    SSID="OFF"
elif [[ -z "$SSID" ]]; then
    icon="󰪎"
    SSID="ON"
else
    # Connected icons based on strength
    if [ "$PERCENT" -ge 80 ]; then icon="󰣺"; 
    elif [ "$PERCENT" -ge 60 ]; then icon="󰣸"; 
    elif [ "$PERCENT" -ge 40 ]; then icon="󰣶"; 
    else icon="󰣴"; fi
fi

echo "$icon $SSID ]"
