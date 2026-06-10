#!/usr/bin/env bash

HYPRPAPER_CONFIG="$HOME/.config/hypr/hyprpaper.conf"

# Check if a file path was given
if [ -z "$1" ]; then
  echo "Error: Invalid path."
  exit 1
fi

# Rewrite the config file cleanly (handles spaces safely)
cat << EOF > "$HYPRPAPER_CONFIG"
wallpaper {
	monitor = eDP-1
	path = $1
	fit_mode = cover
}
splash = false
ipc = off
EOF

# Safely restart the systemd service
systemctl --user restart hyprpaper.service

exit 0
