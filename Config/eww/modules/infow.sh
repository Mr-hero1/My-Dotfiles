#!/bin/bash

# Function to fetch the current title of the focused window
get_title() {
    # 'niri msg -j focused-window' returns JSON; we extract the title
    # If no window is focused, it defaults to "~"
    niri msg -j focused-window | jq -r '.title // "~"' 2>/dev/null || echo "~"
}

# Print the initial title on startup
get_title

# Listen to the Niri event stream
# We look for 'WindowFocusChanged' (focus moves) 
# or 'WindowTitleChanged' (app updates its own title)
niri msg -j event-stream | jq --unbuffered -c 'select(.WindowFocusChanged or .WindowTitleChanged)' | while read -r _; do
    get_title
done
