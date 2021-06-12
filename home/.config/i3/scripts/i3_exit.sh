#!/bin/bash
## kill lemonbar and daemons before exiting i3
killall lemonbar &
killall thunar &
killall picom &
i3-msg exit
