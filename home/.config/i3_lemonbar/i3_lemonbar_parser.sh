#!/bin/bash
#
# Input parser for i3 bar
# Feb 22 2018 - ronasimi
# _                            _                _
#| | ___ _ __ ___   ___  _ __ | |__   __ _ _ __| |
#| |/ _ \ '_ ` _ \ / _ \| '_ \| '_ \ / _` | '__| |
#| |  __/ | | | | | (_) | | | | |_) | (_| | |  |_|
#|_|\___|_| |_| |_|\___/|_| |_|_.__/ \__,_|_|  (_)
#

# config
. "$(dirname $0)"/i3_lemonbar_config

# min init
title="%{F${color_ina} B-}${sep_right}%{F${color_title} T1} "
updates="%{F${color_sec_b1} T1}${sep_left}%{F${color_netdown} B${color_sec_b1}} %{T2}${icon_arch}"

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

    mode="%{F${mode_cicon} B${color_stat} T2} ${icon_mode} "
    ;;

  LAY*)
    # container layout
    if [ "${line#???}" == "splith" ]; then
      icon_layout=${icon_splith}
    elif [ "${line#???}" == "splitv" ]; then
      icon_layout=${icon_splitv}
    elif [ "${line#???}" == "tabbed" ]; then
      icon_layout=${icon_tabbed}
    elif [ "${line#???}" == "stacked" ]; then
      icon_layout=${icon_stacked}
    fi

    layout="%{F${color_icon} B${color_stat} T2}${icon_layout} %{F${color_stat} B${color_ina}}%{T1}${sep_right}"
    ;;

  WSP*)
    # i3 Workspaces
    wsp="%{B${color_ina}}"
    set -- ${line#???}

    while [ $# -gt 0 ]; do
      case $1 in
      FOC*)
        wsp="${wsp}%{F${color_ina} B${color_wsp}}${sep_right}%{F${color_act_fore} B${color_wsp} T2} ${1#???} %{F${color_wsp} B${color_ina}}${T1}${sep_right}"
        ;;
      INA* | ACT*)
        wsp="${wsp}%{F${color_ina} B${color_ina}}${sep_right}%{F${color_ina_fore} B${color_ina} T2} ${1#???} %{F${color_ina} B${color_ina}}${T1}${sep_right}"
        ;;
      URG*)
        wsp="${wsp}%{F${color_ina} B${color_alert}}${sep_right}%{F${color_act_fore} B${color_alert} T2} ${1#???} %{F${color_alert} B${color_ina}}${T1}${sep_right}"
        ;;
      esac
      shift
    done
    ;;

  WIN*)
    # window title
    title="%{F${color_ina} B-}${T1}${sep_right}%{F${color_title} T1} ${line#???}%{T-}"
    ;;

  UPD*)
    # updates
    if [ "${line#???}" != "0" ]; then
      updates="%{F${color_sec_b1} T1}${sep_left}%{F${color_upd} B${color_sec_b1}} %{T2}${icon_arch}%{T1} ${line#???}"
    else
      upd_cback=${color_sec_b1}
      upd_cicon=${color_icon}
      upd_cfore=${color_fore}
      updates="%{F${color_sec_b1} T1}${sep_left}%{F${color_netdown} B${color_sec_b1}} %{T2}${icon_arch}"
    fi

    ;;

  GMA*)
    # gmail
    if [ "${line#???}" != "0" ]; then
      gmail="%{F${color_mail} B${color_sec_b1}} %{T2}${icon_mail}%{T1} ${line#???}"
    else
      gmail="%{F${color_netdown} B${color_sec_b1}} %{T2}${icon_mail}"
    fi
    ;;

  VOL*)
    # speakers on/off
    muted=$(pacmd list-sinks | grep "muted" | awk '{print $2}')

    if [ "${muted}" == "yes" ]; then
      icon_vol=${icon_vol_mute}
      vol_cicon=${color_netdown}
    elif [ "${line#???}" -gt 100 ]; then
      icon_vol=${icon_vol_hi}
      vol_cicon=${color_alert}
    elif [ "${line#???}" -ge 75 ]; then
      icon_vol=${icon_vol_hi}
      vol_cicon=${color_icon}
    elif [ "${line#???}" -ge 50 ]; then
      icon_vol=${icon_vol_med}
      vol_cicon=${color_icon}
    elif [ "${line#???}" -ge 1 ]; then
      icon_vol=${icon_vol_lo}
      vol_cicon=${color_icon}
    elif [ "${line#???}" -eq 0 ]; then
      icon_vol=${icon_vol_off}
      vol_cicon=${color_netdown}
    fi

    vol="%{F${color_sec_b2}}${sep_left}%{F${vol_cicon} B${color_sec_b2}} %{T2}${icon_vol}"
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

    bright="%{F${color_icon} B${color_sec_b2}} %{T2}${icon_bright}"
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

    ethernet="%{F${color_sec_b1}}${sep_left}%{F${eth_cicon} B${eth_cback}}%{T2} %{F${eth_cicon}}${ethup}"
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

    wifi="%{F${wlan_cicon} B${wlan_cback}}%{T2} %{F${wlan_cicon}}${wlanup}"
    ;;

  BAT*)
    # charger
    oncharger=$(cat /sys/class/power_supply/AC/online)

    if [ "${oncharger}" == "1" ]; then
      icon_bat=${icon_bat_charge}
    # battery level
    elif [ "${line#???}" -ge 95 ]; then
      icon_bat=${icon_bat_full}
    elif [ "${line#???}" -ge 85 ]; then
      icon_bat=${icon_bat_90}
    elif [ "${line#???}" -ge 75 ]; then
      icon_bat=${icon_bat_80}
    elif [ "${line#???}" -ge 65 ]; then
      icon_bat=${icon_bat_70}
    elif [ "${line#???}" -ge 55 ]; then
      icon_bat=${icon_bat_60}
    elif [ "${line#???}" -ge 45 ]; then
      icon_bat=${icon_bat_50}
    elif [ "${line#???}" -ge 35 ]; then
      icon_bat=${icon_bat_40}
    elif [ "${line#???}" -ge 25 ]; then
      icon_bat=${icon_bat_30}
      bat_cicon=${color_warn}
    elif [ "${line#???}" -ge 15 ]; then
      icon_bat=${icon_bat_20}
      bat_cicon=${color_warn}
    elif [ "${line#???}" -gt "${bat_alert}" ]; then
      icon_bat=${icon_bat_10}
      bat_cicon=${color_warn}
    elif [ "${line#???}" -le "${bat_alert}" ]; then
      icon_bat=${icon_bat_low}
      bat_cicon=${color_alert}
      (dunstify -u critical "BATTERY CRITICALLY LOW" "Please plug in AC adapter immediately to avoid losing work")
    fi

    bat="%{F${bat_cicon} B${color_sec_b1} T2} ${icon_bat}"
    ;;

  CLK*)
    # time
    time="%{F${color_sec_b2}}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T2}${icon_clock}%{F${color_fore} T1} ${line#???}%{T-}"
    ;;

  esac

  # and finally, output
  printf "%s\n" "%{l}${mode}${layout}%{A4:i3-msg workspace next:}%{A5:i3-msg workspace previous:}${wsp}%{A}%{A}${title}%{r}%{A1:exec chromium 'www.archlinux.org' &:} ${updates}%{A} %{A1:exec chromium 'mail.google.com' &:}${gmail}%{A}${stab}%{A1:exec $(dirname $0)/scripts/volindicator.sh &:}%{A3:pulseaudio-ctl mute:}%{A4:pulseaudio-ctl up:}%{A5:pulseaudio-ctl down:}${vol}%{A}%{A}%{A}%{A} %{A1:exec $(dirname $0)/scripts/brightindicator.sh &:}%{A4:xbacklight -inc 5:}%{A5:xbacklight -dec 5:}${bright}%{A}%{A}%{A}${stab}%{A1:exec $(dirname $0)/scripts/click_eth.sh &:}${ethernet}%{A} %{A1:exec $(dirname $0)/scripts/click_wifi.sh &:}${wifi}%{A} %{A1:exec $(dirname $0)/scripts/click_bat.sh &:}${bat}%{A}${stab}%{A1:exec chromium 'calendar.google.com' &:}${time}%{A}${stab}%{F- B-}"
done
