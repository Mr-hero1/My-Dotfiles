#!/bin/bash

# Configuration
WIDGET_NAME="osd"
TIMER_FILE="/tmp/eww_osd_timer.run"
STATE_FILE="/tmp/eww_osd_state.cache"
TIMEOUT=2.5

LAST_STATE=$(cat "$STATE_FILE" 2>/dev/null)

if [ "$1" != "$LAST_STATE" ]; then
    echo "$1" > "$STATE_FILE"

    if ! eww active-windows | grep -q "$WIDGET_NAME"; then
        eww open "$WIDGET_NAME"
    fi

    eww update "osd_visible"=true
    eww update show_osd="$1"
fi

# -- WHETHER IT CHANGED OR NOT: Update the timer --

RUN_ID=$(date +%s%N)
echo "$RUN_ID" > "$TIMER_FILE"

(
    sleep $TIMEOUT
    
    if [ "$(cat "$TIMER_FILE" 2>/dev/null)" = "$RUN_ID" ]; then
        eww update "osd_visible"=false
        eww update show_osd="none"
        eww close "$WIDGET_NAME"
        
        rm -f "$STATE_FILE"
    fi
) &
