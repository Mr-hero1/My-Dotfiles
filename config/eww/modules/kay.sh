#!/bin/bash

layout=$(niri msg keyboard-layouts | awk '/^\s*\*/ { 
    gsub(/[*0-9[:space:]]+/, ""); 
    print toupper(substr($0, 1, 2)) 
}')

echo "  $layout"
