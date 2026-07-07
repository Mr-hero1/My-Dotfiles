#!/bin/bash

wtype -k Caps_Lock

sleep 0.2

caps_state=$(cat /sys/class/leds/*capslock/brightness 2>/dev/null | head -n 1)

if [ "$caps_state" == "1" ]; then
    ~/.config/eww/modules/osd.sh 'capt'
else
    ~/.config/eww/modules/osd.sh 'capf'
fi
