#!/bin/bash
# Script to restart the bar, without restarting i3

killall -g lemonbar
$HOME/.config/i3_lemonbar/i3_lemonbar.sh 2>/dev/null >/dev/null &
