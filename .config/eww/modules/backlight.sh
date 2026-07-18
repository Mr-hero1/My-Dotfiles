#!/bin/bash

DIR="/sys/class/backlight/intel_backlight"

read -r max_val < "$DIR/max_brightness"

print_brightness() {
    local current_val
    
    read -r current_val < "$DIR/brightness"
    
    echo $(( current_val * 100 / max_val ))
}

print_brightness

inotifywait -mq -e modify "$DIR/brightness" | while read -r _; do
    print_brightness
done
