#!/usr/bin/env bash

# Wallpaper path from the 2nd argument
WALLPAPER="$2"

# Path to Hyprland wallpaper config
CONF_FILE="/home/dr/.config/hypr/hyprpaper.conf"

# Write the wallpaper block to the config
cat > "$CONF_FILE" <<EOF
wallpaper {
    monitor = eDP-1
    path = $WALLPAPER
    fit_mode = cover
}
splash = false
EOF
