#!/bin/bash

# Function to fetch the current title
get_title() {
    hyprctl activewindow -j | jq --unbuffered -r '.title // "~"'
}

# Print the initial title on startup
get_title

# Listen for focus changes or title updates
# 'activewindow>>' triggers when focus changes
# 'windowtitle>>' triggers when the title of the current window changes (e.g., web page load)
handle() {
    case $1 in
        activewindow*|windowtitle*) get_title ;;
    esac
}

# Pipe the Hyprland event socket into the handle function
socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
    handle "$line"
done
