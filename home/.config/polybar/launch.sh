#!/usr/bin/env bash

NC='\033[0m'
RED='\033[31m'
BLUE='\033[34m'

launch_bar() {
  export MONITOR=$1 
  polybar "$2" &
}

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u "$(id -u)" -x polybar >/dev/null; do
  sleep 1;
done

## Use newline as field separator for looping over lines
IFS=$'\n'

# Ensure that xrandr is available and abort the script otherwise. Discard
# command's output by redirecting stdout to /dev/null and stderr to stdout.
if ! command -v xrandr >/dev/null 2>&1; then
  printf "[ ${RED}Error${NC} ] Polybar launcher requires ${BLUE}xrandr${NC} for detecting monitors.\\n" >&2
  exit
fi

for screen in $(xrandr --query | grep -w connected); do
  # Substring removal, delete everything after first space
  output=${screen%% *}
  printf "Found output: ${BLUE}%s${NC}\\n" "${output}"

  case ${screen} in
    *primary*)
      printf "Launching primary bar(s) on ${BLUE}%s${NC}\\n" "${output}"
      launch_bar "${output}" top
      ;;
    *)
      #printf "Launching secondary bar(s) on ${BLUE}%s${NC}\\n" "${output}"
      #launch_bar "${output}" top
      ;;
  esac
done
