#!/bin/bash
## kill lemonbar and daemons before exiting i3
pkill lemonbar &&
pkill thunar &&
pkill urxvtd &&
pkill compton &&
i3-msg exit
