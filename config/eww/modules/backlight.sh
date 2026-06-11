#!/bin/bash

FILE="/sys/class/backlight/intel_backlight/brightness"

print_brightness() {
    cat "$FILE"
}

print_brightness

inotifywait -mq -e modify "$FILE" | while read -r events; do
    print_brightness
done
