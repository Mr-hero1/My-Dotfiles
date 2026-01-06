#!/bin/bash
BAT=$(ls /sys/class/power_supply | grep BAT | head -n 1)
[ -z "$BAT" ] && echo "󰂎 No Bat" && exit 0

PERCENT=$(cat "/sys/class/power_supply/$BAT/capacity")
STATUS=$(cat "/sys/class/power_supply/$BAT/status")

[ "$STATUS" = "Charging" ] && CHARGE="󱐋" || CHARGE=""

if [ "$PERCENT" -ge 90 ]; then bar="󰁹 [████████]"
elif [ "$PERCENT" -ge 80 ]; then bar="󰂂 [███████░]"
elif [ "$PERCENT" -ge 70 ]; then bar="󰂁 [██████░░]"
elif [ "$PERCENT" -ge 60 ]; then bar="󰂀 [█████░░░]"
elif [ "$PERCENT" -ge 50 ]; then bar="󰁾 [████░░░░]"
elif [ "$PERCENT" -ge 40 ]; then bar="󰁾 [███░░░░░]"
elif [ "$PERCENT" -ge 20 ]; then bar="󰁼 [██░░░░░░]"
else bar="󰁺 [░░░░░░░░]"; fi

echo "$bar$CHARGE"