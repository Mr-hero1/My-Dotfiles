#!/bin/bash

TIMER_FILE="/tmp/eww_timer_end"
NOTIFY_FLAG="/tmp/eww_timer_notified"

for pid in $(pgrep -f "$(basename "$0")"); do
    if (( pid != $$ )); then
        kill "$pid" 2>/dev/null
    fi
done

if [[ "$1" == "set" && -n "$2" ]]; then
    echo "$(( EPOCHSECONDS + $2 ))" > "$TIMER_FILE"
    rm -f "$NOTIFY_FLAG"
fi

if [[ "$1" == "clear" ]]; then
    rm -f "$TIMER_FILE" "$NOTIFY_FLAG"
    eww update timer_status=""
    exit 0
fi

while true; do
    if [[ ! -f "$TIMER_FILE" ]]; then
        sleep 2
        continue
    fi

    read -r END < "$TIMER_FILE"

    while [[ -f "$TIMER_FILE" ]]; do
        DIFF=$(( END - EPOCHSECONDS ))

        if (( DIFF > 0 )); then
            printf -v TIME_STR "%02d:%02d" $((DIFF / 60)) $((DIFF % 60))
            eww update timer_status="$TIME_STR"
            sleep 1
        else
            if [[ ! -f "$NOTIFY_FLAG" ]]; then
                touch "$NOTIFY_FLAG"
                notify-send "Timer" "Time is up!" --urgency=critical
            fi
            eww update timer_status=""
            rm -f "$TIMER_FILE" "$NOTIFY_FLAG"
            exit 0
        fi
    done
done
