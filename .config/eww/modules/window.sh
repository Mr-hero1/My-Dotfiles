#!/bin/bash

get_title() {
niri msg -j focused-window 2>/dev/null | jq -r '.title // "~"'
}

get_title

niri msg -j event-stream | grep --line-buffered -E 'WindowFocusChanged|WindowTitleChanged' | while read -r _; do
    get_title
done
