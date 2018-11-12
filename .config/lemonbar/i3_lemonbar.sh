#! /bin/bash
#
# I3 bar with https://github.com/LemonBoy/bar
# _                            _                _
#| | ___ _ __ ___   ___  _ __ | |__   __ _ _ __| |
#| |/ _ \ '_ ` _ \ / _ \| '_ \| '_ \ / _` | '__| |
#| |  __/ | | | | | (_) | | | | |_) | (_| | |  |_|
#|_|\___|_| |_| |_|\___/|_| |_|_.__/ \__,_|_|  (_)
#

. $(dirname $0)/i3_lemonbar_config

if [ $(pgrep -cx $(basename $0)) -gt 1 ] ; then
  printf "%s\n" "The status bar is already running." >&2
  exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "${panel_fifo}" ] && rm "${panel_fifo}"
mkfifo "${panel_fifo}"

### EVENTS METERS

# Window title, "WIN"
while read -r; do

xprop -root _NET_ACTIVE_WINDOW | sed -un 's/.*\(0x.*\)/WIN\1/p' > "${panel_fifo}" &

done < <(echo && i3-msg -t subscribe -m '[ "window" ]') &

# i3 Workspaces, "WSP"
# TODO : Restarting I3 breaks the IPC socket con. :(
$(dirname $0)/i3_workspaces.pl > "${panel_fifo}" &

# Conky, "SYS"
conky -c $(dirname $0)/i3_lemonbar_conky > "${panel_fifo}" &

# Volume, "VOL"
while read -r; do

amixer get Master | grep "${snd_cha}" | awk -F'[]%[]' '/%/ {if ($7 == "off") {print "VOL×\n"} else {printf "VOL%d%%\n",$2}}' > "${panel_fifo}" &

done < <(echo && stdbuf -oL alsactl monitor pulse) &

### Mail update interval
cnt_mail=${upd_mail}

while :; do

  # GMAIL, "GMA"
  if [ $((cnt_mail++)) -ge ${upd_mail} ]; then
    printf "%s%s\n" "GMA" "$(~/.bin/gmail.sh)" > "${panel_fifo}"
    cnt_mail=0
  fi

  sleep 1;

done &

#### LOOP FIFO

cat "${panel_fifo}" | $(dirname $0)/i3_lemonbar_parser.sh \
  | lemonbar -p -d -f "${font}" -f "${iconfont}" -g "${geometry}" -B "${color_back}" -F "${color_fore}" &

#### Keep lemonbar below fullscreen windows

tries_left=20
while [ -z "$wid" -a "$tries_left" -gt 0 ] ; do
  sleep 0.05
  xdo above -t $(xwininfo -root -children | egrep -o "0x[[:xdigit:]]+" | tail -1) $(xdo id -a bar)
  tries_left=$((tries_left - 1))
done


wait
