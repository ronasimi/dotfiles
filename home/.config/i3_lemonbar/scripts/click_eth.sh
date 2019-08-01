#!/bin/bash
ethon=$(nmcli -t | grep enp0s25: | awk '{print $2}')
ethIP=$(ip addr show enp0s25 | grep inet | awk ' { print $2 } ')
msgId="991052"

if [ "${ethon}" == "connected" ]; then
	(dunstify -a "clickEth" -u low -t 10000 -r "$msgId" "Ethernet connected" "IP addresses: $ethIP")
else
	(dunstify -a "clickEth" -u normal -r "$msgId" "Ethernet disconnected")
fi
