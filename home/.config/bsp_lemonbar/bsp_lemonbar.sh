. "$(dirname $0)"/bsp_lemonbar_config

if [ "$(pgrep -cx "$(basename $0)")" -gt 1 ]; then
  printf "%s\n" "The status bar is already running." >&2
  exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "$panel_fifo" ] && rm "$panel_fifo"
mkfifo "$panel_fifo"

xtitle -sf 'TTL%s\n' > "$panel_fifo" &
"$(dirname $0)"/scripts/clk > "${panel_fifo}" &
bspc subscribe report > "$panel_fifo" &

"$(dirname $0)"/bsp_lemonbar_parser.sh < "$panel_fifo" | lemonbar -a "$clickables" -n "$panel_wm_name" -g x$geometry -f "$font" -f "$iconfont" -F "$COLOR_DEFAULT_FG" -B "$COLOR_DEFAULT_BG" | sh &

wid=$(xdo id -m -a "$panel_wm_name")
xdo above -t "$(xdo id -N Bspwm -n root | sort | head -n 1)" "$wid"

wait
