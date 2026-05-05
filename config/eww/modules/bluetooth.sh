#!/bin/bash

# 1. Try to get the MAC of a connected device immediately
DEVICE_MAC=$(bluetoothctl devices Connected | awk '{print $2}' | head -n 1)

if [[ -n "$DEVICE_MAC" ]]; then
    # If a device is found, get its name
    DEVICE_NAME=$(bluetoothctl info "$DEVICE_MAC" | grep "Name:" | sed 's/^[ \t]*Name:[ \t]*//')
    
    if [[ -n "$DEVICE_NAME" ]]; then
        echo "$DEVICE_NAME"
    else
        echo "Connected"
    fi
else
    # 2. Fallback: If no device, check if the radio is at least "On"
    if bluetoothctl show | grep -q "Powered: yes"; then
        echo "On"
    else
        echo "Off"
    fi
fi
