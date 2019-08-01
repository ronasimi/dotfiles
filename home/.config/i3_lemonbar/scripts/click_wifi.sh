#!/bin/bash
wifion=$(nmcli -t | grep wlp3s0: | awk '{print $2}')
wifiIP=$(ip addr show wlp3s0 | grep inet | awk ' { print $2 } ')
wifiqual=$(iwconfig wlp3s0 | sed -n -e 's/^[ \t]*//' -e '/Link/p')
wifirate=$(iwconfig wlp3s0 | sed -n -e 's/^[ \t]*//' -e '/Bit/p')
ssid=$(iwconfig wlp3s0 | grep ESSID | awk ' { print $4 } ')
msgId="991053"

if [ "${wifion}" == "connected" ]; then
	(dunstify -a "clickWifi" -u low -t 10000 -r "$msgId" "WiFi connected" "$ssid\n$wifiqual\n$wifirate\nCurrent IP addresses: $wifiIP")
else
	(dunstify -a "clickWifi" -u normal -r "$msgId" "WiFi disconnected")
fi
