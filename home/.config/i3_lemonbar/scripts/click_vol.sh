#!/bin/bash
dunstify -u low "Output volume" "Output volume at $(pamixer --get-volume)%"
