#!/bin/bash

# Configuration
TMP_DIR="/tmp/eww/media"
TMP_ART="$TMP_DIR/current_art.jpg"
RESIZED_ART="$TMP_DIR/thumb.png"
LAST_URL_FILE="$TMP_DIR/last_url.txt"

# High-Quality Settings
TARGET_SIZE="80x80" 

mkdir -p "$TMP_DIR"

# Function to generate a solid color placeholder box
generate_placeholder() {
    # Creates a #cdd6f4 box matching your target size
    if convert -size "$TARGET_SIZE" xc:"#cdd6f4" "$RESIZED_ART" 2>/dev/null; then
        echo "placeholder" > "$LAST_URL_FILE"
        echo "$RESIZED_ART"
    else
        echo "" # Failsafe if ImageMagick is entirely broken
    fi
    exit 0
}

# Get the current Art URL
ART_URL=$(playerctl metadata mpris:artUrl 2>/dev/null)

if [ -z "$ART_URL" ]; then
    generate_placeholder
fi

# Check if the URL has changed (to avoid unnecessary processing)
if [ -f "$LAST_URL_FILE" ]; then
    LAST_URL=$(cat "$LAST_URL_FILE")
    if [ "$ART_URL" == "$LAST_URL" ] && [ -f "$RESIZED_ART" ]; then
        echo "$RESIZED_ART"
        exit 0
    fi
fi

# Fetch the image
if [[ "$ART_URL" == http* ]]; then
    if ! curl -sfL "$ART_URL" -o "$TMP_ART"; then
        generate_placeholder
    fi
elif [[ "$ART_URL" == file://* ]]; then
    raw_path="${ART_URL#file://}"
    decoded_path=$(printf '%b' "${raw_path//%/\\x}")
    
    if [ -f "$decoded_path" ]; then
        cp "$decoded_path" "$TMP_ART"
    else
        generate_placeholder
    fi
else
    generate_placeholder
fi

# High Quality Processing
if convert "$TMP_ART" \
    -filter Lanczos \
    -thumbnail "$TARGET_SIZE^" \
    -gravity center \
    -extent "$TARGET_SIZE" \
    -unsharp 0x0.75+0.75+0.008 \
    "$RESIZED_ART" 2>/dev/null; then
    
    echo "$ART_URL" > "$LAST_URL_FILE"
    echo "$RESIZED_ART"
else
    generate_placeholder
fi
