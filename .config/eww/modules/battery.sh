#!/bin/bash

update_battery() {
    if read -r STATUS < "/sys/class/power_supply/BAT0/status" 2>/dev/null && \
       read -r PERCENT < "/sys/class/power_supply/BAT0/capacity" 2>/dev/null; then
       
        if [ "$STATUS" = "Charging" ]; then
            icon="󰂄"
        elif [ "$PERCENT" -ge 90 ]; then icon="󰁹"
        elif [ "$PERCENT" -ge 80 ]; then icon="󰂂"
        elif [ "$PERCENT" -ge 70 ]; then icon="󰂁"
        elif [ "$PERCENT" -ge 60 ]; then icon="󰂀"
        elif [ "$PERCENT" -ge 50 ]; then icon="󰁾"
        elif [ "$PERCENT" -ge 40 ]; then icon="󰁽"
        elif [ "$PERCENT" -ge 20 ]; then icon="󰁼"
        else icon="󰁺"
        fi
    else
        icon="󰁺"
        PERCENT="0"
    fi

    echo "{\"icon\": \"$icon\", \"percent\": \"$PERCENT\"}"
}

update_battery

dbus-monitor --system "sender='org.freedesktop.UPower',member='PropertiesChanged'" 2>/dev/null | \
grep --line-buffered "path=/org/freedesktop/UPower/devices/battery_" | \
while read -r _; do
    update_battery
done
