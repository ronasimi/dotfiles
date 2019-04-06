#!/bin/bash
notify-send -u low "Output volume" "Output volume at $(pamixer --get-volume)%"
