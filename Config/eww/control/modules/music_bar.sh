#!/bin/bash

# Get current position and total length in microseconds
# If playerctl fails (no player), default to 0
pos=$(playerctl metadata --format "{{position}}" 2>/dev/null || echo 0)
len=$(playerctl metadata --format "{{mpris:length}}" 2>/dev/null || echo 0)

# Check if length is greater than 0 to avoid division by zero
if [ "$len" -gt 0 ]; then
    # Calculate percentage: (current / total) * 100
    # Using printf to ensure we get a whole number for eww
    echo $(( (pos * 100) / len ))
else
    echo 0
fi
