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
printf "%s\n" "MODinit" > "${panel_fifo}" &
i3-msg -t subscribe -m '[ "mode" ]' | awk -F '"' '{print "MOD" $4; fflush(stdout)}' > "${panel_fifo}" &

# Caps Lock, "CAP"
while read -r; do

  (printf "%s%s\n" "CAP" "$(xset -q | awk '/Caps Lock/ {print $4}')") > "${panel_fifo}" &

  done < <(
  echo &&
  # restart xinput if it exits
  until (xinput --test 12 | grep --line-buffered "66") & disown; do
    echo "xinput crashed with exit code $?.  Respawning.." >&2
    sleep 1
  done
) &

# Num Lock, "NUM"
while read -r; do

  (printf "%s%s\n" "NUM" "$(xset -q | awk '/Num Lock/ {print $8}')") > "${panel_fifo}" &

  done < <(
  echo &&
  # restart xinput if it exits
  until (xinput --test 12 | grep --line-buffered "77") & disown; do
    echo "xinput crashed with exit code $?.  Respawning.." >&2
    sleep 1
  done
) &

# container layout, "LAY"

"$(dirname $0)"/scripts/layout.py >"${panel_fifo}" &

# i3 Workspaces, "WSP"
"$(dirname $0)"/scripts/workspaces.pl >"${panel_fifo}" &

# window title, "WIN"
xtitle -s -t 144 -f 'WIN%s\n' >"${panel_fifo}" &

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

# volume, "VOL"
while read -r; do

  (printf "%s%s\n" "VOL" "$(pamixer --get-volume-human | tr -d "%")") >"${panel_fifo}" &

  done < <(
  echo &&
  # restart pactl if it exits
  until (pactl subscribe | grep --line-buffered "sink"); do
    echo "pactl crashed with exit code $?.  Respawning.." >&2
    sleep 1
  done
) &

# Backlight, "BRI"
while read -r; do

  printf "%s%s\n" "BRI" "$(xbacklight -get)" >"${panel_fifo}" &
  "$(dirname $0)"/scripts/brightindicator.sh

  done < <(
  echo &&
  # restart udevadm if it exits with anything other than 0
  until (stdbuf -o0 udevadm monitor --udev --subsystem-match="backlight"); do
    echo "udevadm crashed with exit code $?.  Respawning.." >&2
    sleep 1
  done
) &

# wired network, "ETH"
while read -r; do

  printf "%s%s\n" "ETH" "$(nmcli -t | grep $eth: | cut -d ' ' -f 2)" >"${panel_fifo}" &
  "$(dirname $0)"/scripts/click_eth.sh

  done < <(
  echo &&
  # restart nmcli if it exits with anything other than 0
  until (nmcli device monitor $eth); do
    echo "nmcli crashed with exit code $?.  Respawning.." >&2
    sleep 1
  done
) &

# wireless network, "WFI"
while read -r; do

  printf "%s%s\n" "WFI" "$(nmcli -t | grep $wifi: | cut -d ' ' -f 2)" >"${panel_fifo}" &
  "$(dirname $0)"/scripts/click_wifi.sh

  done < <(
  echo &&
  # restart nmcli if it exits with anything other than 0
  until (nmcli device monitor $wifi); do
    echo "nmcli crashed with exit code $?.  Respawning.." >&2
    sleep 1
  done
) &

# bluetooth status, "BLU"
while read -r; do

  printf "%s%s\n" "BLU" "$(bluetooth | cut -d " " -f 3)" >"${panel_fifo}" &

  done < <(
  echo &&
  # restart udevadm if it exits with anything other than 0
  until (stdbuf -o0 udevadm monitor --udev SUBSYSTEM=="bluez"); do
    echo "udevadm crashed with exit code $?.  Respawning.." >&2
    sleep 1
  done
) &

# battery, "BAT"
while read -r; do
  printf "%s%s\n" "BAT" "$(acpi -b | cut -d ' ' -f 4 | tr -d '%,')" >"${panel_fifo}" &

  done < <(
  echo &&
  # restart upower if it exits with anything other than 0
  until (stdbuf -o0 upower --monitor); do
    echo "upower crashed with exit code $?.  Respawning.." >&2
    sleep 1
  done
) &

# date/time, "DAY"/"CLK"
"$(dirname $0)"/scripts/clock >"${panel_fifo}" &

#### LOOP FIFO

(cat "${panel_fifo}" | "$(dirname $0)"/i3_lemonbar_parser.sh |
lemonbar -p -o -1 -f "${font}" -o -1 -f "${iconfont}" -o -1 -f "${titlefont}" -a "${clickables}" -g "${geometry}" -B "${color_back}" -F "${color_fore}" | sh) &

wait
