#!/bin/bash
blueon=$(bluetooth | cut -d " " -f 3)
msgId="991075"

if [ "${blueon}" == "on" ]; then
	(dunstify -a "clickWifi" -u low -t 10000 -r "$msgId" "Bluetooth on")
else
	(dunstify -a "clickWifi" -u normal -r "$msgId" "Bluetooth off")
fi
