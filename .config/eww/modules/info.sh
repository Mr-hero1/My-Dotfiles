#!/bin/bash

get_sys_status_json() {
    local mic_icon=""
    local cam_icon=""

    # --- MIC LOGIC ---
    if [ "$(pamixer --source 0 --get-mute 2>/dev/null)" = "true" ]; then
        mic_icon="󰍭"
    fi

    # --- CAMERA LOGIC ---
    for status_file in /sys/class/video4linux/video*/device/power/runtime_status; do
        if [ -r "$status_file" ]; then
            read -r status < "$status_file"
            if [ "$status" = "active" ]; then
                cam_icon="󰄀"
                break
            fi
        fi
    done

    if [ -z "$cam_icon" ] && fuser /dev/video* >/dev/null 2>&1; then
        cam_icon="󰄀"
    fi

    echo "{\"camera\": \"$cam_icon\", \"mic\": \"$mic_icon\"}"
}

last_out=$(get_sys_status_json)
echo "$last_out"

while true; do
    current_out=$(get_sys_status_json)

    if [ "$current_out" != "$last_out" ]; then
        echo "$current_out"
        last_out="$current_out"
    fi

    sleep 1
done
