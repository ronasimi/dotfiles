# Disable HiDPI scaling
export WINIT_HIDPI_FACTOR=1.0
export WINIT_X11_SCALE_FACTOR=1.0

# Firefox nicer scroll
export MOZ_USE_XINPUT2=1

# Start Xorg if logged into VT1
[[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1 &> /dev/null
