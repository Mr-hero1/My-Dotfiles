#!/usr/bin/env bash

TIMER_PID=""

stop_timer() {
    if [ -n "$TIMER_PID" ]; then
        kill "$TIMER_PID" 2>/dev/null
        wait "$TIMER_PID" 2>/dev/null
    fi
}

start_timer() {
    (
        sleep 5
        eww update notif-visible=false
        sleep 0.2
        eww close notification_win
    ) &
    TIMER_PID=$!
}

tiramisu -j | while read -r line; do
    stop_timer

    if ! eww active-windows | grep -wq "notification_win"; then
        eww open notification_win
        eww update notif-visible=true
    fi

    eww update notif-data="$line"

    start_timer
done
