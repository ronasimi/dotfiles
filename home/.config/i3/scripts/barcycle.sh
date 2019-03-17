#!/bin/bash
# Script to restart the bar, without restarting i3

pkill lemonbar && pkill i3_lemonbar.sh && sleep 1 && bash ~/.config/lemonbar/i3_lemonbar.sh
