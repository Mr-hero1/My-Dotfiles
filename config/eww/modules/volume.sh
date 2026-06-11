#!/bin/bash

get_vol() {
    echo $(pamixer --get-volume)
}

get_vol

pactl subscribe | stdbuf -oL grep --line-buffered "sink" | while read -r _; do
    get_vol
done
