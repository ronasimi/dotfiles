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
. $(dirname $0)/i3_lemonbar_config

# min init
title="%{F${color_head} B${color_sec_b1}}${sep_right}%{F${color_icon} B${color_sec_b1} T2} ${icon_prog} %{F${color_sec_b1}}%{B- T1}${sep_right}%{F${color_title}} ${title}"

# parser

while read -r line ; do

        # date/time
        currenttime=$(date +"%a %b %d %R")
        clock=$(echo "$currenttime" | cut -d " " -f 4)
        if [ ${res_w} -gt 1024 ]; then
                day=$(echo "$currenttime" | cut -d " " -f 1-3)
        else
                day=$(echo "$currenttime" | cut -d " " -f 2-3)
        fi

        # date
        date="%{F${color_wsp}}${sep_left}%{F${color_icon_dark} B${color_wsp}} %{T2}${icon_cal}%{F- T1}%{F${color_icon_dark}} ${day}"

        # time
        time="%{F${color_head}}${sep_left}%{F${color_icon_dark} B${color_head}} %{T2}${icon_clock}%{F- T1}%{F${color_icon_dark}} ${clock} %{F- B-}"

        case $line in
                SYS*)
                        # conky= 0 = cpu percent, 1 = memory used, 2 = cpu temperature
                        sys_arr=(${line#???})

                        # cpu
                        if [ ${sys_arr[0]} -gt ${cpu_alert} ]; then
                                cpu_cback=${color_alert}; cpu_cicon=${color_icon}; cpu_cfore=${color_fore};
                        else
                                cpu_cback=${color_sec_b1}; cpu_cicon=${color_icon}; cpu_cfore=${color_fore};
                        fi

                        cpu="%{F${cpu_cback}}${sep_left}%{F${cpu_cicon} B${cpu_cback}} %{T2}${icon_cpu}%{F${cpu_cfore} T1} ${sys_arr[0]}%"

                        # mem
                        mem="%{F${color_sec_b1}}${sep_left}%{F${color_icon} B${color_sec_b1}} %{T2}${icon_mem}%{F${color_fore} T1} ${sys_arr[1]}"

                        # temperature
                        if [ ${sys_arr[2]} -gt ${temp_alert} ]; then
                                temp_cback=${color_alert}; temp_cicon=${color_icon}; temp_cfore=${color_fore};
                        else
                                temp_cback=${color_sec_b2}; temp_cicon=${color_icon}; cpu_cfore=${color_fore};
                        fi

                        heat="%{F${temp_cback}}${sep_left}%{F${temp_cicon} B${temp_cback}} %{T2}${icon_temp}%{F- T1} ${sys_arr[2]}°C"
                        ;;

                ETH*)
                        # ethernet
                        eth_cback=${color_sec_b1}; eth_cfore=${color_fore};

                        if [ "${line#???}" == "connected" ]; then
                                ethup=${icon_ethup}; eth_cicon=${color_icon};
                        else
                                ethup=${icon_ethdown}; eth_cicon=${color_netdown};
                        fi

                        ethernet="%{F${eth_cback}}${sep_left}%{F${eth_cicon} B${eth_cback}} %{T2}%{F${eth_cicon} T1}${ethup}"
                        ;;

                WFI*)
                        # wlan
                        wlan_cback=${color_sec_b1}; wlan_cfore=${color_fore};

                        if [ "${line#???}" == "connected" ]; then
                                wlanup=${icon_wifi_up}; wlan_cicon=${color_icon};
                        else
                                wlanup=${icon_wifi_down}; wlan_cicon=${color_netdown};
                        fi

                        wifi="%{F${wlan_cback}}${sep_left}%{F${wlan_cicon} B${wlan_cback}} %{T2}%{F${wlan_cicon} T1}${wlanup}"
                        ;;

                VOL*)
                        # Volume
                        isMuted=$(pacmd list-sinks | grep "muted" | cut -c 9)

                        if [ "${isMuted}" == "y" ]; then
                                icon_vol="";
                        else
                                icon_vol="";
                        fi

                        vol="%{F${color_sec_b1}}${sep_left}%{F${color_icon} B${color_sec_b1}} %{T2}${icon_vol}%{F${color_fore} T1} ${line#???}"
                        ;;

                BRI*)
                        # brightness
                        bright="%{F${color_sec_b2}}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T2}${icon_bright} %{F- T1}${line#???}%"
                        ;;

                BAT*)
                        # charger
                        oncharger=$(cat /sys/class/power_supply/AC/online)

                        if [ "${oncharger}" == "1" ]; then
                                icon_bat=${icon_charge};
                                # battery level
                        elif [ "${line#???}" -ge 95 ]; then
                                icon_bat=${icon_full};
                        elif [ "${line#???}" -ge 85 ]; then
                                icon_bat=${icon_90};
                        elif [ "${line#???}" -ge 75 ]; then
                                icon_bat=${icon_80};
                        elif [ "${line#???}" -ge 65 ]; then
                                icon_bat=${icon_70};
                        elif [ "${line#???}" -ge 55 ]; then
                                icon_bat=${icon_60};
                        elif [ "${line#???}" -ge 45 ]; then
                                icon_bat=${icon_50};
                        elif [ "${line#???}" -ge 35 ]; then
                                icon_bat=${icon_40};
                        elif [ "${line#???}" -ge 25 ]; then
                                icon_bat=${icon_30};
                        elif [ "${line#???}" -ge 15 ]; then
                                icon_bat=${icon_20};
                        elif [ "${line#???}" -gt ${bat_alert} ]; then
                                icon_bat=${icon_10};
                        fi

                        if [ ${line#???} -le ${bat_alert} ]; then
                                bat_cback=${color_alert}; bat_cicon=${color_icon}; bat_cfore=${color_fore}; icon_bat=${icon_low}
                                (notify-send -u critical "BATTERY CRITICALLY LOW" "Please plug in AC adapter immediately to avoid losing work");
                        else
                                bat_cback=${color_sec_b2}; bat_cicon=${color_icon}; bat_cfore=${color_fore};
                        fi

                        bat="%{F${bat_cback}}${sep_left}%{F${bat_cicon} B${bat_cback}} %{T2}${icon_bat}%{F${bat_cfore} T1} ${line#???}%"
                        ;;

                GMA*)
                        # Gmail
                        if [ "${line#???}" != "0" ]; then
                                mail_cback=${color_mail}; mail_cicon=${color_icon}; mail_cfore=${color_fore};
                        else
                                mail_cback=${color_sec_b1}; mail_cicon=${color_icon}; mail_cfore=${color_fore};
                        fi

                        gmail="%{F${mail_cback}}${sep_left}%{F${mail_cicon} B${mail_cback}} %{T2}${icon_mail}%{F${mail_cfore} T1} ${line#???}"
                        ;;

                UPD*)
                        # Updates
                        if [ "${line#???}" != "0" ]; then
                                upd_cback=${color_upd}; upd_cicon=${color_icon_dark}; upd_cfore=${color_back};
                        else
                                upd_cback=${color_sec_b2}; upd_cicon=${color_icon}; upd_cfore=${color_fore};
                        fi

                        updates="%{F${upd_cback}}${sep_left}%{F${upd_cicon} B${upd_cback}} %{T2}${icon_arch}%{F${upd_cfore} T1} ${line#???}"
                        ;;

                WSP*)
                        # I3 Workspaces
                        wsp="%{F${color_icon_dark} B${color_head}} %{T2}${icon_wsp}%{T1}"
                        set -- ${line#???}

                        while [ $# -gt 0 ] ; do
                                case $1 in
                                        FOC*)
                                                wsp="${wsp}%{F${color_head} B${color_wsp}}${sep_right}%{F${color_icon_dark} B${color_wsp} T1} ${1#???} %{F${color_wsp} B${color_head}}${sep_right}"
                                                ;;
                                        INA*|ACT*)
                                                wsp="${wsp}%{F${color_ina} T1} ${1#???} "
                                                ;;
                                        URG*)
                                                wsp="${wsp}%{F${color_head} B${color_alert}}${sep_right}%{F${color_fore} B${color_alert} T1} ${1#???} %{F${color_alert} B${color_head}}${sep_right}"
                                                ;;
                                esac
                                shift
                        done
                        ;;

                WIN*)
                        # window title
                        title=$(xprop -id ${line#???} | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)

                        title="%{F${color_head} B${color_sec_b1}}${sep_right}%{F${color_icon} B${color_sec_b1} T2} ${icon_prog} %{F${color_sec_b1}}%{B- T1}${sep_right}%{F${color_title}} ${title}"
                        ;;
        esac

        # And finally, output
        printf "%s\n" "%{l}%{A4:i3-msg workspace next:}%{A5:i3-msg workspace previous:}${wsp}%{A}%{A}${title}%{r}%{A1:urxvtc -g 60x7+860+28 -name "htop" -e htop:}${cpu}${stab}${heat}${stab}${mem}${stab}%{A}%{A1:exec chromium 'www.archlinux.org' &:}${updates}${stab}%{A}%{A1:exec chromium 'mail.google.com' &:}${gmail}${stab}%{A}%{A4:xbacklight -inc 5:}%{A5:xbacklight -dec 5:}${bright}${stab}%{A}%{A}%{A1:pulseaudio-ctl mute:}%{A4:pulseaudio-ctl up:}%{A5:pulseaudio-ctl down:}${vol}${stab}%{A}%{A}%{A}%{A1:exec $(dirname $0)/scripts/battime.sh &:}${bat}${stab}%{A}%{A1:urxvtc -g 80x24-14+28 -name "nmtui" -e nmtui-connect:}${ethernet}${wifi}${stab}%{A}%{A1:exec chromium 'calendar.google.com' &:}${date}${stab}${time}%{A}"
done
