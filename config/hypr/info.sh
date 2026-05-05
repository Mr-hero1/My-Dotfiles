#!/usr/bin/env bash

# --- BATTERY LOGIC ---
PERCENT=$(cat "/sys/class/power_supply/BAT0/capacity" 2>/dev/null)
STATUS=$(cat "/sys/class/power_supply/BAT0/status" 2>/dev/null)

if [ -z "$PERCENT" ]; then
    bat_output="No Battery"
else
    if [ "$STATUS" = "Charging" ]; then
        bat_icon="󰂄"
    else
        if [ "$PERCENT" -ge 90 ]; then bat_icon="󰁹"
        elif [ "$PERCENT" -ge 80 ]; then bat_icon="󰂂"
        elif [ "$PERCENT" -ge 70 ]; then bat_icon="󰂁"
        elif [ "$PERCENT" -ge 60 ]; then bat_icon="󰂀"
        elif [ "$PERCENT" -ge 50 ]; then bat_icon="󰁾"
        elif [ "$PERCENT" -ge 40 ]; then bat_icon="󰁽"
        elif [ "$PERCENT" -ge 30 ]; then bat_icon="󰁼" 
        elif [ "$PERCENT" -ge 20 ]; then bat_icon="󰁻"
        elif [ "$PERCENT" -ge 10 ]; then bat_icon="󰁺"
        else bat_icon="󰂎"; fi
    fi
    bat_output="$bat_icon $PERCENT%"
fi

# --- KEYBOARD LAYOUT LOGIC ---
layout=$(niri msg keyboard-layouts | awk '/^\s*\*/ { 
    gsub(/[*0-9[:space:]]+/, ""); 
    print toupper(substr($0, 1, 2)) 
}')

if [ -z "$layout" ]; then
    layout="??"
fi

# --- FINAL COMBINED OUTPUT ---
# You can change the " • " to a pipe "|", a dash "-", or just spaces.
echo "$layout  •  $bat_output"
