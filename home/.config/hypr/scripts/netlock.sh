#!/bin/bash
# ~/.config/hypr/scripts/netlock.sh
ssid=$(iwgetid -r wlp3s0)
# We pull the rx bitrate directly to avoid complex piping in the config
speed=$(iw dev wlp3s0 link | awk '/rx bitrate/ {print $3, $4}')

echo -e "󰖩 ${ssid:-Disconnected}\n$speed"
