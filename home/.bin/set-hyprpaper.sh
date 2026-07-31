#!/usr/bin/env bash

HYPRPAPER_CONFIG="$HOME/.config/hypr/hyprpaper.conf"
LOGIN_BG="$HOME/.hyprlogin.png"

if [ ! -f "$1" ]; then
  echo "Error: Invalid or missing file path."
  exit 1
fi

TARGET_FILE=$(realpath "$1")

# 1. Live Apply via IPC FIRST (Instant visual feedback)
# Uses the modern, unified wallpaper command. Fit mode added to match your config.
hyprctl hyprpaper wallpaper "eDP-1, $TARGET_FILE, cover" >/dev/null 2>&1

# 2. Offload the slow tasks to the background
(
    # Fast Copy/Convert
    if [[ "${TARGET_FILE,,}" == *.png ]]; then
        cp -f "$TARGET_FILE" "$LOGIN_BG"
    else
        magick "$TARGET_FILE" "$LOGIN_BG"
    fi

    # Write Config
    cat << EOF > "$HYPRPAPER_CONFIG"
wallpaper {
	monitor = eDP-1
	path = $TARGET_FILE
	fit_mode = cover
}
splash = false
ipc = on
EOF
) &

exit 0
