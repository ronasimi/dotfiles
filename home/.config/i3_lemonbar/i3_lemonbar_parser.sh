google-chrome-stableV#!/bin/bash
#
# Input parser for i3 bar
# Ron Asimi
# _                            _                _
#| | ___ _ __ ___   ___  _ __ | |__   __ _ _ __| |
#| |/ _ \ '_ ` _ \ / _ \| '_ \| '_ \ / _` | '__| |
#| |  __/ | | | | | (_) | | | | |_) | (_| | |  |_|
#|_|\___|_| |_| |_|\___/|_| |_|_.__/ \__,_|_|  (_)
#

# config
. "$(dirname $0)"/i3_lemonbar_config

# min init
title="%{F${color_title} T1} "

# parser
while read -r line; do

  case $line in

    MOD*)
      # binding mode
      if [ "${line#???}" == "resize" ]; then
        icon_mode=${icon_resize}
        mode_cicon=${color_mode}
      else
        icon_mode=${icon_default}
        mode_cicon=${color_sec_b2}
      fi

      mode="%{F${mode_cicon} T2} ${icon_mode} "
      ;;

    LAY*)
      # container layout
      if [ "${line#???}" == "H" ]; then
        icon_layout=${icon_splith}
      elif [ "${line#???}" == "V" ]; then
        icon_layout=${icon_splitv}
      elif [ "${line#???}" == "T" ]; then
        icon_layout=${icon_tabbed}
      elif [ "${line#???}" == "S" ]; then
        icon_layout=${icon_stacked}
      fi

      layout="%{F${color_warn} T2}${icon_layout}"
      ;;

    WSP*)
      # i3 Workspaces
      set -- ${line#???}
      wsp=""

      while [ $# -gt 0 ]; do
        case $1 in
          FOC*)
            act_name=$(echo ${1#???} | cut -d ":" -f 2)
            wsp="${wsp}%{F${color_act_fore} T2} ${act_name} "
            ;;
          INA* | ACT*)
            ina_name=$(echo ${1#???} | cut -d ":" -f 2)
            ina_number=$(echo ${1#???} | cut -d ":" -f 1)
            wsp="${wsp}%{F${color_ina_fore} T2}%{A1:i3-msg workspace number ${ina_number}:} ${ina_name} %{A}"
            ;;
          URG*)
            urg_name=$(echo ${1#???} | cut -d ":" -f 2)
            urg_number=$(echo ${1#???} | cut -d ":" -f 1)
            wsp="${wsp}%{F${color_alert} T2}%{A1:i3-msg workspace number ${urg_number}:} ${urg_name} %{A}"
            ;;
        esac
        shift
      done
      ;;

    WIN*)
      # window title
      title="%{F${color_title} B- T3}${line#???}%{T-}"
      ;;

    UPD*)
      # updates
      if [ "${line#???}" != "0" ]; then
        updates="%{F${color_upd} T2} ${icon_arch}%{T1} ${line#???}%{T-} "
      else
        updates=""
      fi
      ;;

    GMA*)
      # gmail
      if [ "${line#???}" != "0" ]; then
        gmail="%{F${color_mail} T2} ${icon_mail}%{T1} ${line#???}%{T-} "
      else
        gmail=""
      fi
      ;;

    VOL*)
      # speakers volume/muted
      if [ "${line#???}" == "muted" ]; then
        icon_vol=${icon_vol_mute}
        vol_cicon=${color_netdown}
      elif [ "${line#???}" -gt 100 ]; then
        icon_vol=${icon_vol_boost}
        vol_cicon=${color_alert}
      elif [ "${line#???}" -ge 75 ]; then
        icon_vol=${icon_vol_hi}
        vol_cicon=${color_icon}
      elif [ "${line#???}" -ge 25 ]; then
        icon_vol=${icon_vol_med}
        vol_cicon=${color_icon}
      elif [ "${line#???}" -ge 10 ]; then
        icon_vol=${icon_vol_lo}
        vol_cicon=${color_icon}
      elif [ "${line#???}" -eq 0 ]; then
        icon_vol=${icon_vol_off}
        vol_cicon=${color_netdown}
      fi

      vol="%{F${vol_cicon} T2}${icon_vol} "
      ;;

    BRI*)
      # brightness
      if [ "${line#???}" == 100 ]; then
        icon_bright=${icon_bright_100}
      elif [ "${line#???}" -ge 80 ]; then
        icon_bright=${icon_bright_80}
      elif [ "${line#???}" -ge 51 ]; then
        icon_bright=${icon_bright_51}
      elif [ "${line#???}" -ge 31 ]; then
        icon_bright=${icon_bright_31}
      elif [ "${line#???}" -ge 19 ]; then
        icon_bright=${icon_bright_19}
      elif [ "${line#???}" -ge 11 ]; then
        icon_bright=${icon_bright_11}
      elif [ "${line#???}" -ge 6 ]; then
        icon_bright=${icon_bright_6}
      fi

      bright="%{F${color_icon} T2}${icon_bright} "
      ;;

    ETH*)

      # ethernet
      eth_cback=${color_sec_b1}
      eth_cfore=${color_fore}

      if [ "${line#???}" == "connected" ]; then
        ethup=${icon_ethup}
        eth_cicon=${color_icon}
      else
        ethup=${icon_ethdown}
        eth_cicon=${color_netdown}
      fi

      ethernet="%{F${eth_cicon} T2} ${ethup} "
      ;;

    WFI*)
      # wlan
      wlan_cback=${color_sec_b1}
      wlan_cfore=${color_fore}

      if [ "${line#???}" == "connected" ]; then
        wlanup=${icon_wifi_up}
        wlan_cicon=${color_icon}
      else
        wlanup=${icon_wifi_down}
        wlan_cicon=${color_netdown}
      fi

      wifi="%{F${wlan_cicon} T2}${wlanup} "
      ;;

    BLU*)
      # bluetooth
      blue_cback=${color_sec_b1}
      blue_cfore=${color_fore}

      if [ "${line#???}" == "on" ]; then
        if [ "$(bt-device -l | egrep '\(.*\)' | grep -oP '(?<=\()[^\)]+' | xargs -n1 bt-device -i | grep -c "Connected: 1")" == "0" ]; then
          blueup=${icon_blueup}
          blue_cicon=${color_icon}
        else
          blueup=${icon_blueconn}
          blue_cicon=${color_icon}
        fi
      else
        blueup=${icon_bluedown}
        blue_cicon=${color_netdown}
      fi
      bluetooth="%{F${blue_cicon} T2}${blueup} "
      ;;

    BAT*)
      # ac status
      # on charger and charging
      if [ "$(cat /sys/class/power_supply/AC/online)" == "1" ] && [ "$(acpi | awk '{gsub(",",""); print $3}')" == "Charging" ]; then
        icon_bat=${icon_bat_charge}
        bat_cicon=${color_icon}
        # on charger and not charging/full
      elif [ "$(cat /sys/class/power_supply/AC/online)" == "1" ] && [ "$(acpi | awk '{gsub(",",""); print $3}')" == "Full" ]; then
        icon_bat=${icon_bat_ac}
        bat_cicon=${color_icon}
      elif [ "$(cat /sys/class/power_supply/AC/online)" == "1" ] && [ "$(acpi | awk '{gsub(",",""); print $3}')" == "Unknown" ]; then
        icon_bat=${icon_bat_ac}
        bat_cicon=${color_icon}
        # battery discharging
      elif [ "${line#???}" -le "${bat_alert}" ]; then
        icon_bat=${icon_bat_low}
        bat_cicon=${color_alert}
        (dunstify -u critical -r 109966 "BATTERY AT ${line#???}%" "System will suspend at 8% battery. Please plug in AC adapter immediately to avoid losing work")
      elif [ "${line#???}" -ge 98 ]; then
        icon_bat=${icon_bat_full}
        bat_cicon=${color_icon}
      elif [ "${line#???}" -ge 90 ]; then
        icon_bat=${icon_bat_90}
        bat_cicon=${color_icon_}
      elif [ "${line#???}" -ge 80 ]; then
        icon_bat=${icon_bat_80}
        bat_cicon=${color_icon}
      elif [ "${line#???}" -ge 70 ]; then
        icon_bat=${icon_bat_70}
        bat_cicon=${color_icon}
      elif [ "${line#???}" -ge 60 ]; then
        icon_bat=${icon_bat_60}
        bat_cicon=${color_icon}
      elif [ "${line#???}" -ge 50 ]; then
        icon_bat=${icon_bat_50}
        bat_cicon=${color_icon}
      elif [ "${line#???}" -ge 40 ]; then
        icon_bat=${icon_bat_40}
        bat_cicon=${color_icon}
      elif [ "${line#???}" -ge 30 ]; then
        icon_bat=${icon_bat_30}
        bat_cicon=${color_icon}
      elif [ "${line#???}" -ge 20 ]; then
        icon_bat=${icon_bat_20}
        bat_cicon=${color_icon}
      elif [ "${line#???}" -ge 10 ]; then
        icon_bat=${icon_bat_10}
        bat_cicon=${color_warn}
      elif [ "${line#???}" -ge 0 ]; then
        icon_bat=${icon_bat_0}
        bat_cicon=${color_warn}
      fi

      bat="%{F${bat_cicon} T2}${icon_bat} "
      ;;

    CLK*)
      # time
      time="%{F${color_icon} T1}${icon_clock} ${line#???}%{T-}"
      ;;

  esac

  # and finally, output
  printf "%s\n" "%{l}${mode}${layout}${stab}%{A4:i3-msg workspace next:}%{A5:i3-msg workspace previous:}${wsp}%{A}%{A}${stab}${title}%{r}%{A1:exec $(dirname $0)/scripts/updatelist.sh &:}%{A3:exec google-chrome-stable 'archlinux.org/news' &:}${updates}%{A}%{A}%{A1:exec $(dirname $0)/scripts/gmaillist.sh &:}%{A3:exec google-chrome-stable 'mail.google.com' &:}${gmail}%{A}%{A}${stab}%{A1:exec $(dirname $0)/scripts/volindicator.sh &:}%{A3:pamixer -t && exec $(dirname $0)/scripts/volindicator.sh &:}%{A5:pamixer -i 5 && exec $(dirname $0)/scripts/volindicator.sh &:}%{A4:pamixer -d 5 && exec $(dirname $0)/scripts/volindicator.sh &:}${vol}%{A}%{A}%{A}%{A} %{A1:exec $(dirname $0)/scripts/brightindicator.sh &:}%{A5:xbacklight -inc 5:}%{A4:xbacklight -dec 5:}${bright}%{A}%{A}%{A}%{A1:exec $(dirname $0)/scripts/click_eth.sh &:}%{A3:exec alacritty --class nmtui -e nmtui &:}${ethernet}%{A}%{A} %{A1:exec $(dirname $0)/scripts/click_wifi.sh &:}%{A3:exec alacritty --class nmtui -e nmtui &:}${wifi}%{A}%{A} %{A1:exec $(dirname $0)/scripts/click_bluetooth.sh &:}%{A3:exec $(dirname $0)/scripts/makefloat.sh blueman-manager &:}${bluetooth}%{A}%{A} %{A1:exec $(dirname $0)/scripts/click_bat.sh &:}${bat}%{A}${stab}%{A1:exec $(dirname $0)/scripts/click_clock.sh &:}%{A3:exec google-chrome-stable 'calendar.google.com' &:}${time}%{A}%{A} %{F- B-}"
done
