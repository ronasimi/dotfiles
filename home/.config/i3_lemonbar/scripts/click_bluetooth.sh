#!/bin/bash
blueon=$(bluetooth | cut -d " " -f 3)
msgId="991075"

if [ "${blueon}" == "on" ]; then
	(dunstify -a "clickWifi" -u low -t 10000 -r "$msgId" "Bluetooth on" "Paired devices:\n$(bt-device -l | egrep '\(.*\)' | grep -oP '(?<=\()[^\)]+' | xargs -n1 bt-device -i | grep -E "Name:|Connected:")")
else
	(dunstify -a "clickWifi" -u normal -r "$msgId" "Bluetooth off")
fi
