#!/bin/bash
wifion=$(nmcli -t | grep wlp3s0: | awk '{print $2}')
wifiIP4=$(ip -4 addr show wlp3s0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
wifiIP6=$(ip -6 addr show wlp3s0 | grep -oP '(?<=inet6\s)[\da-f:]+')
wifirate=$(iwconfig wlp3s0 | grep Bit | cut -d '=' -f 2 | cut -d ' ' -f 1-2)
ssid=$(iwconfig wlp3s0 | grep ESSID | cut -d '"' -f 2)
msgId="991053"

if [ "${wifion}" == "connected" ]; then
	(dunstify -a "clickWifi" -u low -t 10000 -r "$msgId" "WiFi connected" "SSID: $ssid\nBit Rate: $wifirate\nIPv4 Address: $wifiIP4\nIPv6 Address(es): $wifiIP6")
else
	(dunstify -a "clickWifi" -u normal -r "$msgId" "WiFi disconnected")
fi
