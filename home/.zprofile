# Start hyprland if logged into VT1
if [[ -z $DISPLAY && $TTY = /dev/tty1 ]]; then
  export MOZ_ENABLE_WAYLAND=1
  exec /home/ron/.bin/wrappedhl &> /dev/null
fi
