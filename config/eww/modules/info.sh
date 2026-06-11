#!/bin/bash

last_out=""

# Find Wi-Fi interface ONCE outside the loop. 
# It rarely changes, so checking it every 0.8s wastes CPU.
WIFI_INT=""
for dir in /sys/class/net/w*; do
    if [ -d "$dir" ]; then
        WIFI_INT=${dir##*/}
        break
    fi
done

while true; do
    # --- BATTERY LOGIC ---
    # Using bash's built-in 'read' is much faster than launching 'cat'
    if read -r STATUS < "/sys/class/power_supply/BAT0/status" 2>/dev/null && \
       read -r PERCENT < "/sys/class/power_supply/BAT0/capacity" 2>/dev/null; then
       
        if [ "$STATUS" = "Charging" ]; then
            bat_icon="󰂄"
        elif [ "$PERCENT" -ge 90 ]; then bat_icon="󰁹"
        elif [ "$PERCENT" -ge 80 ]; then bat_icon="󰂂"
        elif [ "$PERCENT" -ge 70 ]; then bat_icon="󰂁"
        elif [ "$PERCENT" -ge 60 ]; then bat_icon="󰂀"
        elif [ "$PERCENT" -ge 50 ]; then bat_icon="󰁾"
        elif [ "$PERCENT" -ge 40 ]; then bat_icon="󰁽"
        elif [ "$PERCENT" -ge 20 ]; then bat_icon="󰁼"
        else bat_icon="󰁺"
        fi
    else
        bat_icon="󰁺"
    fi

    # --- VOLUME & MIC LOGIC ---
    # pamixer is an external binary, so we keep this concise
    vol_out=""
    mic_out=""
    [ "$(pamixer --get-mute 2>/dev/null)" = "true" ] && vol_out="󰖁 "
    [ "$(pamixer --source 0 --get-mute 2>/dev/null)" = "true" ] && mic_out="󰍭 "

    # --- BLUETOOTH LOGIC ---
    # Pure bash globbing. No 'ls' or 'grep' needed!
    bt_out=""
    for bt in /sys/class/bluetooth/*:*/; do
        if [ -d "$bt" ]; then
            bt_out="󰂱 "
            break
        fi
    done

    # --- WI-FI ---
    wifi_out=""
    if [ -n "$WIFI_INT" ]; read -r WIFI_STATE < "/sys/class/net/$WIFI_INT/operstate" 2>/dev/null; then
        [ "$WIFI_STATE" = "up" ] && wifi_out="󰖩 "
    fi

    # --- FINAL OUTPUT ---
    current_out="${wifi_out}${bt_out}${mic_out}${vol_out}${bat_icon}"

    if [ "$current_out" != "$last_out" ]; then
        echo "$current_out"
        last_out="$current_out"
    fi

    sleep 0.9
done
