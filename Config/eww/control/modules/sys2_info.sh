#!/bin/bash

get_stats() {
    # 1. CPU Usage
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print int(100 - $8)}')

    # 2. Wi-Fi Signal Strength
    SIG_RAW=$(nmcli -f IN-USE,SIGNAL device wifi | grep '*' | awk '{print $2}')
    
    if [ -z "$SIG_RAW" ]; then
        SIG_STRENGTH="0"
        SIG_ICON="󰤮"
    else
        SIG_STRENGTH="$SIG_RAW"
        if [ "$SIG_STRENGTH" -ge 80 ]; then SIG_ICON="󰤨"
        elif [ "$SIG_STRENGTH" -ge 60 ]; then SIG_ICON="󰤥"
        elif [ "$SIG_STRENGTH" -ge 40 ]; then SIG_ICON="󰤢"
        elif [ "$SIG_STRENGTH" -ge 20 ]; then SIG_ICON="󰤟"
        else SIG_ICON="󰤯"; fi
    fi

    # Bar function
    make_bar() {
        local val=$1
        if [ "$val" -ge 90 ]; then echo "[████████]"
        elif [ "$val" -ge 80 ]; then echo "[███████░]"
        elif [ "$val" -ge 70 ]; then echo "[██████░░]"
        elif [ "$val" -ge 60 ]; then echo "[█████░░░]"
        elif [ "$val" -ge 50 ]; then echo "[████░░░░]"
        elif [ "$val" -ge 30 ]; then echo "[███░░░░░]"
        elif [ "$val" -ge 10 ]; then echo "[█░░░░░░░]"
        else echo "[░░░░░░░░]"; fi
    }

    CPU_BAR=$(make_bar "$CPU_USAGE")
    WIFI_BAR=$(make_bar "$SIG_STRENGTH")

    # Output:  [bar] 45% | 󰤨 [bar] 85%
    echo " $CPU_BAR $(printf "%3s" "$CPU_USAGE") | $SIG_ICON $WIFI_BAR $(printf "%3s" "$SIG_STRENGTH")"
}

get_stats
