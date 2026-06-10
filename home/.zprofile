# Start hyprland via UWSM if logged into VT1
if [[ -z $DISPLAY && $TTY = /dev/tty1 ]]; then
  if uwsm check may-start; then
    exec uwsm start hyprland.desktop &> /dev/null
  fi
fi
