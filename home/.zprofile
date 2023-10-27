# Start hyprland if logged into VT1
if [[ -z $DISPLAY && $TTY = /dev/tty1 ]]; then
  exec /home/ron/.bin/wrappedhl &> /dev/null
fi
