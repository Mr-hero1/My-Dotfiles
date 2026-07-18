#!/bin/bash

get_vol_json() {
    if [ "$(pamixer --get-mute 2>/dev/null)" = "true" ]; then
        icon="󰖁"
    else
        icon="󰕾"
    fi
    volume=$(pamixer --get-volume 2>/dev/null)
    [ -z "$volume" ] && volume="0"
    echo "{\"icon\": \"$icon\", \"volume\": \"$volume\"}"
}
last_out=$(get_vol_json)
echo "$last_out"
pactl subscribe 2>/dev/null | grep --line-buffered "sink" | {
    while read -r _; do
        current_out=$(get_vol_json)
        if [ "$current_out" != "$last_out" ]; then
            echo "$current_out"
            last_out="$current_out"
        fi
    done
}
