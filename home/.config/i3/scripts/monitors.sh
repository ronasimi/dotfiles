#!/bin/bash
# find names with
# xrandr -q
EXTERNAL_DISPLAYPORT="DP-1"
EXTERNAL_VGA="VGA-1"
INTERNAL_OUTPUT="LVDS-1"

SETUP_FULL="full"
SETUP_EXTERNAL="external"
SETUP_INTERNAL=""
SETUP_CLONE="mirror"

# if we don't have a file, start at zero
if [ ! -f "/tmp/monitor_mode.dat" ] ; then
  monitor_mode="all"

# otherwise read the value from the file
else
  monitor_mode=`cat /tmp/monitor_mode.dat`
fi

if [ $monitor_mode = $SETUP_FULL ]; then
        monitor_mode=$SETUP_EXTERNAL
        xrandr --output $INTERNAL_OUTPUT --off --output $EXTERNAL_DISPLAYPORT --auto --output $EXTERNAL_VGA --auto
elif [ $monitor_mode = $SETUP_EXTERNAL ]; then
        monitor_mode=$SETUP_INTERNAL
        xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_DISPLAYPORT --off --output $EXTERNAL_VGA --off
elif [ $monitor_mode = $SETUP_INTERNAL ]; then
        monitor_mode=$SETUP_CLONE
        xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_DISPLAYPORT --auto --same-as $INTERNAL_OUTPUT --output $EXTERNAL_VGA --auto --same-as $INTERNAL_OUTPUT
else
        monitor_mode=$SETUP_FULL
        # --left-of/--right-of/--below/--above
        xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_DISPLAYPORT --auto --above $INTERNAL_OUTPUT --output $EXTERNAL_VGA --auto --above $INTERNAL_OUTPUT
fi

#echo "Switching to ${monitor_mode}"
echo "${monitor_mode}" > /tmp/monitor_mode.dat
