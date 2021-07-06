# Disable HiDPI scaling
export WINIT_HIDPI_FACTOR=1.0
export WINIT_X11_SCALE_FACTOR=1.0

# Enable trash-cli for Atom
export ELECTRON_TRASH=trash-cli

# Firefox flags
export MOZ_DISABLE_RDD_SANDBOX=1
export MOZ_X11_EGL=1
export MOZ_USE_XINPUT2=1

# Start Xorg if logged into VT1
[[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1 &> /dev/null
