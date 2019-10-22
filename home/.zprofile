export WINIT_HIDPI_FACTOR=1.0
[[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1 &> /dev/null
