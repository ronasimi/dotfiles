#!/bin/bash
charging=$(acpi | awk '{print $3}' | sed 's/,//g')
timeleft=$(acpi | awk '{print $5}')

if [ "${charging}" == "Unknown" ]; then
        (dunstify -u low "On AC" "System is on AC power and not charging.\nCurrently at $(acpi -b | awk '{print $4}')")
elif [ "${charging}" == "Discharging" ]; then
        (dunstify -u normal "Battery discharging" "$timeleft remaining until discharged.\nCurrently at $(acpi -b | awk '{print $4}')")
elif [ "${charging}" == "Charging" ]; then
        (dunstify -u normal "Battery charging" "$timeleft remaining until charged.\nCurrently at $(acpi -b | awk '{print $4}')")
fi
