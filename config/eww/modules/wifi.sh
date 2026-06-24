#!/bin/bash

get_status() {
    RADIO=$(nmcli radio wifi)
    
    if [[ "$RADIO" == "disabled" ]]; then
        echo "OFF"
    else
        SSID=$(nmcli -t -f NAME,TYPE connection show --active | grep ":802-11-wireless" | cut -d':' -f1)

        if [[ -z "$SSID" ]]; then
            echo "ON"
        else
            echo "$SSID"
        fi
    fi
}

get_status

(while true; do
    sleep 10
    get_status
done) &

ip monitor link address | while read -r line; do
    get_status
done
