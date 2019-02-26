#!/bin/bash
muted=$(pacmd list-sinks | grep "muted" | awk '{print $2}')
vol=$(pamixer --get-volume | awk '{print $1}')
if [ "${muted}" == "yes" ]; then
	(notify-send -u normal "Output volume" "Output is muted")
else
	(notify-send -u low "Output volume" "Current output volume: $vol")
fi
