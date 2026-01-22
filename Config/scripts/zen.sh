#!/bin/bash

# Configuration
CONFIG_PATH="$HOME/.config/eww/mine"
WIDGETS="bar clock workspace-widget"
ZEN_WALLPAPER="/home/Dr/Pictures/will/bkg3.png"

# Toggle logic: Check if eww is currently running
if pgrep -x "eww" > /dev/null; then
    # --- ZEN MODE ON ---
    # 1. Close Eww widgets
    eww -c "$CONFIG_PATH" close-all
    pkill eww

    # 2. Change to Zen Wallpaper
    hyprctl hyprpaper reload "eDP-1,$ZEN_WALLPAPER"
else
    # --- ZEN MODE OFF ---
    # 1. Restart hyprpaper to restore default wallpaper config
    pkill hyprpaper
    hyprpaper &

    # 2. Open Eww widgets
    eww -c "$CONFIG_PATH" open-many $WIDGETS &
fi

exit 0