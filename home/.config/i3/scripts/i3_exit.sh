#!/bin/bash
## kill lemonbar and daemons before exiting i3
killall i3_lemonbar.sh &
killall thunar &
killall picom &
i3-msg exit
