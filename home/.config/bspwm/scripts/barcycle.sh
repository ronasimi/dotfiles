#!/bin/bash
# Script to restart the bar, without restarting i3

pkill lemonbar
$HOME/.config/bsp_lemonbar/bsp_lemonbar.sh 2>/dev/null &
