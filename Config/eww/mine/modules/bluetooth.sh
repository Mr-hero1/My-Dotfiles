#!/bin/bash

# 1. Quick check for Power - Reading from /sys is faster than bluetoothctl
# Replace 'hci0' if your adapter has a different name
if [[ $(cat /sys/class/bluetooth/hci0/rfkill*/state 2>/dev/null) -eq 0 ]]; then
    echo "󰂲 Off"
    exit 0
fi

# 2. Get connected devices using a single command
# Using 'info' directly on all connected devices saves multiple loops
device_info=$(bluetoothctl devices Connected | head -n 1)

if [[ -z "$device_info" ]]; then
    echo "[ 󰂲 -"
else
    mac=$(echo "$device_info" | awk '{print $2}')
    name=$(echo "$device_info" | cut -d ' ' -f 3-)

    # 3. Efficiency Trick: Check /sys for battery first (Instant/No D-Bus)
    # The path usually looks like /sys/class/power_supply/bash_dev_XX_XX...
    sys_path="/sys/class/power_supply/bluetooth_$(echo $mac | tr ':' '_')"
    
    if [[ -d "$sys_path" ]]; then
        battery=$(cat "$sys_path/capacity" 2>/dev/null)
    else
        # Fallback to bluetoothctl only if /sys doesn't have it
        battery=$(bluetoothctl info "$mac" | awk -F '[()]' '/Battery Percentage/ {print $2}')
    fi

    if [[ -n "$battery" ]]; then
        echo "[ 󰂱 $battery% $name -"
    else
        echo "[ 󰂱 $name -"
    fi
fi