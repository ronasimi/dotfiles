#!/bin/bash
# brightindicactor.sh

# Arbitrary but unique message id
msgId="991050"

# Query xbacklight for the current brightness
bright="$(xbacklight -get)"

# Show the brightness notification
dunstify -a "Brightness" -u low -r "$msgId" "Backlight: ${bright}%"
