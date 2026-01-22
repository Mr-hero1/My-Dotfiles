#!/bin/bash

# Pick a color using hyprpicker
# Assigning to the variable 'color' instead of '$1'
color=$(hyprpicker -a -t -r 2>/dev/null)

# Exit silently if no color was picked or an error occurred
if [[ -z "$color" || "$color" == "[ERR"* ]]; then
    exit 0
fi

# Create a 64x64 color swatch using ImageMagick 7
magick -size 64x64 xc:"$color" /tmp/color.png

# Define the notification function
show_notif() { 
    notify-send -u low -a "Color Picker" -t 3000 \
    -i /tmp/color.png \
    -h string:x-canonical-private-synchronous:osd \
    "$color"
}

# Call the function to show the notification
show_notif
