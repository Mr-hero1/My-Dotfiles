#!/bin/bash

LOCKFILE="/tmp/eww_opener.lock"

if [ -f "$LOCKFILE" ]; then
    exit 0
fi

touch "$LOCKFILE"

if eww active-windows | grep -q "control: control"; then
    eww update control_visible=false
    sleep 0.2
    eww close control
else
    eww open control
    eww update control_visible=true
fi

rm "$LOCKFILE"
