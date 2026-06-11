#!/bin/dash

# 1. Step directly into your wallpapers folder to bypass environment path bugs
# Then save the exact hardcoded system path to a clean variable
cd "$HOME/Projects/papes" || exit 1
WALLPAPER_DIR=$(pwd)

# 2. Extract a random PNG file using its absolute path
RANDOM_BG=$(find -L "$WALLPAPER_DIR" -type f -name "*.png" | awk -v seed="$$" 'BEGIN{srand(seed)} {a[NR]=$0} END{if(NR>0) print a[int(rand()*NR)+1]}')

# 3. Clean and forcefully copy the file over to /tmp
if [ -n "$RANDOM_BG" ] && [ -f "$RANDOM_BG" ]; then
    rm -f /tmp/hyprlock_bg.png
    cp "$RANDOM_BG" /tmp/hyprlock_bg.png
fi

# 4. Fire up hyprlock
hyprlock -c "$HOME/.config/hypr/hyprlogin.conf" --immediate-render --no-fade-in --grace 0
