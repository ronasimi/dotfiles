#!/bin/bash
ethon=$(nmcli -t | grep enp0s25: | awk '{print $2}')
ethIP=$(ip addr show enp0s25 | grep inet | awk ' { print $2 } ')

if [ "${ethon}" == "connected" ]; then
	(dunstify -u low "Ethernet connected" "IP addresses: $ethIP")
else
	(dunstify -u normal "Network cable unplugged" "Not currently connected to network")
fi
