#!/bin/bash

eww -c ~/.config/eww/power open powermenu

# 2. Define the 'close' command
# We tell Hyprland: Close Eww, Reset the submap, and then delete these temp binds
CLOSE_CMD="eww -c ~/.config/eww/power close powermenu; hyprctl dispatch submap reset"

# 3. Create the temporary submap
hyprctl --batch "keyword bind , escape, exec, $CLOSE_CMD ; \
                 keyword bind , q, exec, $CLOSE_CMD ; \
                 dispatch submap eww_mode"
