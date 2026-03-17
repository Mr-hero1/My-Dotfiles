#!/bin/bash

# Fetch the plain text from niri
output=$(niri msg keyboard-layouts 2>/dev/null)

# Find the line starting with '*', remove the '*', numbers, and leading spaces
# Then grab the first two letters and uppercase them
layout=$(echo "$output" | grep '^\s*\*' | sed 's/[*0-9 ]*//g' | cut -c1-2 | tr '[:lower:]' '[:upper:]')

# Fallback if the string is empty
if [[ -z "$layout" ]]; then
    echo "  ??"
else
    echo "  $layout"
fi
