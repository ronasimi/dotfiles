#!/bin/bash
#
# Input parser for i3 bar
# Feb 22 2018 - ronasimi

# config
. $(dirname $0)/i3_lemonbar_config

# min init
title="%{F${color_head} B${color_sec_b2}}${sep_right}%{F${color_head} B${color_sec_b2}%{T2} ${icon_prog} %{F${color_sec_b2} B-}${sep_right}%{F- B- T1}"

# parser
while read -r line ; do
  case $line in
    SYS*)
      # conky=, 0 = wday, 1 = mday, 2 = month, 3 = time, 4 = cpu, 5 = cpu temp, 6 = memory percent, 7 = disk used /, 8 = eth up/down, 9 = wifi up/down, 10 = tether up/down, 11 = a/c status, 13 = battery percent,
      sys_arr=(${line#???})

      # date
      if [ ${res_w} -gt 1024 ]; then
        date="${sys_arr[0]} ${sys_arr[1]} ${sys_arr[2]}"
      else
        date="${sys_arr[1]} ${sys_arr[2]}"
      fi
      date="%{F${color_wsp}}${sep_left}%{F${color_back} B${color_wsp}} %{T2}${icon_cal}%{F- T1}%{F${color_back}} ${date}"

      # time
      time="%{F${color_head}}${sep_left}%{F${color_back} B${color_head}} %{T2}${icon_clock}%{F- T1}%{F${color_back}} ${sys_arr[3]} %{F- B-}"

      # cpu
      if [ ${sys_arr[4]} -gt ${cpu_alert} ]; then
        cpu_cback=${color_cpu}; cpu_cicon=${color_icon}; cpu_cfore=${color_fore};
      else
        cpu_cback=${color_sec_b2}; cpu_cicon=${color_icon}; cpu_cfore=${color_fore};
      fi
      cpu="%{F${cpu_cback}}${sep_left}%{F${cpu_cicon} B${cpu_cback}} %{T2}${icon_cpu}%{F${cpu_cfore} T1} ${sys_arr[4]}%"

      # temperature
      if [ ${sys_arr[5]} -ge ${temp_alert} ]; then
        temp_cback=${color_cpu}; temp_cicon=${color_icon}; temp_cfore=${color_fore};
      else
        temp_cback=${color_sec_b1}; temp_cicon=${color_icon}; cpu_cfore=${color_fore};
      fi
      heat="%{F${temp_cback}}${sep_left}%{F${temp_cicon} B${temp_cback}} %{T2}${icon_temp}%{F- T1} ${sys_arr[5]}°C"

      # mem
      mem="%{F${color_sec_b2}}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T2}${icon_mem}%{F${color_fore} T1} ${sys_arr[6]}"

      # disk /
      diskr="%{F${color_sec_b1}}${sep_left}%{F${color_icon} B${color_sec_b1}} %{T2}${icon_hd} %{F- T1}${sys_arr[7]}%"

      # brightness
      blDir='/sys/class/backlight/intel_backlight'
      bright_cur=$(cat $blDir/actual_brightness) # current brightness
      bright_max=$(cat $blDir/max_brightness)    # maximum brightness
      bright_pct=$(echo "scale=3; ($bright_cur/$bright_max)*100" | bc | awk '{print int($1+0.5)}')
      bright="%{F${color_sec_b2}}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T2}${icon_bright} %{F- T1}${bright_pct}%"

      # ethernet
      eth_cback=${color_sec_b1}; eth_cfore=${color_fore};
      if [ "${sys_arr[8]}" == "down" ]; then
        ethup=${icon_ethdown}; eth_cicon=${color_fore};
      else
        ethup=${icon_ethup}; eth_cicon=${color_icon};
      fi
      ethernet="%{F${eth_cback}}${sep_left}%{F${eth_cicon} B${eth_cback}} %{T2}%{F${eth_cicon} T1}${ethup}"

      # wlan
      wlan_cback=${color_sec_b1}; wlan_cfore=${color_fore};
      if [ "${sys_arr[9]}" == "down" ]; then
        wlanup=${icon_wifi_down}; wlan_cicon=${color_fore};
      else
        wlanup=${icon_wifi_up}; wlan_cicon=${color_icon};
      fi
      wifi="%{F${wlan_cback}}${sep_left}%{F${wlan_cicon} B${wlan_cback}} %{T2}%{F${wlan_cicon} T1}${wlanup}"

      # tether
      teth_cback=${color_sec_b1}; teth_cicon=${color_icon}; teth_cfore=${color_fore}
      if [ "${sys_arr[10]}" == "down" ]; then
        tethup=${icon_tether_down}; teth_cicon=${color_fore};
      else
        tethup=${icon_tether_up}; teth_cicon=${color_icon};
      fi;
      tether="%{F${teth_cback}}${sep_left}%{F${teth_cicon} B${teth_cback}} %{T2}%{F${teth_cicon} T1}${tethup}"

      # bat
      if [ "${sys_arr[11]}" != "off" ]; then
        icon_bat=${icon_charge};
      else
        if [ "${sys_arr[12]}" -ge 95 ]; then
          icon_bat=${icon_full};
        elif [ "${sys_arr[12]}" -ge 85 ]; then
          icon_bat=${icon_90};
        elif [ "${sys_arr[12]}" -ge 75 ]; then
          icon_bat=${icon_80};
        elif [ "${sys_arr[12]}" -ge 65 ]; then
          icon_bat=${icon_70};
        elif [ "${sys_arr[12]}" -ge 55 ]; then
          icon_bat=${icon_60};
        elif [ "${sys_arr[12]}" -ge 45 ]; then
          icon_bat=${icon_50};
        elif [ "${sys_arr[12]}" -ge 35 ]; then
          icon_bat=${icon_40};
        elif [ "${sys_arr[12]}" -ge 25 ]; then
          icon_bat=${icon_30};
        elif [ "${sys_arr[12]}" -ge 15 ]; then
          icon_bat=${icon_20};
        elif [ "${sys_arr[12]}" -gt ${bat_alert} ]; then
          icon_bat=${icon_10};
        fi
      fi
      if [ ${sys_arr[12]} -le ${bat_alert} ]; then
        bat_cback=${color_cpu}; bat_cicon=${color_icon}; bat_cfore=${color_fore}; icon_bat=${icon_low};
      else
        bat_cback=${color_sec_b2}; bat_cicon=${color_icon}; bat_cfore=${color_fore};
      fi
      bat="%{F${bat_cback}}${sep_left}%{F${bat_cicon} B${bat_cback}} %{T2}${icon_bat}%{F${bat_cfore} T1} ${sys_arr[12]}%"
      ;;

    VOL*)
      # Volume
      isMuted=$(pacmd list-sinks | grep "muted" | cut -c 9-10)
      if [ "${isMuted}" == "ye" ]; then
        icon_vol="";
      else
        icon_vol="";
      fi
      vol="%{F${color_sec_b1}}${sep_left}%{F${color_icon} B${color_sec_b1}} %{T2}${icon_vol}%{F${color_fore} T1} ${line#???}"
      ;;

    GMA*)
      # Gmail
      gmail="${line#???}"
      if [ "${gmail}" != "0" ]; then
        mail_cback=${color_mail}; mail_cicon=${color_back}; mail_cfore=${color_back};
      else
        mail_cback=${color_sec_b1}; mail_cicon=${color_icon}; mail_cfore=${color_fore};
      fi
      gmail="%{F${mail_cback}}${sep_left}%{F${mail_cicon} B${mail_cback}} %{T2}${icon_mail}%{F${mail_cfore} T1} ${gmail}"
      ;;

    WSP*)
      # I3 Workspaces
      wsp="%{F${color_back} B${color_head}} %{T2}${icon_wsp}%{T1}"
      set -- ${line#???}
      while [ $# -gt 0 ] ; do
        case $1 in
          FOC*)
            wsp="${wsp}%{F${color_head} B${color_wsp}}${sep_right}%{F${color_back} B${color_wsp} T1} ${1#???} %{F${color_wsp} B${color_head}}${sep_right}"
            ;;
          INA*|URG*|ACT*)
            wsp="${wsp}%{F${color_disable} T1} ${1#???} "
            ;;
        esac
        shift
      done
      ;;

    WIN*)
      # window title
      title=$(xprop -id ${line#???} | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)
      title="%{F${color_head} B${color_sec_b1}}${sep_right}%{F${color_icon} B${color_sec_b1} T2} ${icon_prog} %{F${color_sec_b1} B-}%{F- B- T1}%{F${color_sec_b1}}${sep_right}%{F${color_icon}} ${title}"
      ;;
  esac

  # And finally, output
  printf "%s\n" "%{l}${wsp}${title} %{r}${gmail}${stab}${cpu}${stab}${heat}${stab}${mem}${stab}${diskr}${stab}${bright}${stab}${vol}${stab}${bat}${stab}${ethernet}${wifi}${tether}${stab}${date}${stab}${time}"
done
