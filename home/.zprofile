# Disable HiDPI scaling
export WINIT_HIDPI_FACTOR=1.0

# Start Xorg if logged into VT1
if "$(fgconsole 2>/dev/null || echo -1)" -eq 1; then
  exec startx -- vt1 &> /dev/null
fi
