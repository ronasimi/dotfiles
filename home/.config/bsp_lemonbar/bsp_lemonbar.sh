#! /bin/bash
#
# bspwm bar with https://github.com/LemonBoy/bar
# _                            _                _
#| | ___ _ __ ___   ___  _ __ | |__   __ _ _ __| |
#| |/ _ \ '_ ` _ \ / _ \| '_ \| '_ \ / _` | '__| |
#| |  __/ | | | | | (_) | | | | |_) | (_| | |  |_|
#|_|\___|_| |_| |_|\___/|_| |_|_.__/ \__,_|_|  (_)
#

. "$(dirname $0)"/bsp_lemonbar_config

if [ "$(pgrep -cx "$(basename $0)")" -gt 1 ] ; then
        printf "%s\n" "The status bar is already running." >&2
        exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "${panel_fifo}" ] && rm "${panel_fifo}"
mkfifo "${panel_fifo}"

### EVENTS METERS

# bspwm Workspaces, "WSP"
(bspc subscribe report) > "${panel_fifo}" &

# Window title, "WIN"
while read -r; do

        (xprop -root _NET_ACTIVE_WINDOW | sed -un 's/.*\(0x.*\)/WIN\1/p' > "${panel_fifo}")

done < <(echo && bspc subscribe report) &

# Updates, "UPD"
### Update check interval
cnt_update="${upd_timer}"

while :; do
        if [ $((cnt_update++)) -ge "${upd_timer}" ]; then
                printf "%s%s\n" "UPD" "$("$(dirname $0)"/scripts/updates.sh)" > "${panel_fifo}"
                cnt_update=0
        fi

        sleep 60

done &

# GMAIL, "GMA"
### Mail check interval
cnt_mail="${mail_timer}"

while :; do
        if [ $((cnt_mail++)) -ge "${mail_timer}" ]; then
                printf "%s%s\n" "GMA" "$("$(dirname $0)"/scripts/gmail.sh)" > "${panel_fifo}"
                cnt_mail=0
        fi

        sleep 60

done &

# Backlight, "BRI"
while read -r; do

        (xbacklight -get | awk '{print "BRI" $1}' > "${panel_fifo}")

done < <(echo && inotifywait -m -e modify /sys/class/backlight/acpi_video0/actual_brightness /sys/class/backlight/intel_backlight/actual_brightness -e open /sys/class/power_supply/AC/uevent) &

# Volume, "MUT", "VOL"
while read -r; do

        (pamixer --get-volume | awk '{print "VOL" $1}' > "${panel_fifo}")

done < <(echo && inotifywait -m /dev/snd/controlC0) &

# Network, "ETH", "WFI"
while read -r; do

        (nmcli -t | grep enp0s25: | awk '{print "ETH" $2}' > "${panel_fifo}")
        (nmcli -t | grep wlp3s0: | awk '{print "WFI" $2}' > "${panel_fifo}")

done < <(echo && nmcli m) &

# Battery, "BAT"
while read -r; do

        (acpi -b | awk '{print "BAT" $4}' | tr -d '%,' > "${panel_fifo}")

done < <(echo && upower --monitor) &

# date/time

"$(dirname $0)"/scripts/clk > "${panel_fifo}" &
"$(dirname $0)"/scripts/day > "${panel_fifo}" &

#### LOOP FIFO

(cat "${panel_fifo}" | "$(dirname $0)"/bsp_lemonbar_parser.sh \
| lemonbar -p -d -f "${font}" -f "${iconfont}" -a "${clickables}" -g "${geometry}" -B "${color_back}" -F "${color_fore}" | sh) &

#### Keep lemonbar below fullscreen windows

tries_left=20
while [ -z "$wid" -a "$tries_left" -gt 0 ] ; do
        sleep 0.05
        xdo above -t $(xwininfo -root -children | grep -E -o "0x[[:xdigit:]]+" | tail -1) $(xdo id -a bar)
        tries_left=$((tries_left - 1))
done

wait
