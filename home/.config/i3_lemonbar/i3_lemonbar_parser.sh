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
title="%{F${color_head} B-}${sep_right}%{F${color_title} T2} ${win}"

# parser

while read -r line ; do

	case $line in
		MOD*)
			# binding mode
			if [ "${line#???}" == "resize" ]; then
				icon_mode=${icon_resize}; mode_cicon=${color_alert};
			else
				icon_mode=${icon_default}; mode_cicon=${color_fore};
			fi

			mode="%{F${mode_cicon} B${color_wsp}$T3} ${icon_mode}"
			;;

		LAY*)
			# container layout
			if [ "${line#???}" == "splith" ]; then
				icon_layout=${icon_splith};
			elif [ "${line#???}" == "splitv" ]; then
				icon_layout=${icon_splitv};
			elif [ "${line#???}" == "tabbed" ]; then
				icon_layout=${icon_tabbed};
			elif [ "${line#???}" == "stacked" ]; then
				icon_layout=${icon_stacked};
			fi

			layout="%{F${color_fore} B${color_wsp}} %{T3}${icon_layout} %{F${color_wsp} B${color_head}}%{T1}${sep_right}"
			;;

		WSP*)
			# I3 Workspaces
			wsp="%{B${color_head}}"
			set -- ${line#???}

			while [ $# -gt 0 ] ; do
				case $1 in
					FOC*)
						wsp="${wsp}%{F${color_head} B${color_wsp}}${sep_right}%{F${color_act} B${color_wsp} T3} ${1#???} %{F${color_wsp} B${color_head}}${T1}${sep_right}"
						;;
					INA*|ACT*)
						wsp="${wsp}%{F${color_head} B${color_head}}${sep_right}%{F${color_ina} B${color_head} T3} ${1#???} %{F${color_head} B${color_head}}${T1}${sep_right}"
						;;
					URG*)
						wsp="${wsp}%{F${color_head} B${color_alert}}${sep_right}%{F${color_act} B${color_alert} T3} ${1#???} %{F${color_alert} B${color_head}}${T1}${sep_right}"
						;;
				esac
				shift
			done
			;;

		WIN*)
			# window title
			title="%{F${color_head} B-}${T1}${sep_right}%{F${color_title} T2} ${line#???}"
			;;

		UPD*)
			# Updates
			if [ "${line#???}" != "0" ]; then
				upd_cback=${color_upd}; upd_cicon=${color_icon_dark}; upd_cfore=${color_back};
			else
				upd_cback=${color_sec_b1}; upd_cicon=${color_icon}; upd_cfore=${color_fore};
			fi
			updates="%{F${upd_cback} T1}${sep_left}%{F${upd_cicon} B${upd_cback}} %{T3}${icon_arch}%{F${upd_cfore} T1} ${line#???}"
			;;

		GMA*)
			# Gmail
			if [ "${line#???}" != "0" ]; then
				mail_cback=${color_mail}; mail_cicon=${color_icon}; mail_cfore=${color_title};
			else
				mail_cback=${color_sec_b2}; mail_cicon=${color_icon}; mail_cfore=${color_fore};
			fi
			gmail="%{F${mail_cback} T1}${sep_left}%{F${mail_cicon} B${mail_cback}} %{T3}${icon_mail}%{F${mail_cfore} T1} ${line#???}"
			;;

		BRI*)
			# Brightness
			if [ "${line#???}" == 100 ]; then
				icon_bright=${icon_bright_100};
			elif [ "${line#???}" -ge 80 ]; then
				icon_bright=${icon_bright_80};
			elif [ "${line#???}" -ge 51 ]; then
				icon_bright=${icon_bright_51};
			elif [ "${line#???}" -ge 31 ]; then
				icon_bright=${icon_bright_31};
			elif [ "${line#???}" -ge 19 ]; then
				icon_bright=${icon_bright_19};
			elif [ "${line#???}" -ge 11 ]; then
				icon_bright=${icon_bright_11};
			elif [ "${line#???}" -ge 6 ]; then
				icon_bright=${icon_bright_6};
			fi

			bright="%{F${color_sec_b1}}${sep_left}%{F${color_icon} B${color_sec_b1}} %{T3}${icon_bright} %{F- T1}${line#???}%"
			;;

		VOL*)
			# Speakers on/off
			muted=$(pacmd list-sinks | grep "muted" | awk '{print $2}')

			if [ "${muted}" == "yes" ]; then
				icon_vol=${icon_vol_mute};
			elif [ "${line#???}" -ge 75 ]; then
				icon_vol=${icon_vol_hi};
			elif [ "${line#???}" -ge 50 ]; then
				icon_vol=${icon_vol_med};
			elif [ "${line#???}" -ge 1 ]; then
				icon_vol=${icon_vol_lo};
			elif [ "${line#???}" -eq 0 ]; then
				icon_vol=${icon_vol_off};
			fi

			vol="%{F${color_sec_b2}}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T3}${icon_vol} %{F- T1}${line#???}%"

			;;

		ETH*)
			# ethernet
			eth_cback=${color_sec_b1}; eth_cfore=${color_fore};

			if [ "${line#???}" == "connected" ]; then
				ethup=${icon_ethup}; eth_cicon=${color_icon};
			else
				ethup=${icon_ethdown}; eth_cicon=${color_netdown};
			fi

			ethernet="%{F${eth_cback}}${sep_left}%{F${eth_cicon} B${eth_cback}} %{T3}%{F${eth_cicon} T1}${ethup}"
			;;

		WFI*)
			# wlan
			wlan_cback=${color_sec_b1}; wlan_cfore=${color_fore};

			if [ "${line#???}" == "connected" ]; then
				wlanup=${icon_wifi_up}; wlan_cicon=${color_icon};
			else
				wlanup=${icon_wifi_down}; wlan_cicon=${color_netdown};
			fi

			wifi="%{F${wlan_cback}}${sep_left}%{F${wlan_cicon} B${wlan_cback}} %{T3}%{F${wlan_cicon} T1}${wlanup}"
			;;

		BAT*)
			# charger
			oncharger=$(cat /sys/class/power_supply/AC/online)

			if [ "${oncharger}" == "1" ]; then
				icon_bat=${icon_bat_charge};
				# battery level
			elif [ "${line#???}" -ge 95 ]; then
				icon_bat=${icon_bat_full};
			elif [ "${line#???}" -ge 85 ]; then
				icon_bat=${icon_bat_90};
			elif [ "${line#???}" -ge 75 ]; then
				icon_bat=${icon_bat_80};
			elif [ "${line#???}" -ge 65 ]; then
				icon_bat=${icon_bat_70};
			elif [ "${line#???}" -ge 55 ]; then
				icon_bat=${icon_bat_60};
			elif [ "${line#???}" -ge 45 ]; then
				icon_bat=${icon_bat_50};
			elif [ "${line#???}" -ge 35 ]; then
				icon_bat=${icon_bat_40};
			elif [ "${line#???}" -ge 25 ]; then
				icon_bat=${icon_bat_30};
			elif [ "${line#???}" -ge 15 ]; then
				icon_bat=${icon_bat_20};
			elif [ "${line#???}" -gt "${bat_alert}" ]; then
				icon_bat=${icon_bat_10};
			fi

			if [ "${line#???}" -le "${bat_alert}" ]; then
				bat_cback=${color_alert}; bat_cicon=${color_icon}; bat_cfore=${color_fore}; icon_bat=${icon_bat_low}
				(notify-send -u critical "BATTERY CRITICALLY LOW" "Please plug in AC adapter immediately to avoid losing work");
			else
				bat_cback=${color_sec_b2}; bat_cicon=${color_icon}; bat_cfore=${color_fore};
			fi

			bat="%{F${bat_cback}}${sep_left}%{F${bat_cicon} B${bat_cback}} %{T3}${icon_bat}%{F${bat_cfore} T1} ${line#???}%"
			;;

		DAY*)
			# date
			date="%{F${color_sec_b1}}${sep_left}%{F${color_icon} B${color_sec_b1}} %{T3}${icon_cal}%{F${color_fore} T1} ${line#???}"
			;;

		CLK*)
			# time
			time="%{F${color_sec_b2}}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T3}${icon_clock}%{F${color_fore} T1} ${line#???} %{F- B-}"
			;;

	esac

	# And finally, output
	printf "%s\n" "%{l}${mode}${layout}%{A4:i3-msg workspace next:}%{A5:i3-msg workspace previous:}${wsp}%{A}%{A}${title}%{r}%{A1:exec chromium 'www.archlinux.org' &:}${updates}${stab}%{A}%{A1:exec chromium 'mail.google.com' &:}${gmail}${stab}%{A}%{A4:xbacklight -inc 5:}%{A5:xbacklight -dec 5:}${bright}${stab}%{A}%{A}%{A3:pulseaudio-ctl mute:}%{A4:pulseaudio-ctl up:}%{A5:pulseaudio-ctl down:}${vol}${stab}%{A}%{A}%{A}%{A1:exec $(dirname $0)/scripts/click_eth.sh &:}${ethernet}%{A}%{A1:exec $(dirname $0)/scripts/click_wifi.sh &:}${wifi}${stab}%{A}%{A1:exec $(dirname $0)/scripts/click_bat.sh &:}${bat}${stab}%{A}%{A1:exec chromium 'calendar.google.com' &:}${date}${stab}${time}%{A}"
done
