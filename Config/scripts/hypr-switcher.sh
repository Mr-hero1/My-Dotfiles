#!/usr/bin/env bash

# 1. Get the list of windows from hyprctl in JSON format
# 2. Use jq to format each line as: "Title | Class | Address"
# 3. Pipe that list into tofi
# 4. Extract the 'address' (the last word) and focus it

selected=$(hyprctl clients -j | jq -r '.[] | "[\(.workspace.id)] \(.class) \(.address)"' | tofi )

if [ -n "$selected" ]; then
    # Extract the hex address (e.g., 0x55966453f6c0) from the end of the string
    address=$(echo "$selected" | awk -F ' | ' '{print $NF}')
    
    # Focus the window
    hyprctl dispatch focuswindow address:"$address"
fi