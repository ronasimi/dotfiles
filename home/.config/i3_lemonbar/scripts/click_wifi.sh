#!/bin/bash
wifion=$(nmcli -t | grep wlp3s0: | awk '{print $2}')
wifiIP=$(ip addr show wlp3s0 | grep inet | awk ' { print $2 } ')
ssid=$(nmcli -f ACTIVE,SSID dev wifi list | awk '$1=="yes" {$1=""; print $0} ')

if [ "${wifion}" == "connected" ]; then
	(notify-send -u low "WiFi connected" "SSID: $ssid\nCurrent IP addresses: $wifiIP")
else
	(notify-send -u normal "WiFi disconnected" "Not currently connected to wireless network")
fi
