#!/bin/bash

# Handle controls
case "$1" in
    --toggle) playerctl play-pause; exit 0 ;;
    --next)   playerctl next; exit 0 ;;
esac

# Efficient listener
playerctl --follow metadata --format "{{status}}:{{title}}" 2>/dev/null | while read -r line; do
    # Internal bash parsing (super fast)
    status="${line%%:*}"
    title="${line#*:}"

    if [[ -n "$title" ]]; then
        [[ "$status" == "Playing" ]] && icon="" || icon=""
        echo "$icon [$title]"
    else
        echo ""
    fi
done
