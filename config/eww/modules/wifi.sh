#!/bin/bash

get_status() {
    # Get the Wi-Fi radio state (enabled/disabled)
    RADIO=$(nmcli radio wifi)
    
    if [[ "$RADIO" == "disabled" ]]; then
        echo "OFF"
    else
        # Get the name of the active connection
        # --terse format: 'NAME:DEVICE' -> filter for wifi -> take the first name
        SSID=$(nmcli -t -f NAME,TYPE connection show --active | grep ":802-11-wireless" | cut -d':' -f1)

        if [[ -z "$SSID" ]]; then
            echo "ON"
        else
            echo "$SSID"
        fi
    fi
}

# 1. Run once on startup
get_status

# 2. Polling loop in background (updates every 10s)
(while true; do
    sleep 10
    get_status
done) &

# 3. Event listener (updates immediately on network changes)
ip monitor link address | while read -r line; do
    get_status
done
