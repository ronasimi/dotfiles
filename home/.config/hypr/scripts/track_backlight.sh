#!/bin/bash

# Find the exact backlight directories
BL_DIR=$(ls -d /sys/class/backlight/* | head -n 1)
KBD_DIR="/sys/class/leds/tpacpi::kbd_backlight"

# Initialize tracking variables
prev_bl="-1"
prev_kbd="-1"

while true; do
    # 1. Track Screen Backlight
    if [ -d "$BL_DIR" ]; then
        cur_bl=$(cat "$BL_DIR/brightness")
        if [ "$cur_bl" != "$prev_bl" ] && [ "$cur_bl" -gt 0 ]; then
            echo "$cur_bl" > /tmp/user_bl
            prev_bl="$cur_bl"
        fi
    fi
    
    # 2. Track Keyboard Backlight
    if [ -d "$KBD_DIR" ]; then
        cur_kbd=$(cat "$KBD_DIR/brightness")
        if [ "$cur_kbd" != "$prev_kbd" ] && [ "$cur_kbd" -gt 0 ]; then
            echo "$cur_kbd" > /tmp/user_kbd
            prev_kbd="$cur_kbd"
        fi
    fi
    
    # Check twice a second (fast enough to catch state, 0% CPU cost)
    sleep 0.5
done
