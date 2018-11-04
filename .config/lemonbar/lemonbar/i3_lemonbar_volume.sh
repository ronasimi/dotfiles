#! /bin/bash
#
# get Volume

#while :; do

  # Volume, "VOL"
#  if [ $((cnt_vol++)) -ge ${upd_vol} ]; then
    amixer get Master | grep "${snd_cha}" | awk -F'[]%[]' '/%/ {if ($7 == "off") {print "VOL×\n"} else {printf "VOL%d%%\n",$2}}' > "${panel_fifo}" &
#    cnt_vol=0
#  fi

#  usleep 5;

#done &
