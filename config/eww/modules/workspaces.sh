#!/bin/bash

# Function to get current workspace ID
get_ws() {
    niri msg -j workspaces | jq -r '.[] | select(.is_focused == true) | .id // "1"'
}

# Print initial workspace so Eww isn't empty on start
get_ws

# Listen to the event stream. 
# Whenever Niri sends a JSON object, we trigger a refresh.
niri msg event-stream | while read -r line; do
    get_ws
done | stdbuf -oL uniq
