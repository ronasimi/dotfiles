#!/bin/bash
# click_clock.sh

# Arbitrary but unique message id
msgId="991070"

# Query xbacklight for the current brightness
date="$(date -I)"

# Show the brightness notification
dunstify -a "date" -u low -r "$msgId" "${date}"
