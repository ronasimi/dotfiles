# Disable HiDPI scaling
export WINIT_HIDPI_FACTOR=1.0
export WINIT_X11_SCALE_FACTOR=1.0

# Start Xorg if logged into VT1
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx > /dev/null 2>&1
fi
