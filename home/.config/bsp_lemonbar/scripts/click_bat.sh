#!/bin/bash
charging=$(acpi | awk '{print $3}' | sed 's/,//g')
timeleft=$(acpi | awk '{print $5}')

if [ "${charging}" == "Unknown" ]; then
        (notify-send -u low "On AC" "System is on AC power and not charging.")
elif [ "${charging}" == "Discharging" ]; then
        (notify-send -u normal "Battery discharging" "$timeleft remaining until discharged.")
elif [ "${charging}" == "Charging" ]; then
        (notify-send -u normal "Battery charging" "$timeleft remaining until charged.")
fi
