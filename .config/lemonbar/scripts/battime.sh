#!/bin/bash
charging=$(acpi | awk '{print $3}' | sed 's/,//g')
if [ "${charging}" == "Unknown" ]; then
        (notify-send -u low "On AC" "System is on AC power")
else
        (notify-send -u normal "Battery discharging" "$(acpi | awk '{print $5}') remaining")
fi
