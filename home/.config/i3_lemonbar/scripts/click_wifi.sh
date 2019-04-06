#!/bin/bash
wifion=$(nmcli -t | grep wlp3s0: | awk '{print $2}')
wifiIP=$(ip addr show wlp3s0 | grep inet | awk ' { print $2 } ')
ssid=$(nmcli -f ACTIVE,SSID dev wifi list | awk '$1=="yes" {$1=""; print $0} ')
msgId="991053"

if [ "${wifion}" == "connected" ]; then
	(dunstify -a "clickWifi" -u low -r "$msgId" "WiFi connected" "SSID: $ssid\nCurrent IP addresses: $wifiIP")
else
	(dunstify -a "clickWifi" -u normal -r "$msgId" "WiFi disconnected" "Not currently connected to wireless network")
fi
