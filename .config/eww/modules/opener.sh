#!/bin/bash

WIDGET_NAME="control"
LOCKFILE="/tmp/eww_opener_$WIDGET_NAME.lock"

if [ -f "$LOCKFILE" ]; then
    exit 0
fi

touch "$LOCKFILE"

if eww active-windows | grep "$WIDGET_NAME" > /dev/null; then
    eww update "${WIDGET_NAME}_visible"=false
    sleep 0.15
    eww close "$WIDGET_NAME"
else
    eww open "$WIDGET_NAME"
    eww update "${WIDGET_NAME}_visible"=true
fi

rm "$LOCKFILE"
