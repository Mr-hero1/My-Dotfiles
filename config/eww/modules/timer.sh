#!/bin/bash

TIMER_FILE="/tmp/eww_timer_end"

# 1. EXIT IMMEDIATELY if no timer is active and no command is given
if [[ ! -f "$TIMER_FILE" && "$1" != "set" ]]; then
    echo "Select"
    exit 0
fi

# --- SET TIMER ---
if [[ "$1" == "set" && -n "$2" ]]; then
    END_TIME=$(( $(date +%s) + $2 ))
    echo "$END_TIME" > "$TIMER_FILE"

    # Background subshell handles the notification then exits
    (
        sleep "$2"
        # Only notify if the file still exists and matches our end time
        if [[ -f "$TIMER_FILE" && $(cat "$TIMER_FILE") == "$END_TIME" ]]; then
            notify-send "Timer" "Time is up!" --icon=alarm-clock --urgency=critical
            rm "$TIMER_FILE" 2>/dev/null
        fi
    ) &
    exit 0
fi

# --- DISPLAY REMAINING TIME ---
END=$(cat "$TIMER_FILE")
NOW=$(date +%s)
DIFF=$(( END - NOW ))

if (( DIFF > 0 )); then
    printf "%02d:%02d\n" $((DIFF / 60)) $((DIFF % 60))
else
    # Timer expired: clean up and exit
    echo "Select"
    rm "$TIMER_FILE" 2>/dev/null
fi
