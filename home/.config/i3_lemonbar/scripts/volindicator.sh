#!/bin/bash
# changeVolume

# Arbitrary but unique message id
msgId="991049"

# Query amixer for the current volume and whether or not the speaker is muted
volume="$(pamixer --get-volume)"
mute="$(pamixer --get-mute)"
if [[ $volume == 0 || "$mute" == "true" ]]; then
	# Show the sound muted notification
	dunstify -a "changeVolume" -u critical -r "$msgId" "Volume muted"
else
	# Show the volume notification
	dunstify -a "changeVolume" -u low -r "$msgId" "Volume: ${volume}%"
fi
