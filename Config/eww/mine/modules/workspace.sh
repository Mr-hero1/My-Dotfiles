#!/bin/bash
if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    HYPRLAND_INSTANCE_SIGNATURE=$(ls "$XDG_RUNTIME_DIR/hypr/" | head -n 1)
    export HYPRLAND_INSTANCE_SIGNATURE
fi

hyprctl monitors -j | jq -r '.[] | select(.focused) | .activeWorkspace.id'

socat -u UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - | \
  stdbuf -o0 awk -F '>>|,' '/^workspacev2>>/ {print $2}' | \
  stdbuf -o0 uniq
