#!/bin/bash

# Arbitrary but unique message id
msgId="991075"
dunstify -u low -t 30000 -r "$msgId" "Fetching update list..."
repos=$(checkupdates 2>/dev/null && pikaur -Qua 2>/dev/null)
dunstify -u low -t 20000 -r "$msgId" "Available Updates:" "$repos"
