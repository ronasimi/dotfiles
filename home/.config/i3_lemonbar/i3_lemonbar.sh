#! /bin/bash
#
# I3 bar with https://github.com/LemonBoy/bar
# Ron Asimi
# _                            _                _
#| | ___ _ __ ___   ___  _ __ | |__   __ _ _ __| |
#| |/ _ \ '_ ` _ \ / _ \| '_ \| '_ \ / _` | '__| |
#| |  __/ | | | | | (_) | | | | |_) | (_| | |  |_|
#|_|\___|_| |_| |_|\___/|_| |_|_.__/ \__,_|_|  (_)
#

. "$(dirname $0)"/i3_lemonbar_config

if [ "$(pgrep -cx "$(basename $0)")" -gt 1 ]; then
  printf "%s\n" "The status bar is already running." >&2
  exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "${panel_fifo}" ] && rm "${panel_fifo}"
mkfifo "${panel_fifo}"

### EVENTS METERS

# i3 binding mode "MOD"
(printf "%s\n" "MODinit" >"${panel_fifo}" && i3-msg -t subscribe -m '[ "mode" ]' | awk -F '"' '{print "MOD" $4; fflush(stdout)}') >"${panel_fifo}" &

# container layout, "LAY"
while read -r; do

  (printf "%s%s\n" "LAY" "$(i3-msg -t get_tree | jq -r 'recurse(.nodes[];.nodes!=null)|select(.nodes[].focused).layout')") >"${panel_fifo}" &

done < <(echo && i3-msg -t subscribe -m '[ "window", "workspace", "binding" ]') &

# i3 Workspaces, "WSP"
"$(dirname $0)"/scripts/workspaces.pl >"${panel_fifo}" &

# window title, "WIN"
(xtitle -sf 'WIN%s\n' >"${panel_fifo}") &

# updates, "UPD"
### update check interval
cnt_update="${upd_timer}"

while :; do
  if [ $((cnt_update++)) -ge "${upd_timer}" ]; then
    printf "%s%s\n" "UPD" "$("$(dirname $0)"/scripts/updates.sh)" >"${panel_fifo}" &
    cnt_update=0
  fi

  sleep 60

done &

# gmail, "GMA"
### mail check interval
cnt_mail="${mail_timer}"

while :; do
  if [ $((cnt_mail++)) -ge "${mail_timer}" ]; then
    printf "%s%s\n" "GMA" "$("$(dirname $0)"/scripts/gmail.sh)" >"${panel_fifo}" &
    cnt_mail=0
  fi

  sleep 60

done &

# volume, "MUT", "VOL"
while read -r; do

  printf "%s%s\n" "VOL" "$(pamixer --get-volume)" >"${panel_fifo}" &
  "$(dirname $0)"/scripts/volindicator.sh &

done < <(echo &&  pactl subscribe | awk '/sink/ {print $1; fflush()}') &

# Backlight, "BRI"
while read -r; do

  (printf "%s%s\n" "BRI" "$(xbacklight -get)" >"${panel_fifo}") &
  "$(dirname $0)"/scripts/brightindicator.sh

done < <(
  echo && inotifywait -m -e modify /sys/class/backlight/acpi_video0/actual_brightness /sys/class/backlight/intel_backlight/actual_brightness &
  udevadm monitor --kernel --subsystem-match=power_supply
) &

# network, "ETH", "WFI"
while read -r; do

  (printf "%s%s\n" "ETH" "$(nmcli -t | grep enp0s25: | cut -d ' ' -f 2)" >"${panel_fifo}") &
  (printf "%s%s\n" "WFI" "$(nmcli -t | grep wlp3s0: | cut -d ' ' -f 2)" >"${panel_fifo}") &

done < <(echo && nmcli m) &

# battery, "BAT"
while read -r; do

  (printf "%s%s\n" "BAT" "$(acpi -b | cut -d ' ' -f 4 | tr -d '%,')") >"${panel_fifo}" &

done < <(echo && upower --monitor) &

# date/time
"$(dirname $0)"/scripts/time >"${panel_fifo}" &

#### LOOP FIFO

(cat "${panel_fifo}" | "$(dirname $0)"/i3_lemonbar_parser.sh |
  lemonbar -p -d -o 0 -f "${font}" -o -0.5 -f "${iconfont}" -a "${clickables}" -g "${geometry}" -B "${color_back}" -F "${color_fore}" | sh) &

#### Keep lemonbar below fullscreen windows

tries_left=20
while [ -z "$wid" -a "$tries_left" -gt 0 ]; do
  sleep 0.05
  xdo above -t $(xwininfo -root -children | grep -E -o "0x[[:xdigit:]]+" | tail -1) "$(xdo id -a bar)"
  tries_left=$((tries_left - 1))
done

wait
