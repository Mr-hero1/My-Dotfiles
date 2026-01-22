#!/bin/bash

# Configuration
TMP_DIR="/tmp/eww/media"
TMP_ART="$TMP_DIR/current_art.jpg"
RESIZED_ART="$TMP_DIR/thumb.png"
LAST_URL_FILE="$TMP_DIR/last_url.txt"
DEFAULT_ART="$HOME/.config/eww/assets/default_cover.png"

# High-Quality Settings
# We use 180px for a 90px UI element to ensure sharpness (2x scaling)
TARGET_SIZE="180x180"

mkdir -p "$TMP_DIR"

# Get the current Art URL
ART_URL=$(playerctl metadata mpris:artUrl 2>/dev/null)

if [ -z "$ART_URL" ]; then
    ART_URL="default"
fi

# Check if the URL has changed
if [ -f "$LAST_URL_FILE" ]; then
    LAST_URL=$(cat "$LAST_URL_FILE")
    if [ "$ART_URL" == "$LAST_URL" ] && [ -f "$RESIZED_ART" ]; then
        echo "$RESIZED_ART"
        exit 0
    fi
fi

# Fetch the image
if [ "$ART_URL" == "default" ]; then
    cp "$DEFAULT_ART" "$TMP_ART"
elif [[ "$ART_URL" == http* ]]; then
    curl -s "$ART_URL" -o "$TMP_ART"
elif [[ "$ART_URL" == file://* ]]; then
    # Fix for file paths with URL encoding (%20 for spaces, etc)
    raw_path="${ART_URL#file://}"
    decoded_path=$(printf '%b' "${raw_path//%/\\x}")
    cp "$decoded_path" "$TMP_ART"
else
    cp "$DEFAULT_ART" "$TMP_ART"
fi

# High Quality Processing
# -filter Lanczos: Best algorithm for downscaling images without blur
# -sharpen: Adds a tiny bit of crispness to the edges
convert "$TMP_ART" \
    -filter Lanczos \
    -thumbnail "$TARGET_SIZE^" \
    -gravity center \
    -extent "$TARGET_SIZE" \
    -unsharp 0x0.75+0.75+0.008 \
    "$RESIZED_ART"

# Save state and output path for EWW
echo "$ART_URL" > "$LAST_URL_FILE"
echo "$RESIZED_ART"
