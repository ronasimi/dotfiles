#!/usr/bin/env bash

HYPRPAPER_CONFIG="$HOME/.config/hypr/hyprpaper.conf"
LOGIN_BG="$HOME/.hyprlogin.png"

if [ ! -f "$1" ]; then
  echo "Error: Invalid or missing file path."
  exit 1
fi

TARGET_FILE=$(realpath "$1")

# 1. Fast Copy/Convert: Only use ImageMagick if the file is not already a PNG
if [[ "${TARGET_FILE,,}" == *.png ]]; then
    cp -f "$TARGET_FILE" "$LOGIN_BG"
else
    magick "$TARGET_FILE" "$LOGIN_BG"
fi

# 2. Write Config (Set ipc = on to allow live updates)
cat << EOF > "$HYPRPAPER_CONFIG"
wallpaper {
	monitor = eDP-1
	path = $TARGET_FILE
	fit_mode = cover
}
splash = false
ipc = on
EOF

# 3. Live Apply via IPC (Instant) instead of restarting the service
if systemctl --user is-active --quiet hyprpaper.service; then
    # Try using IPC to swap the wallpaper instantly
    if ! hyprctl hyprpaper preload "$TARGET_FILE" >/dev/null 2>&1; then
        # Fallback: If IPC was previously off in your old config, restart the service this one time
        systemctl --user restart hyprpaper.service
    else
        # If IPC succeeds, apply it and free up RAM by unloading the old wallpaper
        hyprctl hyprpaper wallpaper "eDP-1,$TARGET_FILE" >/dev/null
        hyprctl hyprpaper unload unused >/dev/null 2>&1
    fi
else
    systemctl --user start hyprpaper.service
fi

exit 0
