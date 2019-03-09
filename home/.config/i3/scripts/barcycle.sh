#!/bin/bash
# Script to restart the bar, without restarting i3

pkill i3_lemonbar.sh && ~/.config/lemonbar/i3_lemonbar.sh
