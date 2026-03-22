#!/usr/bin/env bash

set -e

get_volume() {
pamixer --get-volume
}
is_muted() {
[[ "$(pamixer --get-mute)" == "true" ]]
}

show_notif() {
    local vol=$(get_volume)
    local icon="󰕾"
    
    if is_muted; then
        icon="󰝟"
    fi

    local summary="${icon}  ${vol}"

    notify-send -u low -a "sys" -t 2000 \
        -h string:x-canonical-private-synchronous:osd \
        "$summary"
}

case $1 in
   volume_up)
        pamixer -i 2
        show_notif
        ;;
    volume_down)
        pamixer -d 2
        show_notif
        ;;
    volume_mute)
        pamixer -t
        show_notif
        ;;
esac
