#!/bin/bash
charging=$(acpi | awk '{print $3}' | sed 's/,//g')
msgId="991051"

if [ "${charging}" == "Unknown" ]; then
        (dunstify -a "clickBat" -u low -r "$msgId" "On AC: $(acpi -b | awk '{print $4}' | tr -d ',')")
elif [ "${charging}" == "Discharging" ]; then
        (dunstify -a "clickBat" -u normal -r "$msgId" "On Battery: $(acpi -b | awk '{print $4}' | tr -d ',')" "Time Remaining: $(acpi | awk '{print $5}')")
elif [ "${charging}" == "Charging" ]; then
        (dunstify -a "clickBat" -u normal -r "$msgId" "Charging: $(acpi -b | awk '{print $4}' | tr -d ',')" "Time to Charge: $(acpi | awk '{print $5}')")
fi
