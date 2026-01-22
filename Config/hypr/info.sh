#!/bin/bash

# It is good practice to use double quotes around variables to handle spaces
time_elapsed=$(uptime -p | sed 's/up //')
battery_level=$(cat /sys/class/power_supply/BAT0/capacity)%
battery_status=$(cat /sys/class/power_supply/BAT0/status)
music_name=$(playerctl metadata --format "{{ title }}" 2>/dev/null)
if [ -z "$music_name" ]; then
    music_name="Nothing"
fi
volume=$(pamixer --get-volume-human)
cpu_temp=$(sensors | grep "Package id 0" | awk '{print $4}')
ram_usage=$(free | grep Mem | awk '{printf "%.0f%%", $3/$2 * 100.0}')

echo "󱎫 $time_elapsed | 󰁹 $battery_level ($battery_status) |  $cpu_temp | 󰍛 $ram_usage |  $music_name | 󰕾 ($volume)"