#!/bin/bash

# --- WiFi ---
wifi_info=$(nmcli -t -f ACTIVE dev wifi | grep '^yes')
if [ -n "$wifi_info" ]; then
    wifi="󰖩"   # Connected WiFi icon (replace if you prefer another)
else
    wifi="󰖪"   # Disconnected WiFi icon
fi

# --- Bluetooth ---
bt_power=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
if [ "$bt_power" = "yes" ]; then
    bt_device=$(bluetoothctl info | grep "Name:" | head -n1)
    if [ -n "$bt_device" ]; then
        bt="󰂱"   # Bluetooth connected
    else
        bt="󰂯"   # Bluetooth on (no device)
    fi
else
    bt="󰂲"   # Bluetooth off
fi
# --- Battery ---
# Battery icons for normal (not charging) — reversed order: empty → full
battery_icons=( "󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" )

# Battery icons for charging — reversed: empty → full
charging_icons=( "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅" )

num_icons=${#battery_icons[@]}
num_charging=${#charging_icons[@]}

# Get battery percentage and status
if command -v acpi &>/dev/null; then
    percent=$(acpi -b | grep -o "[0-9]\+%" | head -n1 | tr -d '%')
    status=$(acpi -b | awk '{print $3}' | tr -d ',')
else
    percent=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1)
    status=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null)
fi

percent=${percent:-0}

# Map percentage to icon
if [[ "$status" == "Charging" ]]; then
    idx=$(( percent * (num_charging - 1) / 100 ))
    [[ $idx -ge $num_charging ]] && idx=$((num_charging - 1))
    battery=${charging_icons[$idx]}
else
    idx=$(( percent * (num_icons - 1) / 100 ))
    [[ $idx -ge $num_icons ]] && idx=$((num_icons - 1))
    battery=${battery_icons[$idx]}
fi

# --- Time ---
time=$(date "+%H:%M")

# --- Output ---
echo " $wifi  $bt  $battery |$time"

