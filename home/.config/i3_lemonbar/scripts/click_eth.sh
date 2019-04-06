#!/bin/bash
ethon=$(nmcli -t | grep enp0s25: | awk '{print $2}')
ethIP=$(ip addr show enp0s25 | grep inet | awk ' { print $2 } ')
msgId="991052"

if [ "${ethon}" == "connected" ]; then
	(dunstify -a "clickEth" -u low -r "$msgId" "Ethernet connected" "IP addresses: $ethIP")
else
	(dunstify -a "clickEth" -u normal -r "$msgId" "Network cable unplugged" "Not currently connected to network")
fi
