#!/bin/bash
charging=$(acpi | awk '{print $3}' | sed 's/,//g')
if [ "${charging}" == "Unknown" ]; then
        (notify-send -u low "On AC" "System is on AC power and not charging")
elif [ "${charging}" == "Discharging" ]; then
        (notify-send -u normal "Battery discharging" "$(acpi | awk '{print $5}') remaining until discharged.")
elif [ "${charging}" == "Charging" ]; then
        (notify-send -u normal "Battery charging" "$(acpi | awk '{print $5}') remaining until charged.")
fi
