#!/usr/bin/env dash
# Fast Wi-Fi status for hyprlock. One bounded `iw` query; no pipelines/polling.

iface=${HYPR_WIFI_IFACE:-wlp3s0}
ssid='Disconnected'
speed=''

# Keep a broken/stalled netlink query from delaying a lockscreen refresh.
link=$(timeout 0.5s iw dev "$iface" link 2>/dev/null) || link=''

if [ -n "$link" ]; then
    while IFS= read -r line; do
        case "$line" in
            *'SSID: '*)
                ssid=${line#*SSID: }
                ;;
            *'rx bitrate: '*)
                speed=${line#*rx bitrate: }
                ;;
        esac
    done <<EOF_LINK
$link
EOF_LINK
fi

printf '󰖩 %s\n%s\n' "$ssid" "$speed"
