#!/bin/bash

get_ws() {
    idx=$(niri msg -j workspaces | jq -r '.[] | select(.is_focused == true) | .idx // "1"')
    echo "$idx" 
}

get_ws

niri msg event-stream | while read -r line; do
    get_ws
done | stdbuf -oL uniq
