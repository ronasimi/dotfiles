#!/bin/bash
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
title="%{F${color_ina} B- T2}${sep_right}%{F${color_title} T1} "

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
      mode_cicon=${color_icon}
    fi

    mode="%{F${mode_cicon} B${color_stat} T3} ${icon_mode} "
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

    layout="%{F${color_icon} B${color_stat} T3}${icon_layout} %{F${color_stat} B${color_ina}}%{T2}${sep_right}"
    ;;

  WSP*)
    # i3 Workspaces
    wsp="%{B${color_ina}}"
    set -- ${line#???}

    while [ $# -gt 0 ]; do
      case $1 in
      FOC*)
        act_name=$(echo ${1#???} | cut -d ":" -f 2)
        wsp="${wsp}%{F${color_ina} B${color_wsp} T2}${sep_right}%{F${color_act_fore} B${color_wsp} T3} ${act_name} %{F${color_wsp} B${color_ina}T2}${sep_right}"
        ;;
      INA* | ACT*)
        ina_name=$(echo ${1#???} | cut -d ":" -f 2)
        ina_number=$(echo ${1#???} | cut -d ":" -f 1)
        wsp="${wsp}%{F${color_ina} B${color_ina} T2}${sep_right}%{F${color_ina_fore} B${color_ina} T3}%{A1:i3-msg workspace number ${ina_number}:} ${ina_name} %{A}%{F${color_ina} B${color_ina} T2}${sep_right}"
        ;;
      URG*)
        urg_name=$(echo ${1#???} | cut -d ":" -f 2)
        urg_number=$(echo ${1#???} | cut -d ":" -f 1)
        wsp="${wsp}%{F${color_ina} B${color_alert} T2}${sep_right}%{F${color_act_fore} B${color_alert} T3}%{A1:i3-msg workspace number ${urg_number}:} ${urg_name} %{A}%{F${color_alert} B${color_ina} T2}${sep_right}"
        ;;
      esac
      shift
    done
    ;;

  WIN*)
    # window title
    title="%{F${color_ina} B- T2}${sep_right}%{F${color_title} T1} ${line#???}%{T-}"
    ;;

  UPD*)
    # updates
    if [ "${line#???}" != "0" ]; then
      updates="%{F${color_upd} T2}${sep_left}%{F${color_icon_dark} B${color_upd}T3} ${icon_arch}%{T1} ${line#???}${stab}"
    else
      updates=""
    fi
    ;;

  GMA*)
    # gmail
    if [ "${line#???}" != "0" ]; then
      gmail="%{F${color_mail} T2}${sep_left}%{F${color_title} B${color_mail}} %{T3}${icon_mail}%{T1} ${line#???}${stab}"
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
    elif [ "${line#???}" -ge 80 ]; then
      icon_vol=${icon_vol_hi}
      vol_cicon=${color_icon}
    elif [ "${line#???}" -ge 55 ]; then
      icon_vol=${icon_vol_med}
      vol_cicon=${color_icon}
    elif [ "${line#???}" -ge 1 ]; then
      icon_vol=${icon_vol_lo}
      vol_cicon=${color_icon}
    elif [ "${line#???}" -eq 0 ]; then
      icon_vol=${icon_vol_off}
      vol_cicon=${color_netdown}
    fi

    vol="%{F${color_sec_b1}T2}${sep_left}%{F${vol_cicon} B${color_sec_b1} T3} ${icon_vol}"
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

    bright="%{F${color_icon} B${color_sec_b1} T3} ${icon_bright}"
    ;;

  ETH*)

    # ethernet
    eth_cback=${color_sec_b2}
    eth_cfore=${color_fore}

    if [ "${line#???}" == "connected" ]; then
      ethup=${icon_ethup}
      eth_cicon=${color_icon}
    else
      ethup=${icon_ethdown}
      eth_cicon=${color_netdown}
    fi

    ethernet="%{F${eth_cback}T2}${sep_left}%{F${eth_cicon} B${eth_cback} T3} ${ethup}"
    ;;

  WFI*)
    # wlan
    wlan_cback=${color_sec_b2}
    wlan_cfore=${color_fore}

    if [ "${line#???}" == "connected" ]; then
      wlanup=${icon_wifi_up}
      wlan_cicon=${color_icon}
    else
      wlanup=${icon_wifi_down}
      wlan_cicon=${color_netdown}
    fi

    wifi="%{F${wlan_cicon} B${wlan_cback} T3} ${wlanup}"
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
      (dunstify -u critical -r 109966 "BATTERY CRITICALLY LOW" "Please plug in AC adapter immediately to avoid losing work")
    elif [ "${line#???}" -ge 98 ]; then
      icon_bat=${icon_bat_full}
      bat_cicon=${color_icon}
    elif [ "${line#???}" -ge 90 ]; then
      icon_bat=${icon_bat_90}
      bat_cicon=${color_icon}
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

    bat="%{F${bat_cicon} B${color_sec_b2} T3} ${icon_bat}"
    ;;

  DAY*)
    # date
    date="%{F${color_sec_b1}T2}${sep_left}%{F${color_icon} B${color_sec_b1}} %{T3}${icon_cal}%{F${color_fore} T1} ${line#???}%{T-}"
    ;;

  CLK*)
    # time
    time="%{F${color_sec_b2}T2}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T3}${icon_clock}%{F${color_fore} T1} ${line#???}%{T-}"
    ;;

  esac

  # and finally, output
  printf "%s\n" "%{l}${mode}${layout}%{A4:i3-msg workspace next:}%{A5:i3-msg workspace previous:}${wsp}%{A}%{A}${title}%{r}%{A1:exec $(dirname $0)/scripts/updatelist.sh &:}%{A3:exec chromium 'archlinux.org' &:}${updates}%{A}%{A}%{A1:exec $(dirname $0)/scripts/gmaillist.sh &:}%{A3:exec chromium 'mail.google.com' &:}${gmail}%{A}%{A}%{A1:exec $(dirname $0)/scripts/volindicator.sh &:}%{A3:pulseaudio-ctl mute toggle:}%{A4:pulseaudio-ctl up:}%{A5:pulseaudio-ctl down:}${vol}%{A}%{A}%{A}%{A} %{A1:exec $(dirname $0)/scripts/brightindicator.sh &:}%{A4:xbacklight -inc 5:}%{A5:xbacklight -dec 5:}${bright}%{A}%{A}%{A}${stab}%{A1:exec $(dirname $0)/scripts/click_eth.sh &:}%{A3:exec alacritty --class nmtui -d 60 40 -e nmtui &:}${ethernet}%{A}%{A} %{A1:exec $(dirname $0)/scripts/click_wifi.sh &:}%{A3:exec alacritty --class nmtui -d 60 40 -e nmtui &:}${wifi}%{A}%{A} %{A1:exec $(dirname $0)/scripts/click_bat.sh &:}${bat}%{A}${stab}%{A1:exec chromium 'calendar.google.com' &:}${date}${stab}${time}%{A} %{F- B-}"
done
