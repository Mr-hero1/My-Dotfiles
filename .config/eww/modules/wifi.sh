#!/bin/bash

get_wifi_json() {
    WIFI_DATA=$(nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi 2>/dev/null | grep "^yes:")

    if [ -n "$WIFI_DATA" ]; then
        DATA="${WIFI_DATA#yes:}"
        PERCENT="${DATA##*:}"
        SSID="${DATA%:*}"
        
        [ -z "$SSID" ] && SSID="Unknown Network"

        if [ "$PERCENT" -lt 25 ]; then
            icon="󰤯"  # Weak
        elif [ "$PERCENT" -lt 50 ]; then
            icon="󰤢"  # Medium
        elif [ "$PERCENT" -lt 75 ]; then
            icon="󰤥"  # Good
        else
            icon="󰖩"  # Strong
        fi
    else
        icon="󰖪"      # Disconnected / Off
        SSID="Disconnected"
    fi

    echo "{\"icon\": \"$icon\", \"ssid\": \"$SSID\"}"
}

last_out=$(get_wifi_json)
echo "$last_out"

while read -r _; do
    current_out=$(get_wifi_json)
    
    if [ "$current_out" != "$last_out" ]; then
        echo "$current_out"
        last_out="$current_out"
    fi
done < <(dbus-monitor --system "sender='org.freedesktop.NetworkManager'" 2>/dev/null | grep --line-buffered "member=")
