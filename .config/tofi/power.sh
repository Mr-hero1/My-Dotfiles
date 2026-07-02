#!/bin/bash

# Define the options you want in your menu
options="Lock\nSleep\nLog Out\nRestart\nPower Off\nCancel"

# Pipe the options directly into tofi
chosen=$(echo -e "$options" | tofi)

# Execute a system command based on the choice
case "$chosen" in
    "Lock")
        hyprlock 
        ;;
    "Sleep")
        systemctl suspend
        ;;
    "Log Out")
        niri msg action quit 
        ;;
    "Restart")
        systemctl reboot
        ;;
    "Power Off")
        systemctl poweroff
        ;;
    "Cancel"|*)
        exit 0
        ;;
esac
