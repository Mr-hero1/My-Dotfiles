#!/bin/bash

# Configuration
WIDGET_NAME="osd"
TIMER_FILE="/tmp/eww_osd_timer.run"
TIMEOUT=2.5

# 1. Open the widget if it's not already active
if ! eww active-windows | grep -q "$WIDGET_NAME"; then
    eww open "$WIDGET_NAME"
fi

# 2. Update eww variables with the new values
eww update "osd_visible"=true
eww update show_osd="$1"

# 3. Create a unique ID for this specific keypress (current time in nanoseconds)
RUN_ID=$(date +%s%N)
echo "$RUN_ID" > "$TIMER_FILE"

# 4. Start the timer in the background
(
    sleep $TIMEOUT
    
    # 5. After sleeping, check if our ID is still the latest one in the file
    if [ "$(cat "$TIMER_FILE" 2>/dev/null)" = "$RUN_ID" ]; then
        # This means no other buttons were pressed during our sleep. Safe to close!
        eww update "osd_visible"=false
        eww update show_osd="none"
        eww close "$WIDGET_NAME"
    fi
) &
