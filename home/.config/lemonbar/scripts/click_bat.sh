#!/bin/bash
charging=$(acpi | awk '{print $3}' | sed 's/,//g')
level=$(acpi -b | awk '{print $4}' | sed 's/,//g')
timeleft=$(acpi | awk '{print $5}')

if [ "${charging}" == "Unknown" ]; then
        (notify-send -u low "On AC" "System is on AC power and not charging. Currently at $level")
elif [ "${charging}" == "Discharging" ]; then
        (notify-send -u normal "Battery discharging" "$timeleft remaining until discharged. Currently at $level")
elif [ "${charging}" == "Charging" ]; then
        (notify-send -u normal "Battery charging" "$timeleft remaining until charged. Currently at $level")
fi
