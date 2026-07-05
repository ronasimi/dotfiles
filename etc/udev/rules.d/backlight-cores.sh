#!/bin/dash
# Unified Asynchronous Power Handler (Brightness + Core Scaling)

TARGET_STATE="$1"

case "$TARGET_STATE" in
    battery)
        # 1. Dim screen instantly (Drop brightness to 50%)
        brightnessctl set 50%
        
        # 2. Pause briefly to let udev drop hooks, then offline CPU threads 8, 9, 10, 11
        sleep 0.5
        for i in 8 9 10 11; do
            echo 0 > "/sys/devices/system/cpu/cpu$i/online"
        done
        ;;
        
    ac)
        # 1. Boost screen instantly (Raise brightness to 100%)
        brightnessctl set 100%
        
        # 2. Pause briefly to let udev drop hooks, then online CPU threads 8, 9, 10, 11
        sleep 0.5
        for i in 8 9 10 11; do
            echo 1 > "/sys/devices/system/cpu/cpu$i/online"
        done
        ;;
esac
