#!/usr/bin/env dash
# Runs in the background to avoid blocking the compositor lock
rm -f /tmp/active_players
for p in $(playerctl -l 2>/dev/null); do
    if [ "$(playerctl -p "$p" status 2>/dev/null)" = "Playing" ]; then
        pos1=$(playerctl -p "$p" position 2>/dev/null)
        sleep 0.2
        pos2=$(playerctl -p "$p" position 2>/dev/null)
        if [ "$pos1" != "$pos2" ]; then
            echo "$p" >> /tmp/active_players
        fi
    fi
done

playerctl -a pause

# Wait for hyprlock to close before resuming
while pidof hyprlock > /dev/null; do
    sleep 1
done

if [ -f /tmp/active_players ]; then
    for p in $(cat /tmp/active_players); do
        playerctl -p "$p" play 2>/dev/null
    done
    rm -f /tmp/active_players
fi
