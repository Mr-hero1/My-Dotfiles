#!/bin/bash

get_info() {
    # RAM: Get used percentage
    RAM_PERCENT=$(free | grep Mem | awk '{print int($3/$2 * 100)}')
    
    # DISK: Get used percentage for root (/)
    DISK_PERCENT=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

    # Function to create a bar
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

    RAM_BAR=$(make_bar "$RAM_PERCENT")
    DISK_BAR=$(make_bar "$DISK_PERCENT")

    # Output: RAM [bar] 45% | DISK [bar] 20%
    # We use a unique separator '|' here so Eww can tell RAM from DISK
    echo " $RAM_BAR $(printf "%3s" "$RAM_PERCENT") | 󰋊 $DISK_BAR $(printf "%3s" "$DISK_PERCENT")"
}

get_info
