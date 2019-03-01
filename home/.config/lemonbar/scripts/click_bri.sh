#!/bin/bash
bright=$(xbacklight -get | awk '{print $1}')
(notify-send -u low "Backlight level" "Current backlight level: $bright%")
