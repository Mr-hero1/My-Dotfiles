#!/bin/bash

# Function to fetch window state
get_windows() {
    niri msg -j windows | jq -c '[.[] | {id: .id, app_id: .app_id, focused: .is_focused}]'
}

# Initial print
last_output=$(get_windows)
echo "$last_output"

# Listen to the event stream
niri msg -j event-stream | while read -r event; do
    # Only refresh on specific events to save resources
    # We check for WindowOpened, WindowClosed, and WindowFocusChanged
    if echo "$event" | grep -qE "WindowOpened|WindowClosed|WindowFocusChanged|WorkspaceActivated"; then
        current_output=$(get_windows)
        
        # Only echo if the JSON has actually changed
        if [[ "$current_output" != "$last_output" ]]; then
            echo "$current_output"
            last_output="$current_output"
        fi
    fi
done
