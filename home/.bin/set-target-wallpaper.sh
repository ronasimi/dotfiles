#!/usr/bin/env bash

CONFIG_FILE="$HOME/.config/hypr/wallpaper_times.conf"
MODE="$1"   # Expects "day" or "night"
NEW_PATH="$2"

if [[ ! -f "$NEW_PATH" ]]; then
    echo "Error: File not found."
    exit 1
fi

# Ensure the config file exists
touch "$CONFIG_FILE"

if grep -q "^${MODE^^}_WALL=" "$CONFIG_FILE"; then
    # Replace existing line safely
    sed -i "s|^\(${MODE^^}_WALL=\).*|\1\"$NEW_PATH\"|" "$CONFIG_FILE"
else
    # Append if it doesn't exist yet
    echo "${MODE^^}_WALL=\"$NEW_PATH\"" >> "$CONFIG_FILE"
fi

# Instantly trigger your live wallpaper script to apply it right away
~/.local/bin/set-hyprpaper.sh "$NEW_PATH"
