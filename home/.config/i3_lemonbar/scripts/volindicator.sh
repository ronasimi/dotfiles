#!/bin/bash
# changeVolume

# Arbitrary but unique message id
msgId="991049"

# Change the volume using alsa(might differ if you use pulseaudio)
amixer -c 0 set Master "$@" > /dev/null

# Query amixer for the current volume and whether or not the speaker is muted
volume="$(pamixer --get-volume)"
mute="$(pamixer --get-mute)"
if [[ $volume == 0 || "$mute" == "true" ]]; then
	# Show the sound muted notification
	dunstify -a "changeVolume" -u low -i audio-volume-muted -r "$msgId" "Volume muted"
else
	# Show the volume notification
	dunstify -a "changeVolume" -u low -i audio-volume-high -r "$msgId" \
	"Volume: ${volume}%"
fi
