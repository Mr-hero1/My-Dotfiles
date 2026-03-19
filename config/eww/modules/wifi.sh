#!/bin/bash

# Define the interface once at the top

get_icon() {
    STATE=$(cat "/sys/class/net/$INTERFACE/operstate" 2>/dev/null)
    RADIO=$(nmcli radio wifi)
    INTERFACE=$(ls /sys/class/net | grep -E '^wlp|^wlan' | head -n 1)
    PERCENT=$(nmcli -t -f IN-USE,SIGNAL device wifi | grep '^\*' | cut -d':' -f2)
        
if [[ "$RADIO" == "disabled" ]]; then
        icon="󰪎  OFF" 
elif [[ -z "$PERCENT" || "$PERCENT" -eq 0 ]]; then
        icon="󰪎  ON"
    else
        if [ "$PERCENT" -ge 80 ]; then icon="󰤨  WIFI" 
        elif [ "$PERCENT" -ge 60 ]; then icon="󰤢  WIFI" 
        elif [ "$PERCENT" -ge 40 ]; then icon="󰤟  WIFI" 
        else icon="󰤯  WIFI"; fi
    fi
    echo "$icon"
}

get_icon

(while true; do
    sleep 10
    get_icon
done) &

ip monitor link address | while read -r line; do
    get_icon
done
