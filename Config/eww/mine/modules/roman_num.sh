#!/bin/bash

# Function to convert a number (1-21) to a Roman Numeral
to_roman() {
    local num=$1
    local roman=""

    case $num in
        1) roman="I";;
        2) roman="II";;
        3) roman="III";;
        4) roman="IV";;
        5) roman="V";;
        6) roman="VI";;
        7) roman="VII";;
        8) roman="VIII";;
        9) roman="IX";;
        10) roman="X";;
        11) roman="XI";;
        12) roman="XII";;
        13) roman="XIII";;
        14) roman="XIV";;
        15) roman="XV";;
        16) roman="XVI";;
        17) roman="XVII";;
        18) roman="XVIII";;
        19) roman="XIX";;
        20) roman="XX";;
        21) roman="XXI";;
        *) roman="ERR";; # Handle numbers outside the 1-21 range
    esac

    echo "$roman"
}

# 1. Get the active workspace ID
active_ws=$(hyprctl activeworkspace -j | jq -r '.id')

# 2. Convert the ID to a Roman numeral
roman_ws=$(to_roman "$active_ws")

# 3. Output the Roman numeral
echo "$roman_ws"