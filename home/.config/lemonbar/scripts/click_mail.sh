#!/bin/bash
wifion=$(nmcli -t | grep wlp3s0: | awk '{print $2}')
if [ "${wifion}" == "connected" ]; then
	(notify-send -u normal "WiFi connected" "SSID: $(nmcli -f ACTIVE,SSID dev wifi list | awk '$1=="yes" {$1=""; print $0} ')")
else
	(notify-send -u normal "WiFi disconnected" "Not currently connected to wireless network")
fi
