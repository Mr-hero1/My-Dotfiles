#!/bin/bash

get_ws() {
    idx=$(niri msg -j workspaces | jq -r '.[] | select(.is_focused == true) | .idx // "1"')
    
    case $idx in
        1) echo "I" ;;
        2) echo "II" ;;
        3) echo "III" ;;
        4) echo "IV" ;;
        5) echo "V" ;;
        6) echo "VI" ;;
        7) echo "VII" ;;
        8) echo "VIII" ;;
        9) echo "IX" ;;
        *) echo "$idx" ;; 
    esac
}

get_ws

niri msg event-stream | while read -r line; do
    get_ws
done | stdbuf -oL uniq
