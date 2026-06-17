#!/bin/bash

TIMER_FILE="/tmp/eww_timer_end"

if [[ "$1" == "set" && -n "$2" ]]; then
    END_TIME=$(( EPOCHSECONDS + $2 ))
    echo "$END_TIME" > "$TIMER_FILE"

    (
        sleep "$2"
        if [[ -f "$TIMER_FILE" ]]; then
            read -r CURRENT_END < "$TIMER_FILE"
            if [[ "$CURRENT_END" -eq "$END_TIME" ]]; then
                notify-send "Timer" "Time is up!" --icon=alarm-clock --urgency=critical
                rm -f "$TIMER_FILE"
            fi
        fi
    ) &
    exit 0
fi

[[ ! -f "$TIMER_FILE" ]] && echo "Select" && exit 0

read -r END < "$TIMER_FILE"
DIFF=$(( END - EPOCHSECONDS ))

if (( DIFF > 0 )); then
    printf "%02d:%02d\n" $((DIFF / 60)) $((DIFF % 60))
else
    echo "Select"
    rm -f "$TIMER_FILE"
 Riding position/cleanup
fi
