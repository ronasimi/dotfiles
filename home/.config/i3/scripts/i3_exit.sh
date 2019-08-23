#!/bin/bash
## kill lemonbar and daemons before exiting i3
pkill lemonbar &&
pkill thunar &&
pkill compton &&
i3-msg exit
