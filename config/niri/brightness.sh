#!/usr/bin/env bash

set -e
get_brightness() {
    local dir=/sys/class/backlight/$(ls /sys/class/backlight | head -n1)
    if [[ -d $dir ]]; then
        echo $(( $(<"$dir/brightness") * 100 / $(<"$dir/max_brightness") ))
    else
        echo 0
    fi
}

show_notif() {
    local icon="$1"
    local value="$2"  
    local summary="${icon} ${value}"

    notify-send -u low -a "sys" -t 2000 \
        -h string:x-canonical-private-synchronous:osd \
         "$summary"
}

case $1 in
    brightness_up|brightness_down)
        [[ $1 == "brightness_up" ]] && brightnessctl set 2%+ || brightnessctl set 2%-
        show_notif "󰃠 " "$(get_brightness)"
esac
