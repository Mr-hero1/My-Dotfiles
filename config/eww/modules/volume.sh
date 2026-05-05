#!/bin/bash

get_output() {
    pamixer --get-volume
}

get_output

pactl subscribe | while read -r event; do
    if echo "$event" | grep -q "sink"; then
        get_output
    fi
done
