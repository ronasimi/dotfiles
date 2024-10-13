#!/usr/bin/env bash

HYPRPAPER_CONFIG=$HOME/.config/hypr/hyprpaper.conf

if [ -z "$1" ]; then
  echo "Error: Invalid path \$1."
  exit 1
fi

# Muy manual pero ya buscaré una manera mas sofisticada

echo '' > $(echo $HYPRPAPER_CONFIG)
echo "preload = $1" >> $(echo $HYPRPAPER_CONFIG)
echo "wallpaper =,$1" >> $(echo $HYPRPAPER_CONFIG)
echo "splash = false" >> $(echo $HYPRPAPER_CONFIG)
echo "ipc = off" >> $(echo $HYPRPAPER_CONFIG)

pkill hyprpaper || sleep 1 && hyprpaper & disown

exit 0
