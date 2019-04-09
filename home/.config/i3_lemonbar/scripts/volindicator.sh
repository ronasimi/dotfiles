#!/bin/bash
# changeVolume

# Arbitrary but unique message id
msgId="991049"

# Query amixer for the current volume and whether or not the speaker is muted
volume="$(pamixer --get-volume)"
mute="$(pamixer --get-mute)"
if [ "$mute" == "true" ]; then
	# Show the sound muted notification
	dunstify -a "volIndicator" -u critical -r "$msgId" "Volume muted"
elif [ "$volume" == 0 ]; then
	# Show the volume off notification
	dunstify -a "volIndicator" -u normal -r "$msgId" "Volume off"
else
	# Show the volume notification
	dunstify -a "volIndicator" -u low -r "$msgId" "Volume: ${volume}%"
fi
