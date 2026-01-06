#!/bin/bash

get_lang() {
    layout=$(hyprctl devices -j | jq -r '.keyboards[] | select(.name == "at-translated-set-2-keyboard") | .active_keymap' | cut -c1-2 | tr '[:lower:]' '[:upper:]')
    
    if [ -z "$layout" ]; then
        echo " [??]"
    else
        echo " [$layout]"
    fi
}

get_lang
socat -u "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - | while read -r line; do
    if [[ $line == activelayout* ]]; then
        get_lang
    fi
done