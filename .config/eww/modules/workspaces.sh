#!/bin/bash
words=("zero" "one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "ten")

get_ws() {
    idx=$(niri msg -j workspaces | jq -r '.[] | select(.is_focused == true) | .idx // "1"')
    
    if [[ -n "${words[$idx]}" ]]; then
        echo "${words[$idx]}"
    else
        echo "$idx"
    fi
}

get_ws

niri msg event-stream | while read -r line; do
    get_ws
done | stdbuf -oL uniq
