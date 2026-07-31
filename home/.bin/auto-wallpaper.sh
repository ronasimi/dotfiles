#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/wallpaper_times.conf"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Config file not found: $CONFIG_FILE"
    exit 1
fi

source "$CONFIG_FILE"

# Safely expand tilde (~) to $HOME if it was used in the config file
DAY_WALL="${DAY_WALL/#\~/$HOME}"
NIGHT_WALL="${NIGHT_WALL/#\~/$HOME}"

if [[ ! -f "$DAY_WALL" ]]; then
    echo "Error: DAY_WALL file not found at '$DAY_WALL'"
    exit 1
fi

if [[ ! -f "$NIGHT_WALL" ]]; then
    echo "Error: NIGHT_WALL file not found at '$NIGHT_WALL'"
    exit 1
fi

CURRENT_MINS=$(( 10#$(date +%H) * 60 + 10#$(date +%M) ))

SR_H="${SUNRISE%:*}"; SR_H="${SR_H//[!0-9]/}"
SR_M="${SUNRISE#*:}"; SR_M="${SR_M//[!0-9]/}"
SUNRISE_MINS=$(( 10#${SR_H:-0} * 60 + 10#${SR_M:-0} ))

SS_H="${SUNSET%:*}"; SS_H="${SS_H//[!0-9]/}"
SS_M="${SUNSET#*:}"; SS_M="${SS_M//[!0-9]/}"
SUNSET_MINS=$(( 10#${SS_H:-0} * 60 + 10#${SS_M:-0} ))

if (( CURRENT_MINS >= SUNRISE_MINS && CURRENT_MINS < SUNSET_MINS )); then
    TARGET_WALL="$DAY_WALL"
else
    TARGET_WALL="$NIGHT_WALL"
fi

# The modernized IPC command
hyprctl hyprpaper wallpaper ", $TARGET_WALL"
