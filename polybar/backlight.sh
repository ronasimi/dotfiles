#!/bin/bash

# brightness
    blDir='/sys/class/backlight/intel_backlight'
    bright_cur=$(cat $blDir/actual_brightness) # current brightness
    bright_max=$(cat $blDir/max_brightness)    # maximum brightness
    bright_pct=$(echo "scale=3; ($bright_cur/$bright_max)*100" | bc | awk '{print int($1+0.5)}')
    echo $bright_pct
