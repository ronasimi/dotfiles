#!/bin/bash
## kill lemonbar and daemons before exiting i3
pkill lemonbar &&
pkill i3_lemonbar.sh &&
pkill i3_lemonbar_parser.sh &&
pkill conky &&
pkill feh &&
pkill thunar &&
pkill urxvtd &&
i3-msg exit
