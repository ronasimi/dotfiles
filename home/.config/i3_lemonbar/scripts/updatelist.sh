#!/bin/bash
repos=$(checkupdates 2>/dev/null && pikaur -Qua 2>/dev/null)
dunstify -u low -t 20000 "Available Updates" "$repos"
