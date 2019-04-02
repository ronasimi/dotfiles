#!/bin/bash

(notify-send -u low "Backlight level" "Panel backlight at $(xbacklight -get)%")

