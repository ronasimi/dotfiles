#!/usr/bin/env dash
# Fast, dependency-free battery status for hyprlock.
# Hyprlock expects this helper to return synchronously, so keep it sysfs-only.

battery_dir=${HYPR_BATTERY_PATH:-/sys/class/power_supply/BAT0}

if ! IFS= read -r battery_percentage < "$battery_dir/capacity" 2>/dev/null ||
   ! IFS= read -r battery_status < "$battery_dir/status" 2>/dev/null; then
    printf '󰂑 --%%\n'
    exit 0
fi

case "$battery_status" in
    Charging)
        icon='󰂄'
        ;;
    Full|'Not charging')
        icon='󰚥'
        ;;
    *)
        case "$battery_percentage" in
            ''|*[!0-9]*) battery_percentage=0 ;;
        esac

        if   [ "$battery_percentage" -ge 90 ]; then icon='󰁹'
        elif [ "$battery_percentage" -ge 80 ]; then icon='󰂁'
        elif [ "$battery_percentage" -ge 70 ]; then icon='󰂀'
        elif [ "$battery_percentage" -ge 60 ]; then icon='󰁿'
        elif [ "$battery_percentage" -ge 50 ]; then icon='󰁾'
        elif [ "$battery_percentage" -ge 40 ]; then icon='󰁽'
        elif [ "$battery_percentage" -ge 30 ]; then icon='󰁼'
        elif [ "$battery_percentage" -ge 20 ]; then icon='󰁻'
        elif [ "$battery_percentage" -ge 10 ]; then icon='󰁺'
        else icon='󰂃'
        fi
        ;;
esac

printf '%s %s%%\n' "$icon" "$battery_percentage"
