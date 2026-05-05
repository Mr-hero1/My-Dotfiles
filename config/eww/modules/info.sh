#!/bin/bash

last_out=""

while true; do
    # --- BATTERY LOGIC ---
    PERCENT=$(cat "/sys/class/power_supply/BAT0/capacity" 2>/dev/null)
    STATUS=$(cat "/sys/class/power_supply/BAT0/status" 2>/dev/null)

    if [ "$STATUS" = "Charging" ]; then
        bat_icon="󰂄"
    else
        if [ "$PERCENT" -ge 90 ]; then bat_icon="󰁹"
        elif [ "$PERCENT" -ge 80 ]; then bat_icon="󰂂"
        elif [ "$PERCENT" -ge 70 ]; then bat_icon="󰂁"
        elif [ "$PERCENT" -ge 60 ]; then bat_icon="󰂀"
        elif [ "$PERCENT" -ge 50 ]; then bat_icon="󰁾"
        elif [ "$PERCENT" -ge 40 ]; then bat_icon="󰁽"
        elif [ "$PERCENT" -ge 20 ]; then bat_icon="󰁼"
        elif [ "$PERCENT" -ge 10 ]; then bat_icon="󰁺"
        else bat_icon="󰁺"; fi
    fi

    # --- VOLUME LOGIC (Show only if muted) ---
    if [ "$(pamixer --get-mute)" = "true" ]; then
        vol_out="󰖁 "
    else
        vol_out=""
    fi

    # --- MIC LOGIC (Show icon only if muted) ---
    if [ "$(pamixer --source 0 --get-mute)" = "true" ]; then
        mic_out="󰍭 "
    else
        mic_out=""
    fi

    # --- BLUETOOTH LOGIC (Direct Kernel Check) ---
    if ls /sys/class/bluetooth/ 2>/dev/null | grep -q ":"; then
        bt_out="󰂱 "
    else
        bt_out=""
    fi

    # --- WI-FI ---
    WIFI_INT=$(ls /sys/class/net | grep '^w' | head -n 1)
    
    if [ -n "$WIFI_INT" ] && [ "$(cat /sys/class/net/$WIFI_INT/operstate 2>/dev/null)" = "up" ]; then
        wifi_out="󰖩 "
    else
        wifi_out=""
    fi

    # --- FINAL OUTPUT ---
    current_out="${wifi_out}${bt_out}${mic_out}${vol_out}${bat_icon}"

    if [ "$current_out" != "$last_out" ]; then
        echo "$current_out"
        last_out="$current_out"
    fi

    sleep 0.5
done
