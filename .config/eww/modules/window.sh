#!/bin/bash

get_title() {
    niri msg -j focused-window 2>/dev/null | jq -r '
        .title // "~" | 
        if length > 90 then .[0:87] + "..." else . end
    '
}

get_title

niri msg -j event-stream | grep --line-buffered -E 'WindowFocusChanged|WindowTitleChanged' | while read -r _; do
    get_title
done
