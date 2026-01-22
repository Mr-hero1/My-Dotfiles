#!/usr/bin/env bash

set -e

get_brightness() {
    local dir=/sys/class/backlight/$(ls /sys/class/backlight | head -n1)
    [[ -d $dir ]] && echo $(( $(<"$dir/brightness") * 100 / $(<"$dir/max_brightness") )) || echo 0
}

show_notif() { 
    # Using x-canonical-private-synchronous instead of dunst-stack-tag
    notify-send -u low -a sys -t 2000 \
    -h string:x-canonical-private-synchronous:osd \
    -h int:value:"$2" "$1" 
}
# --- Main actions ---
case $1 in
    brightness_up|brightness_down)
        brightnessctl set $([[ $1 == brightness_up ]] && echo 2%+ || echo 2%-)
        show_notif "[BRIGHTNESS LEVEL]" "$(get_brightness)"
        ;;
esac
