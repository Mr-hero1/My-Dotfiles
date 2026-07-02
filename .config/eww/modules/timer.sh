#!/bin/bash

TIMER_FILE="/tmp/eww_timer_end"
NOTIFY_FLAG="/tmp/eww_timer_notified"
if [[ "$1" == "set" && -n "$2" ]]; then
    echo "$(( EPOCHSECONDS + $2 ))" > "$TIMER_FILE"
    rm -f "$NOTIFY_FLAG"
    exit 0
fi

if [[ "$1" == "clear" ]]; then
    rm -f "$TIMER_FILE" "$NOTIFY_FLAG"
    exit 0
fi

while true; do
    if [[ ! -f "$TIMER_FILE" ]]; then
        echo "Select"
        sleep 4
        continue
    fi

    read -r END < "$TIMER_FILE"
    DIFF=$(( END - EPOCHSECONDS ))

    if (( DIFF > 0 )); then
        printf "%02d:%02d\n" $((DIFF / 60)) $((DIFF % 60))
        sleep 1
    else
        if [[ ! -f "$NOTIFY_FLAG" ]]; then
            touch "$NOTIFY_FLAG"
            notify-send "Timer" "Time is up!" --urgency=critical
        fi
        echo "Select"
        rm -f "$TIMER_FILE"
    fi
done
