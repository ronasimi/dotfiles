# Disable HiDPI scaling
export WINIT_HIDPI_FACTOR=1.0
export WINIT_X11_SCALE_FACTOR=1.0

# Enable trash-cli for Atom
export ELECTRON_TRASH=trash-cli

# Start Xorg if logged into VT1
[[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1 &> /dev/null
