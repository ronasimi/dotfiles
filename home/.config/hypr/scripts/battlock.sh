#!/usr/bin/env dash

# Read directly from sysfs using built-ins
read -r battery_percentage < /sys/class/power_supply/BAT0/capacity
read -r battery_status < /sys/class/power_supply/BAT0/status

# Evaluate status and assign icons
case "$battery_status" in
    "Charging") 
        icon="󰂄" 
        ;;
    "Full"|"Not charging") 
        icon="󰚥" 
        ;;
    *) # Discharging or Unknown state
        if [ "$battery_percentage" -ge 90 ]; then icon="󰁹"
        elif [ "$battery_percentage" -ge 80 ]; then icon="󰂁"
        elif [ "$battery_percentage" -ge 70 ]; then icon="󰂀"
        elif [ "$battery_percentage" -ge 60 ]; then icon="󰁿"
        elif [ "$battery_percentage" -ge 50 ]; then icon="󰁾"
        elif [ "$battery_percentage" -ge 40 ]; then icon="󰁽"
        elif [ "$battery_percentage" -ge 30 ]; then icon="󰁼"
        elif [ "$battery_percentage" -ge 20 ]; then icon="󰁻"
        elif [ "$battery_percentage" -ge 10 ]; then icon="󰁺"
        else icon="󰂃"; fi
        ;;
esac

# Output formatted string
printf "%s %s%%\n" "$icon" "$battery_percentage"