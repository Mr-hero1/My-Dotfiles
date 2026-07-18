#!/bin/bash

get_status_json() {
    local DEVICE_MAC=""
    local DEVICE_NAME=""
    local icon="󰂲"
    local name="Off"

    for mac in $(bluetoothctl devices | awk '{print $2}'); do
        if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
            DEVICE_MAC="$mac"
            break
        fi
    done

    if [[ -n "$DEVICE_MAC" ]]; then
        icon="󰂱" # Connected icon
        DEVICE_NAME=$(bluetoothctl info "$DEVICE_MAC" | grep "Alias:" | sed 's/^[ \t]*Alias:[ \t]*//')
        
        if [[ -z "$DEVICE_NAME" ]]; then
             DEVICE_NAME=$(bluetoothctl info "$DEVICE_MAC" | grep "Name:" | sed 's/^[ \t]*Name:[ \t]*//')
        fi
        
        if [[ -n "$DEVICE_NAME" ]]; then
            name="$DEVICE_NAME"
        else
            name="Connected"
        fi
    else
        if bluetoothctl show | grep -q "Powered: yes"; then
            icon="󰂯" # Disconnected / Searching icon
            name="Powered"
        else
            icon="󰂲" # Turned off icon
            name="Off"
        fi
    fi
    
    echo "{\"icon\": \"$icon\", \"name\": \"$name\"}"
}

last_out=$(get_status_json)
echo "$last_out"

while read -r _; do
    sleep 0.2
    
    current_out=$(get_status_json)
    
    if [[ "$current_out" != "$last_out" ]]; then
        echo "$current_out"
        last_out="$current_out"
    fi
done < <(dbus-monitor --system "type='signal',sender='org.bluez',interface='org.freedesktop.DBus.Properties'" 2>/dev/null | grep --line-buffered "member=PropertiesChanged")
